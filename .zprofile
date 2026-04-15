# User config
export EDITOR="nvim"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/go/bin:/usr/local/go/bin"
export GO111MODULE=on
# Homebrew setup
if [[ "$OSTYPE" == "darwin"* ]]; then
    if [[ $(uname -m) == 'arm64' ]]; then
        BREWPATH="/opt/homebrew/bin"
    else
        BREWPATH="/usr/local/bin"
    fi
else
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    BREWPATH="/usr/local/bin"
fi
export PATH=$BREWPATH:$PATH

if [ -x "$(command -v fnm)" ]; then
    export PATH="$PATH:$HOME/.fnm"
    eval "$(fnm env)"
fi

export PATH="$PATH:$HOME/.rvm/bin"

# Change terminal language settings to english:
export LC_ALL="en_US.UTF-8"

# Github
export GHUSER="davmacario"
export GHDIR="$HOME/github"
export GHREPOS="$GHDIR/$GHUSER"
export DOTFILES="$GHREPOS/dotfiles"
