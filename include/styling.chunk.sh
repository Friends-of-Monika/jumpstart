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
