sub_dev() {
  if [ "$#" -eq 0 ]; then
    printf "  $BO${LY}Usage: $MA$0$RE ${BO}dev $BO${GY}[${LY}options $GY...] ${GY}<${LY}DDLC install$GY>$RE\n"
    printf "  $BO${LY}Clueless? Type $MA$0$RE ${BO}dev --help$RE $BO${LY}to see supported parameters and options.$RE\n\n\n"
    exit
  fi

  while [ "$#" -gt 0 ]; do
    arg="$1"
    shift

    if [ -z "$skipopt" ]; then
      case "$arg" in
        "-h"|"--help")
          printf "  $BO${LY}Usage: $MA$0$RE ${BO}dev $BO${GY}[${LY}options $GY...] ${GY}<${LY}DDLC install$GY>$RE\n\n"
          printf "  $BO${LY}Supported parameters:$RE\n\n"
          printf "    $BO${LY}DDLC install  $RE${LY}location of existing DDLC install\n\n"
          printf "  $BO${LY}Supported options:$RE\n\n"
          printf "    $BO${LY}-h, --help    $RE${LY}show this text and exit\n\n\n"
          exit
          ;;
      esac
    fi

    if [ -z "$dir" ]; then
      dir="$arg"
      continue
    else
      printf "  $BO${LY}Unrecognized parameter $RE$BO$arg${LY}.$RE\n\n"
      printf "  $BO${LY}Usage: $MA$0 $RE${BO}dev ${GY}[${LY}options $GY...] ${GY}<${LY}DDLC install$GY>$RE\n"
      printf "  $BO${LY}Clueless? Type $MA$0 $RE${BO}dev --help $BO${LY}to see supported commands and options.$RE\n\n\n"
      exit
    fi
  done

  prompt_yes_no() {
    printf "\n\033[1A"
    printf "  $BO$VT?$RE $BO$MA%s $RE$BO$GY(Y/n) $RE" "$1"
    read -r ok

    case "$ok" in
      "")
        printf "\033[1A\r\033[K  $BO$VT?$RE $BO$MA%s $RE$BO$GY(Y/n) ${RE}Y\n" "$1"
        return 0;;
      "Y"|"y")
        return 0;;
      *)
        return 1;;
    esac
  }


  error_done_wrap() {
    desc="$1"
    printf "  $BO$LY🛠$RE $BO$MA%s... $RE" "$desc"
    cmd="$2"
    shift 2
    if ! err="$("$cmd" "$@" 3>&2 2>&1 1>&3)"; then
      printf "\r\033[K  $BO$RD✘$RE $BO$MA%s... $RE" "$desc"
      printf "$BO${RD}error!\n\n   $err$RE\n\n"
      printf "  $BO$RD✘ $RE$BO${MA}Could not convert this install for development use :($RE\n\n"
      exit 1
    else
      printf "\r\033[K  $BO$GN✔$RE $BO$MA%s... $RE" "$desc"
      printf "$BO${MA}done.$RE\n\n"
    fi
  }


  patch_ddlc_py() {
    if [ ! -f "$dir/DDLC.py" ]; then
      echo "patch: $dir/DDLC.py: no such file or directory." >&2
      return 1
    fi

    cat <<EOF | patch "$dir/DDLC.py" >/dev/null
52a53
>     return gamedir + "/saves"
EOF

  }
  error_done_wrap "Patching DDLC.py" patch_ddlc_py


  if prompt_yes_no "Enable console (Shift+O)?"; then
    add_console() {
      cat > "$dir/game/dev_console.rpy" <<EOF
init python:
    config.console = True
EOF
    }
    error_done_wrap "Enabling console" add_console
  fi


  if prompt_yes_no "Install expressions previewer (EXP PREVIEW topic)?"; then
    install_exp_preview() {
      curl -sL "https://raw.githubusercontent.com/Monika-After-Story/MonikaModDev/master/Monika%20After%20Story/game/dev/dev_exp_previewer.rpy" > "$dir/game/dev_exp_previewer.rpy"
    }
    error_done_wrap "Installing expressions previewer" install_exp_preview
  fi


  if [ -f ~/".renpy/Monika After Story/persistent" ]; then
    if prompt_yes_no "Would you like to copy existing persistent into development install?"; then
        copy_persistent() {
          mkdir -p "$dir/game/saves"
          cp ~/".renpy/Monika After Story/persistent" "$dir/game/saves"
        }
        error_done_wrap "Copying persistent" copy_persistent
    fi
  fi


  printf "  $BO$RD♥$RE $BO$MA%s$RE\n\n" "All done!"
}