#!/bin/sh
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <MAS install directory>"
  exit 1
fi

set -e


printf "%s" "Patching DDLC.py... "
cat <<EOF | patch "$1/DDLC.py" >/dev/null
52a53
>     return gamedir + "/saves"
EOF
echo "done."


printf "%s" "Adding console... "
cat > "$1/game/dev_console.rpy" <<EOF
init python:
    config.console = True
EOF
echo "done."


printf "%s" "Adding expressions previewer... "
curl -sL "https://raw.githubusercontent.com/Monika-After-Story/MonikaModDev/master/Monika%20After%20Story/game/dev/dev_exp_previewer.rpy" > "$1/game/dev_exp_previewer.rpy"
echo "done."


if [ -f ~/".renpy/Monika After Story/persistent" ]; then
  read -p "Do you want to copy existing persistent? (Y/n) " ok
  case "$ok" in
    "Y"|"y"|"")
      printf "%s" "Copying persistent... "
      mkdir -p "$1/game/saves"
      cp ~/".renpy/Monika After Story/persistent" "$1/game/saves"
      echo "done,"
      ;;
  esac
fi


echo "Done."
