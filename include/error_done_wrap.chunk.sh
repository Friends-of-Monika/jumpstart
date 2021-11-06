error_done_wrap() {
  desc="$1"
  printf "  $BO$LY🛠$RE $BO$MA%s... $RE" "$desc"
  cmd="$2"
  shift 2

  tmp="$(mktemp)"
  "$cmd" "$@" 2>"$tmp" >/dev/null
  ec="$?"

  if [ "$ec" -ne 0 ]; then
    printf "\r\033[K  $BO$RD✘$RE $BO$MA%s... $RE" "$desc"
    printf "$BO${RD}error!\n\n   $(cat "$tmp")$RE\n\n"
    rm "$tmp"
    exit 1
  else
    printf "\r\033[K  $BO$GN✔$RE $BO$MA%s... $RE" "$desc"
    printf "$BO${MA}done.$RE\n\n"
    rm "$tmp"
  fi
}
