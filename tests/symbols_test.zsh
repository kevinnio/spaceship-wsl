#!/usr/bin/env zsh
set -euo pipefail

REPO_ROOT="${0:A:h:h}"

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

expected_symbol() {
  local style="$1" id="$2"

  case "$style" in
    nerd) print -r "${SPACESHIP_WSL_DISTRO_SYMBOLS[$id]}" ;;
    emoji) print -r "${SPACESHIP_WSL_EMOJI_SYMBOLS[$id]}" ;;
    ascii) print -r "${SPACESHIP_WSL_ASCII_SYMBOLS[$id]}" ;;
  esac
}

typeset -a STYLES=(nerd emoji ascii none)

for style in "${STYLES[@]}"; do
  SPACESHIP_WSL_ICON_STYLE="$style"

  if [[ "$style" == none ]]; then
    for id in "${SPACESHIP_WSL_DISTROS[@]}"; do
      assert_eq "$style symbol for $id" "" "$(spaceship_wsl::symbol_for "$id")"
    done
    assert_eq "$style symbol for unknown distro" "" "$(spaceship_wsl::symbol_for unknown-distro)"
    continue
  fi

  for id in "${SPACESHIP_WSL_DISTROS[@]}"; do
    assert_eq "$style symbol for $id" \
      "$(expected_symbol "$style" "$id")" \
      "$(spaceship_wsl::symbol_for "$id")"
  done

  assert_eq "$style symbol for unknown distro" \
    "$(expected_symbol "$style" default)" \
    "$(spaceship_wsl::symbol_for unknown-distro)"
done

unset SPACESHIP_WSL_ICON_STYLE
source "$REPO_ROOT/spaceship-wsl.plugin.zsh"
assert_eq "default symbol style is nerd" \
  "${SPACESHIP_WSL_DISTRO_SYMBOLS[ubuntu]}" \
  "$(spaceship_wsl::symbol_for ubuntu)"

SPACESHIP_WSL_ICON_STYLE=invalid-style
assert_eq "invalid symbol style falls back to nerd" \
  "${SPACESHIP_WSL_DISTRO_SYMBOLS[ubuntu]}" \
  "$(spaceship_wsl::symbol_for ubuntu)"

print -r "Symbol tests passed."
