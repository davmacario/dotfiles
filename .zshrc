# Command(s) ran at the beginning
# if [ -n "$SSH_CLIENT" ]; then
#     neofetch
# fi

# Setup secret keys/passwords - private folder
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

DISABLE_AUTO_UPDATE=true
source $ZSH/oh-my-zsh.sh
# Use ctrl+space to accept autosuggestion
bindkey '^ ' autosuggest-accept

# User configuration
alias ls='ls --color=auto'
alias ll='ls -l'
alias llm='ll -rt'
alias vim='nvim'
alias k='kubectl'
alias cowsaysomething="fortune | cowsay"
alias tmux="tmux -u"
alias gg='lazygit' # Override git gui
alias gcl='gitlab-ci-local'
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias ff='fd --type f --hidden --exclude .git | fzf-tmux -p --preview "bat --color=always {}" --reverse'
else
    alias bat='batcat'
    alias ff="fd --type f --hidden --exclude .git | fzf-tmux -p --preview \"batcat --color=always {}\" --reverse"
fi
alias externalip='curl -sS https://checkip.amazonaws.com/'
alias hl='rg --passthrough'
alias suod='sudo'
if [[ -x "$(command -v powershell.exe)" ]]; then
    alias open='explorer.exe'
fi

### Fix for making Docker plugin work
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f "$HOME/.p10k.zsh" ]] || source "$HOME/.p10k.zsh"
# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export CLICOLOR=1

# Set bat theme
export BAT_THEME="gruvbox-dark"

# kubectl setup
export KUBECONFIG="$HOME/.kube/config"
if command -v kubectl > /dev/null 2>&1; then
    source <(kubectl completion zsh)
fi

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

# FIXME
# Personal scripts - Download repo in setup.sh script
[ -d "$GHREPOS/bash-scripts/src" ] && export PATH="$PATH:$GHREPOS/bash-scripts/src"

setopt histignorealldups sharehistory
HISTSIZE=100000
SAVEHIST=100000
if [ -f /commandhistory/.zsh_history ]; then
    HISTFILE=/commandhistory/.zsh_history
else
    HISTFILE="$HOME/.zsh_history"
fi

autoload -U +X bashcompinit && bashcompinit

# os-specific configuration
if [[ "$OSTYPE" == darwin* ]]; then
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

    alias ff="fd --type f --hidden --exclude .git | fzf-tmux -p --preview \"bat --color=always {}\" --reverse"

    # Env
    export LSCOLORS=gxFxCxDxBxegedabagaced
    export TERM="xterm-256color"

    complete -o nospace -C /opt/homebrew/bin/terraform terraform
elif [[ "$OSTYPE" == linux* ]]; then
    alias bat="batcat"
    alias ff="fd --type f --hidden --exclude .git | fzf-tmux -p --preview \"batcat --color=always {}\" --reverse"

    export LS_COLORS='rs=0:di=00;36:ln=04;32:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;31:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=04;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;33:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:*.zsh=00;32';

    if ! [[ $PATH == */usr/games* ]]; then
        export PATH="$PATH:/usr/games"
    fi

    if [[ -x "$(command -v powershell.exe)" ]]; then
        # We are in WSL (probably) -> add windows executables to path
        export PATH="$PATH:/mnt/c/Windows/system32"
        export BROWSER="/mnt/c/Program Files/Mozilla Firefox/firefox.exe"
    fi

    if ! [[ $PATH == */snap/bin* ]]; then
        export PATH="$PATH:/snap/bin"
    fi

    complete -o nospace -C /usr/bin/terraform terraform
fi

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# opencode
[ -d $HOME/.opencode ] && export PATH=$HOME/.opencode/bin:$PATH
