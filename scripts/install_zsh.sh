#!/bin/bash

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

if [ -z "$USER" ]; then
    echo "USER not set"
fi

USER=${USER:-$(whoami)}

AUTO_CHSH=0
while [[ $# -gt 0 ]]; do
    case "$1" in
        --chsh)
            AUTO_CHSH=1
            shift
            ;;
        *)
            echo "Unknown argument: $1"
            exit 1
            ;;
    esac
done

if [ "$EUID" -eq 0 ]; then
  echo -e "Warning: installing as root" # TODO: yellow
fi

install_plugins() {
    git clone "https://github.com/zsh-users/zsh-autosuggestions" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    git clone "https://github.com/jeffreytse/zsh-vi-mode.git" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-vi-mode"
}

# Install ZSH
FLG=0
if [[ "$SHELL" == */zsh ]]; then
    FLG=1
    log "ZSH ($(which zsh)) is the default shell already!"
elif ! command -v zsh ; then
    echo "Installing ZSH"
    if [[ "$OSTYPE" == "linux-gnu"* ]] && command -v apt >/dev/null 2>&1; then
        sudo DEBIAN_FRONTEND=noninteractive apt install zsh -y
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install zsh
    else
        echo "Unsupported OS" >&2
        exit 1
    fi
else
    echo "Zsh already installed!"
fi

ZSH_BIN="$(command -v zsh)"

if [ ! -x "$(command -v omz)" ]; then
    log "Installing OMZ"
    pushd "$HOME"
    if [ -d "$HOME/.oh-my-zsh" ]; then
        log "Found old ~/.oh-my-zsh folder, adding '-old' suffix"
        mv "$HOME/.oh-my-zsh" "$HOME/.oh-my-zsh-old"
    fi
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    popd || { log "Something went wrong"; exit 1; }
fi

install_plugins

if [ ! $FLG -eq 1 ]; then
    if [ $AUTO_CHSH -eq 1 ]; then
        echo "Setting Zsh (${ZSH_BIN}) as default shell"
        sudo usermod -s "${ZSH_BIN}" "$USER"
    else
        while true; do
            read -r -p "ZSH is not the default shell, do you want to set it as default? [y/n]  " yn
            case $yn in
                [Yy]* ) chsh -s "${ZSH_BIN}" "$USER"; break;;
                [Nn]* ) exit 2;;
                * ) echo "Please answer y/n"
            esac
        done
    fi

    log "Now log out and back in for the changes to take place"
fi
