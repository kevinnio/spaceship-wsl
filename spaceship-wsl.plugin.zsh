# Spaceship WSL section
# https://github.com/kevinnio/spaceship-wsl
# https://spaceship-prompt.sh/advanced/creating-section/

SPACESHIP_WSL_SHOW="${SPACESHIP_WSL_SHOW=true}"
SPACESHIP_WSL_PREFIX="${SPACESHIP_WSL_PREFIX=" "}"
SPACESHIP_WSL_SUFFIX="${SPACESHIP_WSL_SUFFIX=" "}"
SPACESHIP_WSL_SYMBOL="${SPACESHIP_WSL_SYMBOL=$'\uF17A '}"
SPACESHIP_WSL_COLOR="${SPACESHIP_WSL_COLOR="cyan"}"
# Icon style: nerd (default), emoji, ascii, or none.
SPACESHIP_WSL_ICON_STYLE="${SPACESHIP_WSL_ICON_STYLE=nerd}"

# Distros available from `wsl --list --online`.
typeset -ga SPACESHIP_WSL_DISTROS=(
  ubuntu
  debian
  arch
  fedora
  opensuse-leap
  opensuse-tumbleweed
  sles
  kali
  rocky
  almalinux
  oracle
)

typeset -gA SPACESHIP_WSL_DISTRO_SYMBOLS SPACESHIP_WSL_DISTRO_COLORS
typeset -gA SPACESHIP_WSL_EMOJI_SYMBOLS SPACESHIP_WSL_ASCII_SYMBOLS

SPACESHIP_WSL_DISTRO_SYMBOLS=(
  ubuntu              $'\uF31C '
  debian              $'\uF306 '
  arch                $'\uF303 '
  fedora              $'\uF30A '
  opensuse-leap       $'\uF314 '
  opensuse-tumbleweed $'\uF314 '
  sles                $'\uF314 '
  kali                $'\uF327 '
  rocky               $'\uF32B '
  almalinux           $'\uF31D '
  oracle              $'\uF17A '
  default             $'\uF17A '
)

SPACESHIP_WSL_EMOJI_SYMBOLS=(
  ubuntu              $'🟠 '
  debian              $'🔴 '
  arch                $'🔷 '
  fedora              $'🎩 '
  opensuse-leap       $'🦎 '
  opensuse-tumbleweed $'🦎 '
  sles                $'🦎 '
  kali                $'🐉 '
  rocky               $'🪨 '
  almalinux           $'🪨 '
  oracle              $'🔶 '
  default             $'🐧 '
)

SPACESHIP_WSL_ASCII_SYMBOLS=(
  ubuntu              'U '
  debian              'D '
  arch                'A '
  fedora              'F '
  opensuse-leap       'Su '
  opensuse-tumbleweed 'Su '
  sles                'Su '
  kali                'K '
  rocky               'R '
  almalinux           'Al '
  oracle              'Or '
  default             'W '
)

SPACESHIP_WSL_DISTRO_COLORS=(
  ubuntu              '#E95420'
  debian              '#A81D33'
  arch                '#1793D1'
  fedora              '#51A2DA'
  opensuse-leap       '#73BA25'
  opensuse-tumbleweed '#73BA25'
  sles                '#73BA25'
  kali                '#557C94'
  rocky               '#10B981'
  almalinux           '#10B981'
  oracle              '#F80000'
  default             'cyan'
)

spaceship_wsl::normalize_id() {
  local id="${1:l}"
  id="${id// /-}"
  id="${id//_/-}"

  case "$id" in
    ubuntu*) id=ubuntu ;;
    debian*) id=debian ;;
    arch|archlinux*) id=arch ;;
    fedora*|fedoralinux*) id=fedora ;;
    opensuse-tumbleweed*|tumbleweed*) id=opensuse-tumbleweed ;;
    opensuse-leap*|opensuse*) id=opensuse-leap ;;
    sles*|suse-linux-enterprise*) id=sles ;;
    kali*) id=kali ;;
    rocky*) id=rocky ;;
    almalinux*) id=almalinux ;;
    oracle*|oraclelinux*) id=oracle ;;
  esac

  print -r "$id"
}

spaceship_wsl::distro_id() {
  local id="${WSL_DISTRO_NAME:-}"

  if [[ -z "$id" && -r /etc/os-release ]]; then
    id="$(source /etc/os-release; print -r "${ID:-}")"
  fi

  [[ -n "$id" ]] || return 0
  spaceship_wsl::normalize_id "$id"
}

spaceship_wsl::icon_style() {
  case "$SPACESHIP_WSL_ICON_STYLE" in
    nerd|emoji|ascii|none) print -r "$SPACESHIP_WSL_ICON_STYLE" ;;
    *) print -r nerd ;;
  esac
}

spaceship_wsl::symbol_for() {
  local id="$1" style

  style="$(spaceship_wsl::icon_style)"
  if [[ "$style" == none ]]; then
    print -r ""
    return
  fi

  case "$style" in
    nerd)
      if (( ${+SPACESHIP_WSL_DISTRO_SYMBOLS[$id]} )); then
        print -r "${SPACESHIP_WSL_DISTRO_SYMBOLS[$id]}"
      else
        print -r "${SPACESHIP_WSL_DISTRO_SYMBOLS[default]}"
      fi
      ;;
    ascii)
      if (( ${+SPACESHIP_WSL_ASCII_SYMBOLS[$id]} )); then
        print -r "${SPACESHIP_WSL_ASCII_SYMBOLS[$id]}"
      else
        print -r "${SPACESHIP_WSL_ASCII_SYMBOLS[default]}"
      fi
      ;;
    *)
      if (( ${+SPACESHIP_WSL_EMOJI_SYMBOLS[$id]} )); then
        print -r "${SPACESHIP_WSL_EMOJI_SYMBOLS[$id]}"
      else
        print -r "${SPACESHIP_WSL_EMOJI_SYMBOLS[default]}"
      fi
      ;;
  esac
}

spaceship_wsl::color_for() {
  local id="$1"

  if (( ${+SPACESHIP_WSL_DISTRO_COLORS[$id]} )); then
    print -r "${SPACESHIP_WSL_DISTRO_COLORS[$id]}"
    return
  fi

  print -r "${SPACESHIP_WSL_DISTRO_COLORS[default]}"
}

spaceship_wsl::is_wsl() {
  [[ -n "${WSL_DISTRO_NAME:-}" ]] && return 0
  [[ -r /proc/version ]] && grep -qiE 'microsoft|wsl' /proc/version
}

spaceship_wsl() {
  [[ $SPACESHIP_WSL_SHOW == false ]] && return
  spaceship_wsl::is_wsl || return

  local id distro symbol color label
  id="$(spaceship_wsl::distro_id)"
  symbol="$(spaceship_wsl::symbol_for "$id")"
  color="$(spaceship_wsl::color_for "$id")"

  if [[ -n "${WSL_DISTRO_NAME:-}" ]]; then
    label="$WSL_DISTRO_NAME"
  elif [[ -n "$id" ]]; then
    label="${id//-/ }"
    label="${(C)label}"
  else
    label="WSL"
  fi

  spaceship::section::v4 \
    --color "$color" \
    --prefix "$SPACESHIP_WSL_PREFIX" \
    --suffix "$SPACESHIP_WSL_SUFFIX" \
    --symbol "$symbol" \
    "$label"
}
