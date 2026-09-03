#!/bin/bash

set -eo pipefail

# Repo root: passed in by setup.sh, otherwise derived from this script's path so
# that the symlinks do not depend on the current working directory
repo_dir="${1:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)}"
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"

# Symlink $1 -> $2, keeping a .bak copy of anything real that was there before
link() {
    local src="$1" dst="$2"

    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        echo "Already linked: $dst"
        return 0
    fi

    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        echo "Backing up existing $dst -> $dst.bak"
        rm -rf "$dst.bak"
        mv "$dst" "$dst.bak"
    fi

    rm -rf "$dst"
    ln -s "$src" "$dst"
    echo "Linked $dst -> $src"
}

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
    if [ -f "$repo_dir/$fl" ]; then
        link "$repo_dir/$fl" "${HOME:?Home is not set}/$fl"
    fi
done

declare -a config_dirs_to_link=(
    "nvim"
    "tmux"
    "opencode"
)

mkdir -p "$config_home"
for dir in "${config_dirs_to_link[@]}"; do
    if [ -d "$repo_dir/$dir" ]; then
        link "$repo_dir/$dir" "$config_home/$dir"
    fi
done
