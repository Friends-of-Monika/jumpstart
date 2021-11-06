sub_dev() {
  usage() {
    printf "  $BO${LY}Usage: $MA$0$RE ${BO}dev $BO${GY}[${LY}options $GY...] ${GY}<${LY}MAS install$GY>$RE\n$1"
  }

  hint() {
    printf "  $BO${LY}Clueless? Type $MA$0$RE ${BO}dev --help$RE $BO${LY}to see supported parameters and options.$RE\n\n\n"
  }

  if [ "$#" -eq 0 ]; then
    usage
    hint
    exit
  fi

  while [ "$#" -gt 0 ]; do
    arg="$1"
    shift

    if [ -z "$skipopt" ]; then
      case "$arg" in
        "-h"|"--help")
          usage "\n"
          printf "  $BO${LY}Supported parameters:$RE\n\n"
          printf "    $BO${LY}MAS install  $RE${LY}location of existing MAS install\n\n"
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
      usage
      hint
      exit
    fi
  done


  patch_failed() {
    printf "  $BO$RD✘ $RE$BO${MA}Could not convert this install for development use :($RE\n\n"
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
  if ! error_done_wrap "Patching DDLC.py" patch_ddlc_py "\n"; then patch_failed; fi


  if prompt_yes_no "Enable console (Shift+O)?"; then
    add_console() {
      cat > "$dir/game/dev_console.rpy" <<EOF
init python:
    config.console = True
EOF
    }
    if ! error_done_wrap "Enabling console" add_console "\n"; then patch_failed; fi
  fi


  if prompt_yes_no "Install expressions previewer (EXP PREVIEW topic)?"; then
    install_exp_preview() {
      curl -sL "https://raw.githubusercontent.com/Monika-After-Story/MonikaModDev/master/Monika%20After%20Story/game/dev/dev_exp_previewer.rpy" > "$dir/game/dev_exp_previewer.rpy"
    }
    if ! error_done_wrap "Installing expressions previewer" install_exp_preview "\n"; then patch_failed; fi
  fi


  if [ -f ~/".renpy/Monika After Story/persistent" ]; then
    if prompt_yes_no "Would you like to copy existing persistent into development install?"; then
        copy_persistent() {
          mkdir -p "$dir/game/saves"
          cp ~/".renpy/Monika After Story/persistent" "$dir/game/saves"
        }
        if ! error_done_wrap "Copying persistent" copy_persistent "\n"; then patch_failed; fi
    fi
  fi


  printf "  $BO$RD♥$RE $BO$MA%s$RE\n\n" "All done!"
}
