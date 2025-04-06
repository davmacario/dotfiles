# Command(s) ran at the beginning
if [ -n "$SSH_CLIENT" ];
then
    neofetch
fi

# Setup secret keys/passwords - private folder
export SECRETS="$HOME/.keys"
# Create folder if not there
if [ ! -d "$SECRETS" ]; then
    mkdir "$SECRETS"
    # No version control for the keys
    touch "$SECRETS/.gitignore"
    echo "*" >> "$SECRETS/.gitignore"
    echo "!.gitignore" >> "$SECRETS/.gitignore"
    chmod 600 "$SECRETS/.gitignore"
    chmod 700 "$SECRETS"
    chown -R "$(whoami)" "$SECRETS"
else
    # Evaluate permissions on secrets folder - syntax changes between Linux and Mac
    if [[ "$OSTYPE" == "darwin"* ]]; then
        secrets_perm=$(stat -f '%A %a %N' "$SECRETS")
    else
        secrets_perm=$(stat -c '%a %n' "$SECRETS")
    fi
    if [ "$secrets_perm" != 700 ]; then
        chmod 700 "$SECRETS"
        chown -R "$(whoami)" "$SECRETS"
        # Source secret keys file
        if [ "$(ls "$SECRETS")" ]; then
            for file in "$SECRETS"/*; do
                chmod 600 "$file"
            done
        fi
    fi
fi

# Source secret keys file
# Checks that there are non-hidden files (because there will always be a .gitignore)
if [ "$(ls "$SECRETS")" ]; then
    for file in "$SECRETS"/*; do
        # echo "Sourcing $FILE"
        [ -f "$file" ] && source "$file"
    done
fi

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

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Case-sensitive completion.
CASE_SENSITIVE="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    docker
    docker-compose
    colored-man-pages
    colorize
    pip
    python
    brew
    macos
    terraform
    opentofu
    nmap
)
source $ZSH/oh-my-zsh.sh
# Use ctrl+space to accept autosuggestion
bindkey '^ ' autosuggest-accept

# User configuration
alias ls='ls --color=auto'
alias ll="ls -l"
alias llm="ll -rt"
alias vim='nvim'
alias k='kubectl'
alias cowsaysomething="fortune | cowsay"
alias tmux="tmux -u"
alias gg="lazygit" # Override git gui
alias gcl='gitlab-ci-local'
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias ff="fd --type f --hidden --exclude .git | fzf-tmux -p --preview \"bat --color=always {}\" --reverse"
else
    alias bat="batcat"
    alias ff="fd --type f --hidden --exclude .git | fzf-tmux -p --preview \"batcat --color=always {}\" --reverse"
fi

### Fix for making Docker plugin work
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i

# Environment
export EDITOR="nvim"
export GHUSER="davmacario"
export GHDIR="$HOME/github"
export GHREPOS="$GHDIR/$GHUSER"
export DOTFILES="$GHREPOS/dotfiles"
export XDG_CONFIG_HOME="$HOME/.config"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f "$HOME/.p10k.zsh" ]] || source "$HOME/.p10k.zsh"
# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="$PATH:$HOME/go/bin"
export GO111MODULE=on

if [ -x "$(command -v fnm)" ]; then
    export PATH="$PATH:$HOME/.fnm"
    eval "$(fnm env)"
fi

export CLICOLOR=1

# Set bat theme
export BAT_THEME="gruvbox-dark"
# Change terminal language settings to english:
export LC_ALL=C

# Add local bin to path
export PATH="$PATH:$HOME/.local/bin"

# Go executables
export PATH="$PATH:$HOME/go/bin:/usr/local/go/bin"

# kubectl setup
export KUBECONFIG="$HOME/.kube/config"

# Rust setup
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Some Lua/Nvim 0.10 thing
export PATH="$PATH:$HOME/.local/share/nvim/lazy-rocks/hererocks/bin"

# DBus settings
export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_LAUNCHD_SESSION_BUS_SOCKET"

# Manpage colors
export MANPAGER="less -R --use-color -Dd+r -Du+b"

# Personal scripts - Download repo in setup.sh script
[ -d "$GHREPOS/bash-scripts/src" ] && export PATH="$PATH:$GHREPOS/bash-scripts/src"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

setopt histignorealldups sharehistory
HISTSIZE=100000
SAVEHIST=100000
HISTFILE="$HOME/.zsh_history"

autoload -U +X bashcompinit && bashcompinit

if [[ "$OSTYPE" == darwin* ]] && [[ -f "$HOME/.mac.zshrc" ]]; then
    source "$HOME/.mac.zshrc"
elif [[ "$OSTYPE" == linux* ]] && [[ -f "$HOME/.ubuntu.zshrc" ]]; then
    source "$HOME/.ubuntu.zshrc"
fi
