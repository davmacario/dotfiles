#!/bin/bash

# Install fzf from source
git clone --depth 1 https://github.com/junegunn/fzf.git "$XDG_DATA_HOME/.fzf"
$XDG_DATA_HOME/.fzf/install --all --xdg
