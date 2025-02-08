#!/bin/bash

VERSION="${1:-v0.10.4}"
GHDIR="$HOME/github"
mkdir "$GHDIR/neovim"
git clone -b "$VERSION" https://github.com/neovim/neovim.git "$GHDIR/neovim/neovim"
pushd "$GHDIR/neovim/neovim" || exit 1
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
popd || exit 1
