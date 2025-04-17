#!/bin/bash

# Nvim always compiled from source to avoid undesired breaking changes
# at 8 in the morning after a `brew update`
VERSION="${1:-v0.10.4}"
GHDIR="$HOME/github"
mkdir "$GHDIR/neovim"
git clone -b "$VERSION" https://github.com/neovim/neovim.git "$GHDIR/neovim/neovim"
pushd "$GHDIR/neovim/neovim" || exit 1
make CMAKE_BUILD_TYPE="${NVIM_CMAKE_BUILD_TYPE:-"RelWithDebInfo"}"
make install
popd || exit 1
chown -R "$2":"$2" "$GHDIR/neovim"
