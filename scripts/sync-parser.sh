#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MAIN="${1:-$HERE/../conops}"
src="$MAIN/tree-sitter/src"
[ -f "$src/parser.c" ] || { echo "grammar src not found at $src" >&2; exit 1; }
mkdir -p "$HERE/src"
cp "$src/parser.c" "$src/node-types.json" "$HERE/src/"
cp -r "$src/tree_sitter" "$HERE/src/"
echo "synced parser src from $src"
