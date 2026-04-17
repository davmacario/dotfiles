#!/bin/bash

set -e

declare -a files_to_link=(
    ".bashrc"
    ".fzf.bash"
    ".fzf.zsh"
    ".gitignore"
    ".p10k.zsh"
    ".zshenv"
    ".zprofile"
    ".zshrc"
    ".vimrc"
    ".gitconfig"
    "personal.gitconfig"
    "work.gitconfig"
    "vitestro.gitconfig"
)

for fl in "${files_to_link[@]}"; do
    if [ -f "$fl" ]; then
        echo "Linking $fl"
        rm -rf "${HOME:?Home is not set}/$fl"
        ln -s "$fl" "$HOME/$fl"
    fi
done

declare -a config_dirs_to_link=(
    "nvim"
    "tmux"
)

for dir in "${config_dirs_to_link[@]}"; do
    if [ -d "$dir" ]; then
        echo "Linking $dir to $XDG_CONFIG_HOME"
        rm -rf "${XDG_CONFIG_HOME:?XDG_CONFIG_HOME is not set}/$fl"
        ln -s "$$dir" "$XDG_CONFIG_HOME/$dir"
    fi
done
