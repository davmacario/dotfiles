#!/bin/bash

actual_user="${1:-$USER}"
actual_home="${2:-$HOME}"

# Install fzf from source
git clone --depth 1 https://github.com/junegunn/fzf.git "$actual_home/.fzf"
$actual_home/.fzf/install
if [ -z "$1" ]; then
    chown -R "$actual_user":"$actual_user" "$actual_home/.fzf"
fi
