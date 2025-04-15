#!/bin/bash

# Install fzf from source
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
if [ -z "$1" ]; then
    chown -R "$1":"$1" ./.fzf
fi
~/.fzf/install
