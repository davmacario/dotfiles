#!/bin/bash
# Set up dotfiles

abort(){
    echo -e "Error encountered - aborting"
    exit 1
}

installing(){
    echo "Installing $1..."
}

trap abort ERR SIGTERM SIGILL

CURR_DIR=$(pwd)
echo "Current dir: $CURR_DIR"

echo "Shell: $SHELL"

# Install packages
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Linux detected!"

    # TODO: add support for other package managers
    if [ -n "$(apt-get -v)" ]; then
        echo "Using Ubuntu/Debian - apt detected!"
        PACMAN="apt"
    elif [ -n "$(pacman -v)" ]; then
        echo "Pacman detected!"
        PACMAN="pacman"
    fi

    INVOKE_PACMAN="sudo $PACMAN -y"

elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "MacOS detected!"
    # Command line tools
    xcode-select --install
    # Install homebrew
    if [ -z "$(brew -v)" ]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        brew update
        brew upgrade
    fi

    INVOKE_PACMAN="brew"
fi

# packages that have the same name across different platforms
packages_global=(
    tmux
    fzf
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
# $INVOKE_PACMAN install
for package in "${packages_global[@]}"; do
    installing "$package"
    $INVOKE_PACMAN install "$package"
done

if [[ "$OSTYPE" == "darwin"* ]]; then
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

# ------------------------------------------------------------------------------

# 1. If using ZSH, install p10k
if [[ "$SHELL" == *"zsh"* ]]; then  # zsh is the shell
    # Install Oh My Zsh
    echo "Installing OMZ"
    cd "$HOME" || echo "Unable to find $HOME" && exit 1
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    # Install powerlevel10k
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-"$HOME"/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

# ------------------------------------------------------------------------------

# 2. Hyperlinks
# NOTE: different branches may not contain all the files
# zshrc:
ZSH_RC="$CURR_DIR/.zshrc"
if [ -f "$ZSH_RC" ] && [ ! -L "$HOME/.zshrc" ];then
    ln -s "$ZSH_RC" "$HOME/.zshrc"
fi
# Source it
if [[ "$SHELL" == *"zsh"* ]]; then  # zsh is the shell
    echo "Sourcing ZSHRC"
    source "$HOME/.zshrc"
fi

# bashrc:
BASH_RC="$CURR_DIR/.bashrc"
if [ -f "$BASH_RC" ] && [ ! -L "$HOME/.bashrc" ];then
    ln -s "$BASH_RC" "$HOME/.bashrc"
fi

if [[ "$SHELL" == *"bash"* ]]; then  # bash is the shell
    echo "Sourcing BASHRC"
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

    if [ ! -L "$CONFIG_PATH/nvim" ]; then
        ln -s "$CURR_DIR/nvim" "$CONFIG_PATH/nvim"
    fi

    echo "Installing Neovim"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        $INVOKE_PACMAN install nvim
        ./macos-zathura.sh
    elif [[ "$OSTYPE" == "linux-gnu"* ]] && [ -f "apt-get -v" ]; then
        # Compile neovim from source
        cd "$GHDIR" || echo "Unable to find GitHub" && exit 1
        mkdir neovim
        cd neovim || exit 2
        git clone https://github.com/neovim/neovim
        cd neovim || exit 2
        git checkout stable
        echo "Building Neovim from source"
        make CMAKE_BUILD_TYPE=RelWithDebInfo
        cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb
    fi

    cd "$CURR_DIR"

    # Install neovim requirements
    if [[  "$OSTYPE" == "darwin"* ]]; then
        brew install pngpaste
    else
        cd "$GHDIR" || exit 1
        git clone https://github.com/jcsalterego/pngpaste.git
        make all
        sudo make install
    fi

    ./scripts/lazygit-install.sh

    mkdir "$HOME/.virtualenvs"
    cd "$HOME/.virtualenvs"
    python3 -m venv debugpy
    source debugpy/bin/activate
    pip3 install --upgrade pip
    python3 -m pip install debugpy
    deactivate
fi

# Tmux config
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
    echo "No TMUX config found"
fi

# Vim config
if [ -f "$CURR_DIR/.vimrc" ] && [ ! -L "$HOME/.vimrc" ]; then
    ln -s "$CURR_DIR/.vimrc" "$HOME/.vimrc"
fi

# Git config
if [ ! -L "$HOME/.gitconfig" ]; then
    ln -s "$CURR_DIR/.gitconfig" "$HOME/.gitconfig"
fi


echo "Setup complete!"
return 0
