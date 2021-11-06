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
