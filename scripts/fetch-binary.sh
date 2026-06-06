#!/bin/sh
# POSIX sh (no bashisms) — invoked by `make`/lazy.nvim build, which may run /bin/sh.
set -eu

REPO="sstoehrm/conops"
case "$(uname -s)-$(uname -m)" in
	Linux-x86_64) asset="conops-linux-x86_64" ;;
	Darwin-arm64) asset="conops-macos-arm64" ;;
	*)
		echo "conops.nvim: no prebuilt binary for $(uname -s)-$(uname -m); build conops and add it to PATH" >&2
		exit 0
		;;
esac

DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
mkdir -p "$DIR/bin"
url="https://github.com/$REPO/releases/latest/download/$asset"

if curl -fL --retry 2 -o "$DIR/bin/conops" "$url"; then
	chmod +x "$DIR/bin/conops"
	echo "conops.nvim: installed bin/conops from latest release"
else
	rm -f "$DIR/bin/conops"
	echo "conops.nvim: no release asset yet ($url); diagnostics need 'conops' on PATH. Highlighting still works." >&2
fi
exit 0
