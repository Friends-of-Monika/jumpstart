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
  }

  get_rel_url() {
    rel_tmp="$(mktemp)"
    curl -sL --show-error -o "$rel_tmp" "https://api.github.com/repos/monika-after-story/monikamoddev/releases/latest"
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
    curl -sL --show-error -o "$pkg_tmp" "$dl_url"
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
