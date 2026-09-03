#!/bin/bash

set -eo pipefail

# Install fzf from source
# NOTE: keep this path in sync with .fzf.zsh, which puts $FZF_DIR/bin on $PATH
FZF_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/.fzf"

if [ -d "$FZF_DIR/.git" ]; then
    echo "Updating fzf in $FZF_DIR"
    git -C "$FZF_DIR" pull --ff-only || echo "Could not update fzf (continuing)"
else
    echo "Installing fzf into $FZF_DIR"
    rm -rf "$FZF_DIR"
    mkdir -p "$(dirname "$FZF_DIR")"
    git clone --depth 1 https://github.com/junegunn/fzf.git "$FZF_DIR"
fi

"$FZF_DIR/install" --all --xdg
