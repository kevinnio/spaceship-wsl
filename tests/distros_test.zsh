#!/usr/bin/env zsh
set -euo pipefail

REPO_ROOT="${0:A:h:h}"

source "$REPO_ROOT/spaceship-wsl.plugin.zsh"

assert_eq() {
  local description="$1" expected="$2" actual="$3"
  if [[ "$actual" != "$expected" ]]; then
    print -u2 "FAIL: $description"
    print -u2 "  expected: $expected"
    print -u2 "  actual:   $actual"
    return 1
  fi
}

assert_eq "default prefix is a space" ' ' "$SPACESHIP_WSL_PREFIX"
assert_eq "default suffix is a space" ' ' "$SPACESHIP_WSL_SUFFIX"

assert_array_keys_match_distros() {
  local array_name="$1"
  local -a keys extra missing
  local -A seen=()

  for key in ${(Pk)array_name}; do
    [[ "$key" == default ]] && continue
    seen[$key]=1
    if (( ! ${SPACESHIP_WSL_DISTROS[(I)$key]} )); then
      extra+=("$key")
    fi
  done

  for id in "${SPACESHIP_WSL_DISTROS[@]}"; do
    if (( ! ${+seen[$id]} )); then
      missing+=("$id")
    fi
  done

  if (( ${#extra} )); then
    print -u2 "FAIL: $array_name has non-WSL keys: ${extra[*]}"
    return 1
  fi

  if (( ${#missing} )); then
    print -u2 "FAIL: $array_name is missing WSL distros: ${missing[*]}"
    return 1
  fi
}

assert_array_keys_match_distros SPACESHIP_WSL_DISTRO_SYMBOLS
assert_array_keys_match_distros SPACESHIP_WSL_EMOJI_SYMBOLS
assert_array_keys_match_distros SPACESHIP_WSL_ASCII_SYMBOLS
assert_array_keys_match_distros SPACESHIP_WSL_DISTRO_COLORS

for id in "${SPACESHIP_WSL_DISTROS[@]}"; do
  assert_eq "color for $id" \
    "${SPACESHIP_WSL_DISTRO_COLORS[$id]}" \
    "$(spaceship_wsl::color_for "$id")"
done

assert_eq "color for unknown distro" \
  "${SPACESHIP_WSL_DISTRO_COLORS[default]}" \
  "$(spaceship_wsl::color_for unknown-distro)"

typeset -a NORMALIZATION_CASES=(
  'Ubuntu:ubuntu'
  'Ubuntu-22.04:ubuntu'
  'Debian:debian'
  'archlinux:arch'
  'Arch:arch'
  'FedoraLinux-42:fedora'
  'openSUSE-Leap-15.6:opensuse-leap'
  'openSUSE-Tumbleweed:opensuse-tumbleweed'
  'SUSE-Linux-Enterprise-15-SP7:sles'
  'kali-linux:kali'
  'Rocky-9:rocky'
  'AlmaLinux-10:almalinux'
  'OracleLinux_9_5:oracle'
)

for case in "${NORMALIZATION_CASES[@]}"; do
  input="${case%%:*}"
  expected="${case#*:}"
  assert_eq "normalize $input" \
    "$expected" \
    "$(spaceship_wsl::normalize_id "$input")"
done

print -r "Distro tests passed."
