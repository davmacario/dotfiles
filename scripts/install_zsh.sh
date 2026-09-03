#!/bin/bash

set -eo pipefail

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

USER=${USER:-$(whoami)}
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

AUTO_CHSH=0
while [[ $# -gt 0 ]]; do
    case "$1" in
        --chsh)
            AUTO_CHSH=1
            shift
            ;;
        *)
            echo "Unknown argument: $1" >&2
            exit 1
            ;;
    esac
done

if [ "$EUID" -eq 0 ]; then
    log "Warning: installing as root"
fi

# Clone a git repository, or fast-forward it when it is already there
clone_or_update() {
    local url="$1" dest="$2" name
    name="$(basename "$dest")"
    if [ -d "$dest/.git" ]; then
        log "Updating $name"
        git -C "$dest" pull --ff-only || log "Could not update $name (continuing)"
    else
        log "Installing $name"
        rm -rf "$dest"
        mkdir -p "$(dirname "$dest")"
        git clone --depth 1 "$url" "$dest"
    fi
}

install_plugins() {
    clone_or_update "https://github.com/zsh-users/zsh-autosuggestions.git" \
        "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
    clone_or_update "https://github.com/zsh-users/zsh-syntax-highlighting.git" \
        "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"
    clone_or_update "https://github.com/jeffreytse/zsh-vi-mode.git" \
        "$ZSH_CUSTOM_DIR/plugins/zsh-vi-mode"
}

# Install ZSH
if command -v zsh >/dev/null 2>&1; then
    log "Zsh already installed ($(command -v zsh))"
else
    log "Installing ZSH"
    if [[ "$OSTYPE" == "linux-gnu"* ]] && command -v apt >/dev/null 2>&1; then
        sudo DEBIAN_FRONTEND=noninteractive apt install zsh -y
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install zsh
    else
        echo "Unsupported OS" >&2
        exit 1
    fi
fi

ZSH_BIN="$(command -v zsh)"

# Install Oh My Zsh
# NOTE: `omz` is a shell function, not an executable, so it cannot be probed
# with `command -v` from here - check for the install directory instead
if [ -d "$HOME/.oh-my-zsh" ]; then
    log "Found existing Oh My Zsh installation in $HOME/.oh-my-zsh"
else
    log "Installing OMZ"
    # --unattended (plus RUNZSH/CHSH) keeps the installer from running chsh and
    # exec'ing an interactive zsh, which would stall this script; KEEP_ZSHRC
    # protects the .zshrc symlink created by make_symlinks.sh
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
        "" --unattended
fi

install_plugins

# Make zsh the login shell.
# $SHELL still points at the old shell for the rest of this session, so read the
# login shell from the passwd database where that is possible
login_shell="$(getent passwd "$USER" 2>/dev/null | cut -d: -f7 || true)"
[ -n "$login_shell" ] || login_shell="$SHELL"

set_default_shell() {
    # chsh works on Linux and MacOS alike - usermod does not exist on MacOS
    if [ -f /etc/shells ] && ! grep -qxF "$ZSH_BIN" /etc/shells; then
        echo "$ZSH_BIN" | sudo tee -a /etc/shells >/dev/null
    fi
    if [ "$EUID" -eq 0 ]; then
        chsh -s "$ZSH_BIN" "$USER"
    else
        sudo chsh -s "$ZSH_BIN" "$USER"
    fi
}

if [[ "$login_shell" == *zsh ]]; then
    log "ZSH ($login_shell) is the default shell already!"
elif [ "$AUTO_CHSH" -eq 1 ]; then
    log "Setting Zsh (${ZSH_BIN}) as default shell"
    set_default_shell
    log "Now log out and back in for the changes to take place"
else
    while true; do
        read -r -p "ZSH is not the default shell, do you want to set it as default? [y/n]  " yn
        case $yn in
            [Yy]*)
                set_default_shell
                log "Now log out and back in for the changes to take place"
                break
                ;;
            [Nn]*)
                # Declining must not abort the caller's setup
                log "Leaving the default shell unchanged"
                break
                ;;
            *)
                echo "Please answer y/n"
                ;;
        esac
    done
fi
