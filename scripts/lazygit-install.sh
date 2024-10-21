#!/bin/bash

abort () {
    echo "Unset env var 'GHDIR'"
    exit 1
}


if [[  "$OSTYPE" == "darwin"* ]]; then
    brew install lazyvim
else
    cd "$GHDIR" || abort
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
fi
