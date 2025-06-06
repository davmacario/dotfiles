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

source_env() {
    # Move some relevant variables (e.g., program versions) to env file
    if [ -f "$(dirname "$0")/.env" ]; then
        source "$(dirname "$0")/.env" "$actual_home"
    fi
}

correct_ownership() {
    chown -R "$actual_user":"$actual_user" "$1"
}

make_link() {
    if [ -f "$actual_home/$1" ]; then
        rm "$actual_home/$fl"
    fi
    if [ -f "$CURR_DIR/$1" ] && [ ! -L "$actual_home/$1" ]; then
        ln -s "$CURR_DIR/$1" "$actual_home/$1"
        correct_ownership "$actual_home/$1"
    fi
}

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

# Set up actual user - SUDO_USER has priority
tmp=${SUDO_USER:-$_REMOTE_USER}
actual_user=${tmp:-"dmacario"}
actual_home=$(eval echo "~$actual_user")

CURR_DIR=$(pwd)
log "Current dir: $CURR_DIR"
log "Shell: $SHELL"

# Install packages
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    log "Linux detected!"
    log "Installing homebrew"
    su - "$actual_user" -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # TODO: add support for other package managers
    if [ -n "$(apt-get -v)" ]; then
        log "Using Ubuntu/Debian - apt detected!"
        PACMAN="apt"
        apt update
        apt upgrade -y
    elif [ -n "$(pacman -v)" ]; then
        log "Pacman detected!"
        PACMAN="pacman"
        log -e "Pacman not supported yet" && exit 1
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    log "MacOS detected!"
    # Command line tools
    su - "$actual_user" -c xcode-select --install
    # Install homebrew
    if [ -z "$(brew -v)" ]; then
        su - "$actual_user" -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        brew update
        brew upgrade
    fi
fi

package_manager() {
    if [[ "$OSTYPE" == linux-gnu* ]]; then
        "$PACMAN" -y "$@"
    elif [[ "$OSTYPE" == darwin* ]]; then
        brew "$@"
    fi
}

source_env

# packages that have the same name across different platforms
packages_global=(
    tmux
    neofetch
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
    lua5.1
    liblua5.1-0-dev
    bat
)
packages_mac=(
    fd
    golang
)
packages_deb=(
    fd-find
    golang-go
    xclip
)

# Install possible required packages with:
# package_manager install
for package in "${packages_global[@]}"; do
    installing "$package"
    package_manager install "$package"
done

if [[ "$OSTYPE" == "darwin"* ]]; then
    xcode-select --install
    for package in "${packages_mac[@]}"; do
        installing "$package"
        brew install "$package"
    done
else
    for package in "${packages_deb[@]}"; do
        installing "$package"
        apt install -y "$package"
    done
fi

"$(dirname "$0")/scripts/install_fzf.sh" "$actual_user" "$actual_home" || { log "Error installing fzf"; exit 1; }

# Install uv (python env manager)
./scripts/install_uv.sh

# ------------------------------------------------------------------------------

# 1. Install ZSH, OMZ, and p10k
if [[ "$SHELL" != *zsh* ]]; then
    ./scripts/install_zsh.sh "$actual_user" "$actual_home"

    # Install powerlevel10k
    log "Installing p10k"
    rm -rf "${ZSH_CUSTOM:-"$actual_home"/.oh-my-zsh/custom}/themes/powerlevel10k"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-"$actual_home"/.oh-my-zsh/custom}/themes/powerlevel10k"
    correct_ownership "${ZSH_CUSTOM:-"$actual_home"/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

# ------------------------------------------------------------------------------

# 2. Hyperlinks - don't overwrite files if already present

files_to_link=(
    ".bashrc"
    ".fzf.bash"
    ".fzf.zsh"
    ".gitignore"
    ".mac.zshrc"
    ".p10k.zsh"
    ".ubuntu.zshrc"
    ".zshrc"
    ".vimrc"
    ".gitconfig"
    "personal.gitconfig"
    "work.gitconfig"
    "vitestro.gitconfig"
)

for fl in "${files_to_link[@]}"; do
    if [ -f "$CURR_DIR/$fl" ] && [ ! -L "$actual_home/$fl" ]; then
        log "Linking $fl"
        make_link "$fl"
    fi
done

# Github repos
mkdir -p "$GHDIR"

if [ -z "$XDG_CONFIG_HOME" ]; then
    CONFIG_PATH="$actual_home/.config"
else
    CONFIG_PATH="$XDG_CONFIG_HOME"
fi
mkdir -p "$CONFIG_PATH"

# Nvim config
if [ -d "$CURR_DIR/nvim" ]; then
    NVIM_VERSION="${NVIM_VERSION:-v0.10.4}"

    # Check whether neovim is already installed with the default version
    if [ ! -x "$(command -v nvim)" ] || [ "$(nvim -v | awk -F" " '{ print $2 }' | head -n 1)" != "$NVIM_VERSION" ]; then
        log "Installing Neovim $NVIM_VERSION"
        "$CURR_DIR/scripts/install_nvim.sh" "$NVIM_VERSION" "$actual_user" "$actual_home"
        log "Neovim installed successfully!"
    else
        log "Found local installation of Neovim $NVIM_VERSION"
    fi

    if [ ! -L "$CONFIG_PATH/nvim" ]; then
        ln -s "$CURR_DIR/nvim" "$CONFIG_PATH/nvim"
        correct_ownership "$CONFIG_PATH/nvim"
    fi
    get_back

    # Install neovim plugins requirements
    if [[  "$OSTYPE" == "darwin"* ]]; then
        ./scripts/macos-zathura.sh
        brew install pngpaste
    fi

    get_back
    ./scripts/lazygit-install.sh "$actual_user"

    mkdir "$actual_home/.virtualenvs" && cd "$actual_home/.virtualenvs"
    python3 -m venv debugpy
    source debugpy/bin/activate
    pip3 install --upgrade pip
    python3 -m pip install debugpy
    deactivate
    get_back
    correct_ownership "$actual_home/.virtualenvs"
fi

get_back

# Tmux config
# Install the Tmux Plugin Manager
[ ! -d "$actual_home/.tmux/plugins" ]; mkdir -p "$actual_home/.tmux/plugins"
git clone https://github.com/tmux-plugins/tpm.git "$actual_home/.tmux/plugins/tpm"

if [ -n "$XDG_CONFIG_HOME" ] && [ -d "$CURR_DIR/tmux" ]; then  # Should be defined in .zshrc or .env
    if [ ! -L "$XDG_CONFIG_HOME/tmux" ]; then
        ln -s "$CURR_DIR/tmux" "$XDG_CONFIG_HOME/tmux"
        correct_ownership "$XDG_CONFIG_HOME/tmux"
    fi
elif [ -n "$XDG_CONFIG_HOME" ] && [ -f "$CURR_DIR/.tmux.conf" ]; then
    TMUX_XDG_PATH="$XDG_CONFIG_HOME/tmux"
    mkdir "$TMUX_XDG_PATH"
    if [ ! -L "$TMUX_XDG_PATH/tmux.conf" ]; then
        ln -s "$CURR_DIR/.tmux.conf" "$TMUX_XDG_PATH/tmux.conf"
        correct_ownership "$TMUX_XDG_PATH/tmux.conf"
    fi
elif [ -z "$XDG_CONFIG_HOME" ] && [ -d "$CURR_DIR/tmux" ]; then
    if [ ! -L "$actual_home/.tmux.conf" ]; then
        ln -s "$CURR_DIR/tmux/tmux.conf" "$actual_home/.tmux.conf"
        correct_ownership "$actual_home/.tmux.conf"
    fi
elif [ -z "$XDG_CONFIG_HOME" ] && [ -f "$CURR_DIR/.tmux.conf" ]; then
    if [ ! -L "$actual_home/.tmux.conf" ]; then
        ln -s "$CURR_DIR/.tmux.conf" "$actual_home/.tmux.conf"
        correct_ownership "$actual_home/.tmux.conf"
    fi
else
    log "No TMUX config found"
fi

correct_ownership "$actual_home/.tmux"
correct_ownership "$actual_home/.local"
correct_ownership "$CONFIG_PATH"
correct_ownership "$GHDIR"

log "Setup complete! Restart your shell for all the changes to take effect."
