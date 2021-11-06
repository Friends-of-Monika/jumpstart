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
