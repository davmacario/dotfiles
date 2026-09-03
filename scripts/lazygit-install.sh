#!/bin/bash

set -eo pipefail

SUDO=""
if [ "$EUID" -ne 0 ]; then
    SUDO="sudo"
fi

if [[ "$OSTYPE" == darwin* ]]; then
    if [ "$EUID" -eq 0 ]; then
        echo "Refusing to run as root: Homebrew cannot be used as root" >&2
        exit 1
    fi
    brew install lazygit
    exit 0
fi

case "$(uname -m)" in
    x86_64 | amd64) arch="x86_64" ;;
    aarch64 | arm64) arch="arm64" ;;
    *) echo "Unsupported architecture: $(uname -m)" >&2 && exit 1 ;;
esac

LAZYGIT_VERSION="$(curl -fsSL "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" |
    grep -Po '"tag_name": "v\K[^"]*' || true)"
if [ -z "$LAZYGIT_VERSION" ]; then
    echo "Could not determine the latest lazygit version (GitHub API rate limit?)" >&2
    exit 1
fi

if command -v lazygit >/dev/null 2>&1 &&
    [ "$(lazygit --version | grep -Po 'version=\K[^,]*' || true)" = "$LAZYGIT_VERSION" ]; then
    echo "lazygit $LAZYGIT_VERSION already installed"
    exit 0
fi

echo "Installing lazygit $LAZYGIT_VERSION ($arch)"
# Download into a temporary directory: the old version left the tarball behind
# in the caller's working directory
tmpdir="$(mktemp -d)"
# shellcheck disable=SC2064  # expand tmpdir now, it is what we want removed
trap "rm -rf '$tmpdir'" EXIT

curl -fLo "$tmpdir/lazygit.tar.gz" \
    "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_${arch}.tar.gz"
tar -xf "$tmpdir/lazygit.tar.gz" -C "$tmpdir" lazygit
$SUDO install -m 755 "$tmpdir/lazygit" /usr/local/bin/lazygit
