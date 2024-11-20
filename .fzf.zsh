# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/dmacario/.fzf/bin"
fi

source <(fzf --zsh)
