#!/bin/sh
# shellcheck disable=SC2059

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

echo
echo
printf "               $BO${MA}Jumpstart, a Monika After Story dev install boostrap tool.$RE\n"
printf "                           $BO${MA}Made with $BO$RD♥$RE$BO$MA by friends of Monika.$RE\n"
echo
echo

if [ "$#" -eq 0 ]; then
  printf "  $BO${LY}Usage: $MA$0$RE $BO${GY}[${LY}options $GY...] <${MA}command$GY> [${LY}arguments $GY...]$RE\n"
  printf "  $BO${LY}Clueless? Type $MA$0$RE $BO--help$RE $BO${LY}to see supported commands and options.$RE\n\n\n"
  exit
fi

dir="$1"


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
    printf "$BO${RD}error!\n\n    %s$RE\n\n" "$err"
    printf "  $BO$RD✘ %s$RE\n\n" "Patching failed!"
    exit 1
  else
    printf "\r\033[K  $BO$GN✔$RE $BO$MA%s... $RE" "$desc"
    printf "$BO$MA%s$RE\n\n" "done."
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
