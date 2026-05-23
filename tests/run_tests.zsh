#!/usr/bin/env zsh
set -euo pipefail

REPO_ROOT="${0:A:h:h}"
typeset -a TEST_FILES=(
  "$REPO_ROOT/tests/distros_test.zsh"
  "$REPO_ROOT/tests/symbols_test.zsh"
)

for test_file in "${TEST_FILES[@]}"; do
  print -r "Running ${test_file:t}..."
  zsh "$test_file"
done

print -r "All tests passed."
