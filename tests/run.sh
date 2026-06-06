#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONOPS_BIN="${CONOPS_BIN:-$DIR/../conops/build/conops}"
make -C "$DIR" parser >/dev/null
FIX="$(mktemp --suffix=.conops)"
printf 'a := 1\na := 2\n' > "$FIX"
export CONOPS_FIX="$FIX" CONOPS_BIN PLUGIN_DIR="$DIR"
nvim --headless -u NONE --cmd "set rtp+=$DIR" -c "luafile $DIR/tests/headless.lua" 2>&1 | tee /tmp/conops-nvim-test.log
grep -q 'ALL TESTS PASS' /tmp/conops-nvim-test.log
