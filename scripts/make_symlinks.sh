#!/bin/bash

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
    if [ -f "$CURR_DIR/$fl" ] && [ ! -L "$HOME/$fl" ]; then
        echo "Linking $fl"
        make_link "$fl"
    fi
done

declare -a config_dirs_to_link=(
    "nvim"
    "tmux"
)

for dir in "${config_dirs_to_link[@]}"; do
    if [ -d "$CURR_DIR/$dir" ] && [ ! -L "$XDG_CONFIG_HOME/$dir" ]; then
        echo "Linking $dir to $XDG_CONFIG_HOME"
        ln -s "$CURR_DIR/$dir" "$XDG_CONFIG_HOME/$dir"
    fi
done
