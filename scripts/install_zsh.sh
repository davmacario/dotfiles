#!/bin/bash

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S') - $0] $1"
}

install_plugins() {
    git clone "https://github.com/zsh-users/zsh-autosuggestions" ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
}

# Install ZSH
FLG=0
if [[ "$SHELL" == *"zsh"* ]]; then
    FLG=1
    log "ZSH is the default shell already! $(which zsh)"
else
    if [[ "$OSTYPE" == "linux-gnu"* ]] && [[ -n "$(apt-get -v)" ]] && [[ -z "$(which zsh)" ]]; then
        sudo apt-get update
        sudo apt-get install zsh -y
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew update
        brew install zsh
    fi
fi

if [ ! -x "$(command -v omz)" ]; then
    log "Installing OMZ"
    pushd "$HOME" || { log "Unable to find $HOME"; exit 1; }
    if [ -d "$HOME/.oh-my-zsh" ]; then
        log "Found old ~/.oh-my-zsh folder, adding '-old' suffix"
        mv "$HOME/.oh-my-zsh" "$HOME/.oh-my-zsh-old"
    fi
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
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
                [Yy]* ) sudo chsh -s "$(which zsh)"; break;;
                [Nn]* ) exit 2;;
                * ) echo "Please answer y/n"
            esac
        done

        log "Now log out and back in for the changes to take place"
    fi
else
    install_plugins
    if [ ! $FLG -eq 1 ]; then
        sudo chsh -s "$(which zsh)"
    fi
fi
