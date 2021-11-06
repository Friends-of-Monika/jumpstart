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
