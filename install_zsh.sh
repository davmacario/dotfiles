#!/bin/bash

# Install ZSH
FLG=0
if [[ "$OSTYPE" == "linux-gnu"* ]] && [[ -n "$(apt-get -v)" ]] && [[ -z "$(which zsh)" ]]; then
    sudo apt-get update
    sudo apt-get install zsh -y

    if [[ -z "$(which zsh)" ]]; then
        echo "Cannot find zsh install"
        exit 1
    fi

elif [[ "$OSTYPE" == "darwin"* ]]; then
    # ZSH comes pre-installed by default
    echo "ZSH found at: $(which zsh)"
    if [[ "$SHELL" == *"zsh"* ]]; then
        FLG=1
        echo "ZSH is the default shell already!"
    fi
fi

# Installing plugins (autocomplete)
while true; do
    read -r -p "Do you want to install the following plugins: zsh-autosuggestions, zsh-syntax-highlighting\n? [y/n]  " yn
    case $yn in
        [Yy]* ) sudo git clone "https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions";
            sudo git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting";
            break;;
        [Nn]* ) break;;
        * ) echo "Please answer y/n"
    esac
done

# Prompt for setting default

if [ "$FLG" -eq 1 ]; then
    while true; do
        read -r -p "ZSH is not the default shell, do you want to set it as default? [y/n]  " yn
        case $yn in
            [Yy]* ) chsh -s "$(which zsh)"; break;;
            [Nn]* ) exit 2;;
            * ) echo "Please answer y/n"
        esac
    done

    echo "Now log out and back in for the changes to take place"
fi
