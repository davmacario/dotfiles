# Setup fzf

# ensure backward compatibility
for fzf_dir in "${XDG_DATA_HOME:-$HOME/.local/share}/.fzf" "$HOME/.fzf"; do
  if [[ -d "$fzf_dir/bin" && "$PATH" != *"$fzf_dir/bin"* ]]; then
    export PATH="${PATH:+${PATH}:}$fzf_dir/bin"
  fi
done
unset fzf_dir

# Guarded: without it every new shell errors out when fzf is not installed yet
if (( $+commands[fzf] )); then
  source <(fzf --zsh)
fi
