#!/bin/bash

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

actual_user="${1:-$USER}"
actual_home="${2:-$HOME}"

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
else
    echo -e "Installing for $actual_user, with home in $actual_home"
fi

correct_ownership() {
    if [ "$actual_user" != "$USER" ]; then
        if [ -e "$1" ]; then
            chown -R "$actual_user":"$actual_user" "$1"
        fi
    fi
}

install_plugins() {
    git clone "https://github.com/zsh-users/zsh-autosuggestions" "${ZSH_CUSTOM:-$actual_home/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "${ZSH_CUSTOM:-$actual_home/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    git clone "https://github.com/jeffreytse/zsh-vi-mode.git" "${ZSH_CUSTOM:-$actual_home/.oh-my-zsh/custom}/plugins/zsh-vi-mode"

    correct_ownership "${ZSH_CUSTOM:-$actual_home/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    correct_ownership "${ZSH_CUSTOM:-$actual_home/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    correct_ownership "${ZSH_CUSTOM:-$actual_home/.oh-my-zsh/custom}/plugins/zsh-vi-mode"
}

# Install ZSH
FLG=0
if [[ "$SHELL" == *"zsh"* ]]; then
    FLG=1
    log "ZSH is the default shell already! $(which zsh)"
else
    if [[ "$OSTYPE" == "linux-gnu"* ]] && [[ -n "$(apt-get -v)" ]] && [[ -z "$(which zsh)" ]]; then
        apt-get update
        apt-get install zsh -y
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew update
        brew install zsh
    fi
fi

if [ ! -x "$(command -v omz)" ]; then
    log "Installing OMZ"
    pushd "$actual_home" || { log "Unable to find $actual_home"; exit 1; }
    if [ -d "$actual_home/.oh-my-zsh" ]; then
        log "Found old ~/.oh-my-zsh folder, adding '-old' suffix"
        mv "$actual_home/.oh-my-zsh" "$actual_home/.oh-my-zsh-old"
        correct_ownership "$actual_home/.oh-my-zsh-old"
    fi
    if [ -z "$actual_user" ]; then
        su - "$actual_user" -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
    popd || { log "Something went wrong"; exit 1; }
fi

if [ "$DEBIAN_FRONTEND" != "noninteractive" ]; then
    # Installing plugins (autocomplete)
    while true; do
        read -r -p "Do you want to install the following plugins: zsh-autosuggestions, zsh-syntax-highlighting\n? [y/n]  " yn
        case $yn in
            [Yy]* )
                install_plugins
                break;;
            [Nn]* ) break;;
            * ) echo "Please answer y/n"
        esac
    done

    # Prompt for setting default

    if [ ! $FLG -eq 1 ]; then
        while true; do
            read -r -p "ZSH is not the default shell, do you want to set it as default? [y/n]  " yn
            case $yn in
                [Yy]* ) chsh -s "$(which zsh)" "$actual_user"; break;;
                [Nn]* ) exit 2;;
                * ) echo "Please answer y/n"
            esac
        done

        log "Now log out and back in for the changes to take place"
    fi
else
    install_plugins
    if [ ! $FLG -eq 1 ]; then
        chsh -s "$(which zsh)" "$actual_user"
    fi
fi

correct_ownership "$actual_home/.oh-my-zsh"
correct_ownership "$actual_home/.zshrc.pre-oh-my-zsh"
