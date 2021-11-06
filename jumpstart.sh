#!/bin/sh


# *** HEADS UP! ***
# This script was auto-generated from separate chunks stored in include/,
# and you SHOULD NOT edit it directly!
# For user's convenience, we've prebuilt it and uploaded it into the repository.
# Whenever you want to submit any changes, EDIT INCLUDED chunks/add more chunks
# in include/ and build.sh script.
# Thanks for peeking here!


#include include/styling
if [ -t 1 ]; then
  F() { printf "\033[%sm" "$1"; }
  RE="$(F 0)"          # Reset color and styling
  BO="$(F 1)"          # Bold
  GN="$(F "38;5;40")"  # Green
  VT="$(F "38;5;129")" # Violet
  RD="$(F "38;5;196")" # Red
  MA="$(F "38;5;213")" # Magenta
  GY="$(F "38;5;239")" # Grey
  LY="$(F "38;5;249")" # Light grey
fi


#include include/banner
echo
echo
printf "               $BO${MA}Jumpstart, a Monika After Story dev install boostrap tool.$RE\n"
printf "                           $BO${MA}Made with $BO$RD♥$RE$BO$MA by friends of Monika.$RE\n"
echo
echo


#include include/no_arguments
if [ "$#" -eq 0 ]; then
  printf "  $BO${LY}Usage: $MA$0 $RE$BO${GY}[${LY}options $GY...] <${MA}command$GY> [${LY}arguments $GY...]$RE\n"
  printf "  $BO${LY}Clueless? Type $MA$0 $RE$BO--help$RE $BO${LY}to see supported commands and options.$RE\n\n\n"
  exit
fi


#include include/error_done_wrap
error_done_wrap() {
  desc="$1"
  printf "  $BO$LY🛠$RE $BO$MA%s... $RE" "$desc"
  cmd="$2"
  shift 2
  if ! err="$("$cmd" "$@" 3>&2 2>&1 1>&3)"; then
    printf "\r\033[K  $BO$RD✘$RE $BO$MA%s... $RE" "$desc"
    printf "$BO${RD}error!\n\n   $err$RE\n\n"
    exit 1
  else
    printf "\r\033[K  $BO$GN✔$RE $BO$MA%s... $RE" "$desc"
    printf "$BO${MA}done.$RE\n\n"
  fi
}


#include include/prompt_yes_no
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


#include include/command/dev
sub_dev() {
  usage() {
    printf "  $BO${LY}Usage: $MA$0$RE ${BO}dev $BO${GY}[${LY}options $GY...] ${GY}<${LY}DDLC install$GY>$RE\n$1"
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
  if ! error_done_wrap "Patching DDLC.py" patch_ddlc_py; then patch_failed; fi


  if prompt_yes_no "Enable console (Shift+O)?"; then
    add_console() {
      cat > "$dir/game/dev_console.rpy" <<EOF
init python:
    config.console = True
EOF
    }
    if ! error_done_wrap "Enabling console" add_console; then patch_failed; fi
  fi


  if prompt_yes_no "Install expressions previewer (EXP PREVIEW topic)?"; then
    install_exp_preview() {
      curl -sL "https://raw.githubusercontent.com/Monika-After-Story/MonikaModDev/master/Monika%20After%20Story/game/dev/dev_exp_previewer.rpy" > "$dir/game/dev_exp_previewer.rpy"
    }
    if ! error_done_wrap "Installing expressions previewer" install_exp_preview; then patch_failed; fi
  fi


  if [ -f ~/".renpy/Monika After Story/persistent" ]; then
    if prompt_yes_no "Would you like to copy existing persistent into development install?"; then
        copy_persistent() {
          mkdir -p "$dir/game/saves"
          cp ~/".renpy/Monika After Story/persistent" "$dir/game/saves"
        }
        if ! error_done_wrap "Copying persistent" copy_persistent; then patch_failed; fi
    fi
  fi


  printf "  $BO$RD♥$RE $BO$MA%s$RE\n\n" "All done!"
}


#include include/command/install
sub_install() {
  usage() {
    printf "  $BO${LY}Usage: $MA$0 $RE${BO}install ${GY}[${LY}options $GY...] ${GY}<${LY}DDLC install$GY>$RE\n$1"
  }

  hint() {
    printf "  $BO${LY}Clueless? Type $MA$0$RE ${BO}install --help$RE $BO${LY}to see supported parameters and options.$RE\n\n\n"
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
      usage
      hint
      exit
    fi
  done
}


#include include/args_processing
usage() {
  printf "  $BO${LY}Usage: $MA$0$RE $BO${GY}[${LY}options $GY...] <${MA}command$GY> [${LY}arguments $GY...]$RE\n$1"
}

hint() {
  printf "  $BO${LY}Clueless? Type $MA$0 $RE${BO}--help $BO${LY}to see supported commands and options.$RE\n\n\n"
}

while [ "$#" -gt 0 ]; do
  arg="$1"
  shift

  if [ -z "$skipopt" ]; then
    case "$arg" in
      "--")
        skipopt=1
        continue
        ;;
      "-h"|"--help")
        usage "\n"
        printf "  $BO${LY}Supported commands:$RE\n\n"
        printf "    $BO${LY}i, install     $RE${LY}install MAS to DDLC install\n"
        printf "    $BO${LY}d, dev         $RE${LY}patch existing Monika After Story install for development use\n\n"
        printf "  $BO${LY}Supported options:$RE\n\n"
        printf "    $BO${LY}-h, --help     $RE${LY}show this text and exit\n\n\n"
        exit
        ;;
      "-"*)
        printf "  $BO${LY}Unrecognized option $RE$BO$arg${LY}.$RE\n\n"
        usage
        hint
        exit
        ;;
    esac
  fi

  case "$arg" in
    "i"|"install")
      sub_install "$@"
      ;;
    "d"|"dev")
      sub_dev "$@"
      ;;
    *)
        printf "  $BO${LY}Unrecognized command $RE$BO$arg${LY}.$RE\n\n"
        usage
        hint
        exit
        ;;
  esac
done


