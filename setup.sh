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

# Install fzf from source
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

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
    echo "Sourcing ZSHRC"
    source "$HOME/.zshrc"
elif [[ "$SHELL" == *bash* ]] && [[ -f "$HOME/.bashrc" ]]; then
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
# Install the Tmux Plugin Manager

[ ! -d "$HOME/.tmux/plugins" ]; mkdir -p "$HOME/.tmux/plugins"
git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

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
