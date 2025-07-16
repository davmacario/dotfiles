#!/bin/bash

# Nvim always compiled from source to avoid undesired breaking changes
# at 8 in the morning after a `brew update`
VERSION="${1:-v0.11.3}"
GHDIR="${3:-$HOME}/github"
mkdir -p "$GHDIR/neovim"
if [ ! -d "$GHDIR/neovim/neovim" ]; then
    git clone -b "$VERSION" https://github.com/neovim/neovim.git "$GHDIR/neovim/neovim"
else
    echo "Found local clone of Neovim repo"
fi
pushd "$GHDIR/neovim/neovim" || exit 1
make CMAKE_BUILD_TYPE="${NVIM_CMAKE_BUILD_TYPE:-"RelWithDebInfo"}"
make install
popd || exit 1
if [ -n "$2" ]; then
    chown -R "$2":"$2" "$GHDIR/neovim"
fi
