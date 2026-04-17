#!/usr/bin/env bash

set -eo pipefail
trap abort ERR SIGTERM SIGILL

log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

abort() {
    log "Error encountered - aborting"
    exit 1
}

installing() {
    log "Installing $1..."
}

get_back() {
    cd "$CURR_DIR" || { log "Something went wrong!"; exit 1; }
}

# Set the owner of the file/directory to the current user:group
correct_ownership() {
    if [ -e "$1" ]; then
        sudo chown -R "${current_uid}":"${current_gid}" "$1"
    fi
}

# Symlinks the argument to the home directory
# NOTE: will overwrite files if they already exist
make_link() {
    if [ -f "$HOME/$1" ]; then
        rm "$HOME/$1"
    fi
    if [ -f "$CURR_DIR/$1" ] && [ ! -L "$HOME/$1" ]; then
        ln -s "$CURR_DIR/$1" "$HOME/$1"
        correct_ownership "$HOME/$1"
    fi
}

# Set up user variables
CURR_DIR=$(realpath .)
log "Current dir: $CURR_DIR"
log "Shell: $SHELL"
current_uid="$(id -u)"
current_gid="$(id -g)"
log "Running install script as user $(whoami) ($current_uid:$current_gid)"

# Source installation environment variables
source install.env
source .zshenv

# Install homebrew
if [ ! -x "$(command -v brew)" ]; then
    log "Installing homebrew"
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
else
    brew update
    brew upgrade
fi

# Install packages
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    log "Linux detected!"

    # TODO: add support for other package managers
    if [ -n "$(apt -v)" ]; then
        export DEBIAN_FRONTEND=noninteractive
        log "Using Ubuntu/Debian - apt detected!"
        PACKAGE_MANAGER="apt"
        sudo apt update
        sudo apt upgrade -y
    # elif [ -n "$(pacman -v)" ]; then
    #     log "Pacman detected!"
    #     PACKAGE_MANAGER="pacman"
    #     log -e "Pacman not supported yet" && exit 1
    else
        log "Unsupported OS" && exit 1
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    log "MacOS detected!"
fi

package_manager() {
    if [[ "$OSTYPE" == linux-gnu* ]]; then
        sudo DEBIAN_FRONTEND=noninteractive "$PACKAGE_MANAGER" -y "$@"
    elif [[ "$OSTYPE" == darwin* ]]; then
        brew "$@"
    fi
}

# packages that have the same name across different platforms
declare -a packages_global=(
    tmux
    fastfetch
    htop
    git
    cmake
    gcc
    whois
    cowsay
    sl
    python3
    python3-dev
    python3-pip
    ninja-build
    gettext
    npm
    ripgrep
    unzip
    curl
    build-essential
    telnet
    python3-venv
    shellcheck
    lua5.1
    liblua5.1-0-dev
    bat
    pipx
)
declare -a packages_mac=(
    fd
    golang
)
declare -a packages_deb=(
    fd-find
    golang-go
    xclip
)

if [[ "$OSTYPE" == "darwin"* ]]; then
    sudo xcode-select --install
    packages_all=( "${packages_global[@]}" "${packages_mac[@]}" )
else
    packages_all=( "${packages_global[@]}" "${packages_deb[@]}" )
fi

package_manager install "${packages_all[@]}"

scripts/install_fzf.sh || { log "Error installing fzf"; exit 1; }

# Install uv (python env manager)
scripts/install_uv.sh

# Install npm packages
if [ -x "$(command -v npm)" ]; then
    sudo npm install -g tree-sitter-cli
fi

# ------------------------------------------------------------------------------

# 1. Install ZSH, OMZ, and p10k
if [[ "$SHELL" != *zsh* ]]; then
    scripts/install_zsh.sh --chsh

    # Install powerlevel10k
    log "Installing p10k"
    rm -rf "${ZSH_CUSTOM:-"$HOME"/.oh-my-zsh/custom}/themes/powerlevel10k"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-"$HOME"/.oh-my-zsh/custom}/themes/powerlevel10k"
    correct_ownership "${ZSH_CUSTOM:-"$HOME"/.oh-my-zsh/custom}/themes/powerlevel10k"

    if [ ! -f "$HOME/.zsh_history" ]; then
        touch "$HOME/.zsh_history"
        correct_ownership "$HOME/.zsh_history"
    fi
fi

# ------------------------------------------------------------------------------
# 2. Symlinks - don't overwrite files if already present
echo "Symlinking..."
scripts/make_symlinks.sh

# ------------------------------------------------------------------------------
# 3. User configuration

# Github repos
mkdir -p "$GHDIR"

# Nvim config
if [ -d "$CURR_DIR/nvim" ]; then
    NVIM_VERSION="${NVIM_VERSION:-v0.11.3}"

    # Check whether neovim is already installed with the specified version
    if [ ! -x "$(command -v nvim)" ] || [ "$(nvim -v | awk -F" " '{ print $2 }' | head -n 1)" != "$NVIM_VERSION" ]; then
        log "Installing Neovim $NVIM_VERSION"
        ./scripts/install_nvim.sh --nvim-version "$NVIM_VERSION"
        log "Neovim installed successfully!"
    else
        log "Found local installation of Neovim $NVIM_VERSION"
    fi

    # Install neovim plugins requirements
    # TODO: put into dedicated script
    if [[  "$OSTYPE" == "darwin"* ]]; then
        ./scripts/macos-zathura.sh
        brew install pngpaste
    fi

    sudo ./scripts/lazygit-install.sh "$(whoami)"

    mkdir -p "$HOME/.virtualenvs"
    pushd "$HOME/.virtualenvs"
    python3 -m venv debugpy # FIXME: pin python version
    debugpy/bin/python3 -m pip install --upgrade pip debugpy
    popd
fi

get_back

# Tmux config
# Install the Tmux Plugin Manager
mkdir -p "$HOME/.tmux/plugins"
git clone https://github.com/tmux-plugins/tpm.git "$HOME/.tmux/plugins/tpm"

log "Setup complete! Restart your shell for all the changes to take effect."
