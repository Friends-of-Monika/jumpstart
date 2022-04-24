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
  LE="$(F "38;5;87")"  # Light blue
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


#include include/info_line
info_line() {
  printf "\n\033[1A  $BO$LEℹ$RE $BO$MA%s. $RE\n$2" "$1"
}


#include include/error_done_wrap
error_done_wrap() {
  desc="$1"
  printf "\n\033[1A  $BO$LY🛠$RE $BO$MA%s... $RE" "$desc"
  cmd="$2"
  shift 2

  tmp="$(mktemp)"
  "$cmd" "$@" 2>"$tmp" >/dev/null
  ec="$?"

  if [ "$ec" -ne 0 ]; then
    printf "\n\033[1A\r\033[K  $BO$RD✘$RE $BO$MA%s... $RE" "$desc"
    printf "$BO${RD}error!\n\n   $(cat "$tmp")$RE\n$1"
    rm "$tmp"
    return 1
  else
    printf "\n\033[1A\r\033[K  $BO$GN✔$RE $BO$MA%s... $RE" "$desc"
    printf "$BO${MA}done.$RE\n$1"
    rm "$tmp"
  fi
}


#include include/prompt_yes_no
prompt_yes_no() {
  printf "\n\033[1A"
  printf "  $BO$VT?$RE $BO$MA%s $RE$BO$GY(Y/n) $RE" "$1"
  read -r ok 0<&2

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
    exit 1
  }


  patch_ddlc_py() {
    if [ "$(uname -s)" = "Darwin" ]; then
      dir="$dir/DDLC.app/Contents/Resources/autorun"
    fi
    
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
      curl -sL --fail "https://raw.githubusercontent.com/Monika-After-Story/MonikaModDev/master/Monika%20After%20Story/game/dev/dev_exp_previewer.rpy" > "$dir/game/dev_exp_previewer.rpy"
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

  install_failed() {
    printf "  $BO$RD✘ $RE$BO${MA}Could not add MAS to this DDLC install :($RE\n\n"
    exit 1
  }

  get_rel_url() {
    rel_tmp="$(mktemp)"
    curl -sL --show-error --fail -o "$rel_tmp" "https://api.github.com/repos/monika-after-story/monikamoddev/releases/latest"
  }
  if ! error_done_wrap "Getting latest Monika After Story release" get_rel_url; then install_failed; fi

  name="$(sed -n 's/^[^"]*"name":.*"\([^"]*\)",$/\1/p' "$rel_tmp" | head -n 1)"
  info_line "Latest release: $name" "\n"

  bdu_tmp="$(mktemp -u)"
  sed -n 's/^[^"]*"browser_download_url":.*"\([^"]*\)"$/\1/p' "$rel_tmp" >"$bdu_tmp"
  while read -r url; do
    case "$url" in
      *"-Mod-Dlx"*)
        if prompt_yes_no "Install Deluxe edition (all spritepacks included)?"; then
          dl_url="$url"
          break
        fi
        ;;
      *"-Mod"*)
        dl_url="$url"
        break
        ;;
    esac
  done <"$bdu_tmp"

  if [ -z "$dl_url" ]; then
    echo "Could not find mod package URL" >&2
    return 1
  fi

  rm "$rel_tmp" "$bdu_tmp"

  download_package() {
    pkg_tmp="$(mktemp)"
    curl -sL --show-error --fail -o "$pkg_tmp" "$dl_url"
  }
  if ! error_done_wrap "Downloading package" download_package; then install_failed; fi

  install_package() {
    (
      set -e
      cd "$dir/game"
      unzip -o "$pkg_tmp"
      rm "$pkg_tmp"
    )
  }
  if ! error_done_wrap "Installing package" install_package "\n"; then install_failed; fi

  printf "  $BO$RD♥$RE $BO$MA%s$RE\n\n" "All done!"
}


#include include/args_processing
usage() {
  printf "  $BO${LY}Usage: $MA$0$RE $BO${GY}[${LY}options $GY...] <$RE${BO}command$GY> [${LY}arguments $GY...]$RE\n$1"
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
      exit "$?"
      ;;
    "d"|"dev")
      sub_dev "$@"
      exit "$?"
      ;;
    *)
        printf "  $BO${LY}Unrecognized command $RE$BO$arg${LY}.$RE\n\n"
        usage
        hint
        exit
        ;;
  esac
done


