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
