#!/usr/bin/env zsh
set -euo pipefail

REPO_ROOT="${0:A:h:h}"

SPACESHIP_PROMPT_DEFAULT_PREFIX=' '
SPACESHIP_PROMPT_DEFAULT_SUFFIX=' '

source "$REPO_ROOT/spaceship-wsl.plugin.zsh"

assert_eq() {
  local description="$1" expected="$2" actual="$3"
  if [[ "$actual" != "$expected" ]]; then
    print -u2 "FAIL: $description"
    print -u2 "  expected: $(print -r -- "$expected" | xxd -p)"
    print -u2 "  actual:   $(print -r -- "$actual" | xxd -p)"
    return 1
  fi
}

SPACESHIP_WSL_SYMBOL_STYLE=nerd
assert_eq "nerd symbol for ubuntu" \
  "${SPACESHIP_WSL_DISTRO_SYMBOLS[ubuntu]}" \
  "$(spaceship_wsl::symbol_for ubuntu)"
assert_eq "nerd symbol for unknown" \
  "${SPACESHIP_WSL_DISTRO_SYMBOLS[default]}" \
  "$(spaceship_wsl::symbol_for unknown)"

SPACESHIP_WSL_SYMBOL_STYLE=emoji
assert_eq "emoji symbol for ubuntu" \
  "${SPACESHIP_WSL_EMOJI_SYMBOLS[ubuntu]}" \
  "$(spaceship_wsl::symbol_for ubuntu)"
assert_eq "emoji symbol for archlinux" \
  "${SPACESHIP_WSL_EMOJI_SYMBOLS[archlinux]}" \
  "$(spaceship_wsl::symbol_for archlinux)"
assert_eq "emoji symbol for unknown" \
  "${SPACESHIP_WSL_EMOJI_SYMBOLS[default]}" \
  "$(spaceship_wsl::symbol_for unknown)"

SPACESHIP_WSL_SYMBOL_STYLE=ascii
assert_eq "ascii symbol for ubuntu" \
  "${SPACESHIP_WSL_ASCII_SYMBOLS[ubuntu]}" \
  "$(spaceship_wsl::symbol_for ubuntu)"
assert_eq "ascii symbol for unknown" \
  "${SPACESHIP_WSL_ASCII_SYMBOLS[default]}" \
  "$(spaceship_wsl::symbol_for unknown)"

SPACESHIP_WSL_SYMBOL_STYLE=none
assert_eq "none symbol for ubuntu" "" "$(spaceship_wsl::symbol_for ubuntu)"

SPACESHIP_WSL_SYMBOL_STYLE=auto
SPACESHIP_WSL_USE_NERD_FONT=false
assert_eq "auto without nerd font uses emoji" \
  "${SPACESHIP_WSL_EMOJI_SYMBOLS[ubuntu]}" \
  "$(spaceship_wsl::symbol_for ubuntu)"

SPACESHIP_WSL_USE_NERD_FONT=true
assert_eq "auto with nerd font uses devicons" \
  "${SPACESHIP_WSL_DISTRO_SYMBOLS[ubuntu]}" \
  "$(spaceship_wsl::symbol_for ubuntu)"

print -r "All symbol tests passed."
