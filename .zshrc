# ZSH configuration - davmacario

# Setup secrets
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
    touch "$SECRETS/.gitignore"
    # No version control for the keys
    echo "*" >> "$SECRETS/.gitignore"
    echo "!.gitignore" >> "$SECRETS/.gitignore"
    chmod 700 "$SECRETS"
    chown -R "$(whoami)" "$SECRETS"
elif [ "$secrets_perm" != 700 ]; then
    chmod 700 "$SECRETS"
    chown -R "$(whoami)" "$SECRETS"
    # TODO: improve - need all files in there with permission and ownership
fi

# Source secret keys file (not on version control)
# Checks that there are non-hidden files (because there will always be a .gitignore)
if [ -d "$SECRETS" ]; then
    if [ "$(ls "$SECRETS")" ]; then
        for FILE in "$SECRETS"/*; do
            # echo "Sourcing $FILE"
            source "$FILE"
        done
    fi
elif [ -d "$HOME/.keys" ]; then
    if [ "$(ls "$SECRETS")" ]; then
        for FILE in "$HOME/.keys"/*; do
            source "$FILE"
        done
    fi
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use case-sensitive completion.
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

# Use ctrl+space to accept autosuggestion
bindkey '^ ' autosuggest-accept

# User configuration

# Aliases
alias ls='ls --color=auto'
alias ll="ls -l"
alias llm="ll -rt"

alias vim='nvim'
alias k='kubectl'
alias cowsaysomething="fortune | cowsay"
alias tmux="tmux -u"
alias bat="batcat"
alias find_files="fd --type f --hidden --exclude .git | fzf-tmux -p --reverse"

alias gcl='gitlab-ci-local'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Env variables
export PATH="$HOME/go/bin:$PATH"
export GO111MODULE=on
export PATH="$HOME/.fnm:$PATH"
eval "$(fnm env)"
export CLICOLOR=1
export LS_COLORS='rs=0:di=00;36:ln=04;32:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;31:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=04;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;33:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:*.zsh=00;32';
# Set bat theme
export BAT_THEME="gruvbox-dark"
# Change terminal language settings to english:
export LC_ALL=C
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
####
export GHUSER="davmacario"
export GHDIR="$HOME/github"
export GHREPOS="$GHDIR/$GHUSER"
export DOTFILES="$GHREPOS/dotfiles"
# Add local bin to path
export PATH="$PATH:$HOME/.local/bin"
# Go executables
export PATH="$PATH:/usr/local/go/bin"
# Configuration
export XDG_CONFIG_HOME="$HOME/.config"
# Default editor
export EDITOR="nvim"
# kubectl setup
export KUBECONFIG="$HOME/.kube/config"
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Some Lua/Nvim 0.10 thing
export PATH="$PATH:$HOME/.local/share/nvim/lazy-rocks/hererocks/bin"

# Getting around WSL and copy-pasting to/from system clipboard
export DISPLAY=:0

# Use Nvidia GPU
export MESA_D3D12_DEFAULT_ADAPTER_NAME=nvidia

# Gitlab CI Local
NEEDS=true

################
setopt histignorealldups sharehistory
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
