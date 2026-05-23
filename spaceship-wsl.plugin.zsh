# Spaceship WSL section
# https://github.com/kevinnio/spaceship-wsl
# https://spaceship-prompt.sh/advanced/creating-section/

SPACESHIP_WSL_SHOW="${SPACESHIP_WSL_SHOW=true}"
SPACESHIP_WSL_PREFIX="${SPACESHIP_WSL_PREFIX="$SPACESHIP_PROMPT_DEFAULT_PREFIX"}"
SPACESHIP_WSL_SUFFIX="${SPACESHIP_WSL_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_WSL_SYMBOL="${SPACESHIP_WSL_SYMBOL=$'\uF17A '}"
SPACESHIP_WSL_COLOR="${SPACESHIP_WSL_COLOR="cyan"}"
# Symbol style: auto (default), nerd, emoji, ascii, or none.
# auto uses nerd icons only when SPACESHIP_WSL_USE_NERD_FONT=true; otherwise emoji.
SPACESHIP_WSL_SYMBOL_STYLE="${SPACESHIP_WSL_SYMBOL_STYLE=auto}"
SPACESHIP_WSL_USE_NERD_FONT="${SPACESHIP_WSL_USE_NERD_FONT=false}"

typeset -gA SPACESHIP_WSL_DISTRO_SYMBOLS SPACESHIP_WSL_DISTRO_COLORS
typeset -gA SPACESHIP_WSL_EMOJI_SYMBOLS SPACESHIP_WSL_ASCII_SYMBOLS

SPACESHIP_WSL_DISTRO_SYMBOLS=(
  ubuntu        $'\uF31C '
  debian        $'\uF306 '
  arch          $'\uF303 '
  archlinux     $'\uF303 '
  fedora        $'\uF30A '
  alpine        $'\uF300 '
  opensuse      $'\uF314 '
  opensuse-leap $'\uF314 '
  sles          $'\uF314 '
  kali          $'\uF327 '
  nixos         $'\uF313 '
  linuxmint     $'\uF31E '
  pop           $'\uF32A '
  pop-os        $'\uF32A '
  elementary    $'\uF309 '
  manjaro       $'\uF312 '
  rocky         $'\uF32B '
  almalinux     $'\uF31D '
  centos        $'\uF304 '
  rhel          $'\uF316 '
  default       $'\uF17A '
)

SPACESHIP_WSL_EMOJI_SYMBOLS=(
  ubuntu        $'🟠 '
  debian        $'🔴 '
  arch          $'🔷 '
  archlinux     $'🔷 '
  fedora        $'🎩 '
  alpine        $'🏔 '
  opensuse      $'🦎 '
  opensuse-leap $'🦎 '
  sles          $'🦎 '
  kali          $'🐉 '
  nixos         $'❄ '
  linuxmint     $'🌿 '
  pop           $'⭐ '
  pop-os        $'⭐ '
  elementary    $'💠 '
  manjaro       $'🍃 '
  rocky         $'🪨 '
  almalinux     $'🪨 '
  centos        $'💠 '
  rhel          $'🎩 '
  default       $'🐧 '
)

SPACESHIP_WSL_ASCII_SYMBOLS=(
  ubuntu        'U '
  debian        'D '
  arch          'A '
  archlinux     'A '
  fedora        'F '
  alpine        'Al '
  opensuse      'Su '
  opensuse-leap 'Su '
  sles          'Su '
  kali          'K '
  nixos         'Nx '
  linuxmint     'Mi '
  pop           'P '
  pop-os        'P '
  elementary    'E '
  manjaro       'Mj '
  rocky         'R '
  almalinux     'Al '
  centos        'Ce '
  rhel          'Rh '
  default       'W '
)

SPACESHIP_WSL_DISTRO_COLORS=(
  ubuntu        '#E95420'
  debian        '#A81D33'
  arch          '#1793D1'
  archlinux     '#1793D1'
  fedora        '#51A2DA'
  alpine        '#0D597F'
  opensuse      '#73BA25'
  opensuse-leap '#73BA25'
  sles          '#73BA25'
  kali          '#557C94'
  nixos         '#5277C3'
  linuxmint     '#87CF3E'
  pop           '#48B9C7'
  pop-os        '#48B9C7'
  elementary    '#64BAFF'
  manjaro       '#35BF5C'
  rocky         '#10B981'
  almalinux     '#10B981'
  centos        '#932279'
  rhel          '#EE0000'
  default       'cyan'
)

spaceship_wsl::distro_id() {
  local id="${WSL_DISTRO_NAME:-}"

  if [[ -z "$id" && -r /etc/os-release ]]; then
    id="$(source /etc/os-release; print -r "${ID:-}")"
  fi

  id="${id:l}"
  id="${id// /-}"
  print -r "$id"
}

spaceship_wsl::symbol_style() {
  case "$SPACESHIP_WSL_SYMBOL_STYLE" in
    nerd|emoji|ascii|none) print -r "$SPACESHIP_WSL_SYMBOL_STYLE" ;;
    auto)
      if [[ "$SPACESHIP_WSL_USE_NERD_FONT" == true ]]; then
        print -r nerd
      else
        print -r emoji
      fi
      ;;
    *)
      print -r emoji
      ;;
  esac
}

spaceship_wsl::symbol_for() {
  local id="$1" style

  style="$(spaceship_wsl::symbol_style)"
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
  if [[ -n "${SPACESHIP_WSL_DISTRO_COLORS[$id]}" ]]; then
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
