# Set up dotfiles

CURR_DIR=$(dirname "$0")

# Install packages
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Linux detected!"

    # TODO: add support for other package managers
    if [ -f "apt -v" ]; then
        echo "Using Ubuntu/Debian - apt detected!"
        PACMAN="apt"
        if [ -f "apt-get -v" ];then
            sudo apt-get install python-dev python-pip python3-dev python3-pip
            sudo apt-get install ninja-build gettext cmake unzip curl build-essential
        fi
    elif [ -f "pacman -v" ]; then
        echo "Pacman detected!"
        PACMAN="pacman"
    fi

    INVOKE_PACMAN="sudo $PACMAN"
    # Can install linux-specific packages here

elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "MacOS detected!"
    # Command line tools
    xcode-select --install
    # Install homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    INVOKE_PACMAN="brew"
fi

# Install possible required packages with:
# $INVOKE_PACMAN install
$INVOKE_PACMAN install tmux fzf neofetch htop

# ------------------------------------------------------------------------------

# 1. If using ZSH, install p10k
if [ -n "$($SHELL -c "echo $ZSH_VERSION")" ]; then  # zsh is preferred
    # Install Oh My Zsh
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
if [ -f "$ZSH_RC" ];then
    ln -s "$ZSH_RC" "$HOME/.zshrc"
fi
# Source it
if [ -n "$($SHELL -c "echo $ZSH_VERSION")" ]; then  # zsh is preferred
    source "$HOME/.zshrc"
fi

# bashrc:
BASH_RC="$CURR_DIR/.bashrc"
if [ -f "$BASH_RC" ];then
    ln -s "$BASH_RC" "$HOME/.bashrc"
fi

if [ -n "$($SHELL -c 'echo $BASH_VERSION')" ]; then  # bash is preferred
    source "$HOME/.bashrc"
fi

# Github repos
GHDIR="$HOME/github"
mkdir -p "$GHREPOS"

# Nvim config
if [ -d "$CURR_DIR/nvim" ]; then
    ln -s "$CURR_DIR/nvim" "$HOME/.config/nvim"

    echo "Installing Neovim"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        $INVOKE_PACMAN install nvim
    elif [[ "$OSTYPE" == "linux-gnu"* ]] && [ -f "apt-get -v" ]; then
        # Compile neovim from source
        cd "$GHDIR" || echo "Unable to find GitHub" && exit 1
        mkdir neovim
        cd neovim || exit 2
        git clone https://github.com/neovim/neovim
        cd neovim || exit 2
        git checkout stable
        make CMAKE_BUILD_TYPE=RelWithDebInfo
        echo "Building Neovim from source"
        cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb
    fi

    cd "$CURR_DIR"

    # Install neovim requirements
    $INVOKE_PACMAN install fd-find

    if [[  "$OSTYPE" == "darwin"* ]]; then
        brew install pngpaste
    else
        cd "$GHDIR" || exit 1
        git clone https://github.com/jcsalterego/pngpaste.git
        make all
        sudo make install
    fi

    mkdir "$HOME/.virtualenvs"
    cd "$HOME/.virtualenvs"
    python -m venv debugpy
    debugpy/bin/python -m pip install debugpy
fi

# Tmux config
if [ -n "$XDG_CONFIG_HOME" ] && [ -d "$CURR_DIR/tmux" ]; then  # Should be defined in .zshrc
    ln -s "$CURR_DIR/tmux" "$XDG_CONFIG_HOME/tmux"
elif [ -n "$XDG_CONFIG_HOME" ] && [ -f "$CURR_DIR/.tmux.conf" ]; then
    TMUX_XDG_PATH="$XDG_CONFIG_HOME/tmux"
    mkdir TMUX_XDG_PATH
    ln -s "$CURR_DIR/.tmux.conf" "$TMUX_XDG_PATH/tmux.conf"
elif [ -z "$XDG_CONFIG_HOME" ] && [ -d "$CURR_DIR/tmux" ]; then
    ln -s "$CURR_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
elif [ -z "$XDG_CONFIG_HOME" ] && [ -f "$CURR_DIR/.tmux.conf" ]; then
    ln -s "$CURR_DIR/.tmux.conf" "$HOME/.tmux.conf"
else
    echo "No TMUX config found"
fi

# Vim config
if [ -f "$CURR_DIR/.vimrc" ]; then
    ln -s "$CURR_DIR/.vimrc" "$HOME/.vimrc"
fi
