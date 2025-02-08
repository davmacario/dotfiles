#!/bin/bash
# Set up dotfiles

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

abort() {
    log -e "Error encountered - aborting"
    exit 1
}

installing() {
    log "Installing $1..."
}

get_back() {
    cd "$CURR_DIR" || log "Something went wrong!" && exit 1
}

trap abort ERR SIGTERM SIGILL

CURR_DIR=$(pwd)
log "Current dir: $CURR_DIR"
log "Shell: $SHELL"

# Install packages
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    log "Linux detected!"
    # TODO: add support for other package managers
    if [ -n "$(apt-get -v)" ]; then
        log "Using Ubuntu/Debian - apt detected!"
        PACMAN="apt"
    elif [ -n "$(pacman -v)" ]; then
        log "Pacman detected!"
        PACMAN="pacman"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    log "MacOS detected!"
    # Command line tools
    xcode-select --install
    # Install homebrew
    if [ -z "$(brew -v)" ]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        brew update
        brew upgrade
    fi
fi

package_manager() {
    if [[ "$OSTYPE" == linux-gnu* ]]; then
        sudo "$PACMAN" -y "$@"
    elif [[ "$OSTYPE" == darwin* ]]; then
        brew "$@"
    fi
}

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
    shellcheck
    lua5.1
    liblua5.1-0-dev
)
packages_mac=(
    bat
    fd
    golang
)
packages_deb=(
    batcat
    golang-go
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
        sudo apt install "$package"
    done
fi

# Install fzf from source
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# ------------------------------------------------------------------------------

# 1. If using ZSH, install p10k
if [[ "$SHELL" == *"zsh"* ]]; then  # zsh is the shell
    # Install Oh My Zsh
    log "Installing OMZ"
    cd "$HOME" || log "Unable to find $HOME" && exit 1
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    # Install powerlevel10k
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-"$HOME"/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

# ------------------------------------------------------------------------------

# 2. Hyperlinks - don't overwrite files if already present

make_link() {
    if [ -f "$CURR_DIR/$1" ] && [ ! -L "$HOME/$1" ]; then
        ln -s "$CURR_DIR/$1" "$HOME/$1"
    fi
}

files_to_link=(
    ".bashrc"
    ".fzf.bash"
    ".fzf.zsh"
    ".gitignore"
    ".mac.zshrc"
    ".p10k.zsh"
    ".ubuntu.zshrc"
    ".zshrc"
)

for fl in "${files_to_link[@]}"; do
    make_link "$fl"
done

# Source shellrc
if [[ "$SHELL" == *"zsh"* ]] && [[ -f "$HOME/.zshrc" ]]; then
    log "Sourcing ZSHRC"
    source "$HOME/.zshrc"
elif [[ "$SHELL" == *bash* ]] && [[ -f "$HOME/.bashrc" ]]; then
    log "Sourcing BASHRC"
    source "$HOME/.bashrc"
fi

# Github repos
GHDIR="$HOME/github"
mkdir -p "$GHREPOS"

if [ -z "$XDG_CONFIG_HOME" ]; then
    CONFIG_PATH="$HOME/.config"
else
    CONFIG_PATH="$XDG_CONFIG_HOME"
fi

# Nvim config
if [ -d "$CURR_DIR/nvim" ]; then
    NVIM_VERSION="${NVIM_VERSION:-v0.10.4}"
    log "Installing Neovim $NVIM_VERSION"
    $CURR_DIR/scripts/nvim-install.sh "$NVIM_VERSION"

    if [ ! -L "$CONFIG_PATH/nvim" ]; then
        ln -s "$CURR_DIR/nvim" "$CONFIG_PATH/nvim"
    fi
    get_back

    # Install neovim plugins requirements
    if [[  "$OSTYPE" == "darwin"* ]]; then
        ./macos-zathura.sh
        brew install pngpaste
    else
        pushd "$GHDIR" || exit 1
        git clone https://github.com/jcsalterego/pngpaste.git
        cd ./pngpaste
        make all
        sudo make install
        popd
    fi

    get_back
    ./scripts/lazygit-install.sh

    mkdir "$HOME/.virtualenvs" && cd "$HOME/.virtualenvs"
    python3 -m venv debugpy
    source debugpy/bin/activate
    pip3 install --upgrade pip
    python3 -m pip install debugpy
    deactivate
fi

get_back

# Tmux config
# Install the Tmux Plugin Manager
[ ! -d "$HOME/.tmux/plugins" ]; mkdir -p "$HOME/.tmux/plugins"
git clone https://github.com/tmux-plugins/tpm.git "$HOME/.tmux/plugins/tpm"

if [ -n "$XDG_CONFIG_HOME" ] && [ -d "$CURR_DIR/tmux" ]; then  # Should be defined in .zshrc
    if [ ! -L "$XDG_CONFIG_HOME/tmux" ]; then
        ln -s "$CURR_DIR/tmux" "$XDG_CONFIG_HOME/tmux"
    fi
elif [ -n "$XDG_CONFIG_HOME" ] && [ -f "$CURR_DIR/.tmux.conf" ]; then
    TMUX_XDG_PATH="$XDG_CONFIG_HOME/tmux"
    mkdir TMUX_XDG_PATH
    if [ ! -L "$TMUX_XDG_PATH/tmux.conf" ]; then
        ln -s "$CURR_DIR/.tmux.conf" "$TMUX_XDG_PATH/tmux.conf"
    fi
elif [ -z "$XDG_CONFIG_HOME" ] && [ -d "$CURR_DIR/tmux" ]; then
    if [ ! -L "$HOME/.tmux.conf" ]; then
        ln -s "$CURR_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
    fi
elif [ -z "$XDG_CONFIG_HOME" ] && [ -f "$CURR_DIR/.tmux.conf" ]; then
    if [ ! -L "$HOME/.tmux.conf" ]; then
        ln -s "$CURR_DIR/.tmux.conf" "$HOME/.tmux.conf"
    fi
else
    log "No TMUX config found"
fi

# Vim config
if [ -f "$CURR_DIR/.vimrc" ] && [ ! -L "$HOME/.vimrc" ]; then
    ln -s "$CURR_DIR/.vimrc" "$HOME/.vimrc"
fi

# Git config
if [ ! -L "$HOME/.gitconfig" ]; then
    ln -s "$CURR_DIR/.gitconfig" "$HOME/.gitconfig"
fi


log "Setup complete!"
return 0
