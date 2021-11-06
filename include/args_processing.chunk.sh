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
