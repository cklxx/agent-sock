#!/usr/bin/env bash
# Run all tmux_compile stories + integration. Exit nonzero on any failure.
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pass=0; fail=0
for t in bug-hunt pr-review parallel-dev; do
  if bash "$HERE/$t/run.sh"; then pass=$((pass+1)); else fail=$((fail+1)); fi
done
if bash "$HERE/test_integration.sh"; then pass=$((pass+1)); else fail=$((fail+1)); fi
echo "========================================"
echo "stories PASS=$pass FAIL=$fail"
[ "$fail" -eq 0 ]
