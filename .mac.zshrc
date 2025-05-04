#!/bin/zsh

# Homebrew setup
if [[ $(uname -m) == 'arm64' ]]; then
    BREWPATH="/opt/homebrew/bin"
else
    BREWPATH="/usr/local/bin"
fi
export PATH=$BREWPATH:$PATH

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

alias matlab="/Applications/MATLAB_R2022a.app/bin/matlab -nodesktop"
alias ff="fd --type f --hidden --exclude .git | fzf-tmux -p --preview \"bat --color=always {}\" --reverse"

# Env
export LSCOLORS=gxFxCxDxBxegedabagaced
export TERM="xterm-256color"

complete -o nospace -C /opt/homebrew/bin/terraform terraform
