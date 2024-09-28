# Command(s) ran at the beginning
if [ -n "$SSH_CLIENT" ];
then
    neofetch
fi

# Setup secret keys/passwords - private folder
export SECRETS="$HOME/.keys"
# Evaluate permissions on secrets folder - syntax changes between Linux and Mac
if [[ "$OSTYPE" == "darwin"* ]]; then
    secrets_perm=$(stat -f '%A %a %N' "$SECRETS")
else
    secrets_perm=$(stat -c '%a %n' "$SECRETS")
fi
# Create folder if not there
if [ ! -d "$SECRETS" ]; then
    mkdir "$SECRETS"
    # No version control for the keys
    touch "$SECRETS/.gitignore"
    echo "*" >> "$SECRETS/.gitignore"
    echo "!.gitignore" >> "$SECRETS/.gitignore"
    chmod -R 700 "$SECRETS"
    chown -R "$(whoami)" "$SECRETS"
elif [ "$secrets_perm" != 600 ]; then
    chmod -R 700 "$SECRETS"
    chown -R "$(whoami)" "$SECRETS"
fi

# Source secret keys file (not on version control)
if [ -d "$SECRETS" ]; then
    if [ "$(ls "$SECRETS")" ]; then
        for FILE in "$SECRETS"/*; do
            source "$FILE"
        done
    fi
fi

# Homebrew setup
if [[ $(uname -m) == 'arm64' ]]; then
    BREWPATH=/opt/homebrew/bin
else
    BREWPATH=/usr/local/bin
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

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

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
)
source $ZSH/oh-my-zsh.sh
bindkey '^ ' autosuggest-accept  # Use ctrl+space to accept autosuggestion

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

PROMPT="%B%F{47}%n@%m%f%b:%F{cyan}%~ %#%f "

alias ls='ls -G'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f "$HOME/.p10k.zsh" ]] || source "$HOME/.p10k.zsh"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/dmacario/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/dmacario/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/dmacario/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/dmacario/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

alias vim='/opt/homebrew/bin/nvim'
alias matlab="/Applications/MATLAB_R2022a.app/bin/matlab -nodesktop"
alias k='kubectl'
alias cowsaysomething="fortune | cowsay"
alias tmux="tmux -u"

### Fix for making Docker plugin work
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i

# Environment variables
export CLICOLOR=1
export LSCOLORS=gxFxCxDxBxegedabagaced
# Set bat theme
export BAT_THEME="gruvbox-dark"
# Change terminal language settings to english:
export LC_ALL=C
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

export GHUSER="davmacario"
export GHDIR="$HOME/github"
export GHREPOS="$GHDIR/$GHUSER"
export DOTFILES="$GHREPOS/dotfiles"

# Add local bin to path
export PATH="$PATH:$HOME/.local/bin"

# Go executables
export PATH="$PATH:$HOME/go/bin:/usr/local/go/bin"

# Configuration
export XDG_CONFIG_HOME="$HOME/.config"

# kubectl setup
export KUBECONFIG="$HOME/.kube/config"

# Rust setup
source "$HOME/.cargo/env"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# DBus settings
export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_LAUNCHD_SESSION_BUS_SOCKET"
export EDITOR="nvim"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform
