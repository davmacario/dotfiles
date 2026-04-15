# XDG
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
# Local keys
export SECRETS="$HOME/.keys"

# Allow for per-machine customization
[[ -f "$HOME/.zshenv.local" ]] && source "$HOME/.zshenv.local" || true
