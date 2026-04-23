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

curr_dir="$(realpath .)"

for fl in "${files_to_link[@]}"; do
    if [ -f "$curr_dir/$fl" ]; then
        echo "Linking $fl"
        rm -rf "${HOME:?Home is not set}/$fl"
        ln -s "$curr_dir/$fl" "$HOME/$fl"
    fi
done

declare -a config_dirs_to_link=(
    "nvim"
    "tmux"
    "opencode"
)

for dir in "${config_dirs_to_link[@]}"; do
    if [ -d "$curr_dir/$dir" ]; then
        echo "Linking $dir to $XDG_CONFIG_HOME"
        rm -rf "${XDG_CONFIG_HOME:?XDG_CONFIG_HOME is not set}/$fl"
        ln -s "$curr_dir/$dir" "$XDG_CONFIG_HOME/$dir"
    fi
done
