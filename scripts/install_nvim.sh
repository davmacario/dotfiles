#!/bin/bash

NVIM_VERSION="${NVIM_VERSION:-v0.11.3}"
COMPILE="false"
while [[ $# -gt 0 ]]; do
    case "$1" in
        --nvim-version)
            NVIM_VERSION="$2"
            shift 2
            ;;
        --compile)
            COMPILE="true"
            shift
            ;;
        *)
            echo "Unknown argument: $1"
            exit 1
            ;;
    esac
done

if [ "$COMPILE" = "true" ]; then
    echo "Compiling Nvim $NVIM_VERSION from source"
    GHDIR=${GHDIR:-"$HOME/github"}
    mkdir -p "$GHDIR/neovim"
    if [ ! -d "$GHDIR/neovim/neovim" ]; then
        git clone -b "$NVIM_VERSION" https://github.com/neovim/neovim.git "$GHDIR/neovim/neovim"
    else
        echo "Found local clone of Neovim repo"
    fi
    pushd "$GHDIR/neovim/neovim" || exit 1
    git pull -p --tags
    make CMAKE_BUILD_TYPE="${NVIM_CMAKE_BUILD_TYPE:-"RelWithDebInfo"}"
    sudo make install
    popd || exit 1
else
    echo "Downloading Nvim $NVIM_VERSION from releases"
    curl -LO "https://github.com/neovim/neovim/releases/$NVIM_VERSION/download/nvim-linux-x86_64.tar.gz"
    sudo rm -rf /opt/nvim-linux-x86_64
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
    rm nvim-linux-x86_64.tar.gz
fi
