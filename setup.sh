#!/usr/bin/env bash

set -eo pipefail
trap 'abort $LINENO' ERR SIGTERM SIGILL

log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

abort() {
    log "Error encountered at line ${1:-unknown} - aborting" >&2
    exit 1
}

die() {
    log "$1" >&2
    exit 1
}

# Set the owner of the file/directory to the current user:group.
# Only shells out to sudo when the target actually belongs to somebody else
# (i.e. a step that ran as root created it) - otherwise this would prompt for a
# password just to set the ownership that is already in place.
correct_ownership() {
    [ -e "$1" ] || return 0
    local owner
    owner="$(stat -c '%u:%g' "$1" 2>/dev/null || stat -f '%u:%g' "$1" 2>/dev/null || echo "")"
    if [ -n "$owner" ] && [ "$owner" != "${current_uid}:${current_gid}" ]; then
        sudo chown -R "${current_uid}":"${current_gid}" "$1"
    fi
}

# Clone a git repository, or fast-forward it when it is already there.
# A failed update is not fatal: a re-run should not die because we are offline.
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
        git clone --depth=1 "$url" "$dest"
    fi
}

# ------------------------------------------------------------------------------
# Set up user variables

# Resolve the repo location from the script itself, so that the setup works no
# matter what the current working directory is
CURR_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$CURR_DIR"

log "Current dir: $CURR_DIR"
log "Shell: $SHELL"
current_uid="$(id -u)"
current_gid="$(id -g)"
log "Running install script as user $(whoami) ($current_uid:$current_gid)"

# Source installation environment variables
for env_file in install.env .zshenv; do
    [ -f "$CURR_DIR/$env_file" ] || die "Missing required file: $CURR_DIR/$env_file"
    # shellcheck source=/dev/null
    source "$CURR_DIR/$env_file"
done

# Ask for sudo up front, so the password prompt does not land in the middle of
# a long, unattended-looking run
if [ "$EUID" -ne 0 ]; then
    sudo -v
fi

# ------------------------------------------------------------------------------
# Detect the OS and the package manager

case "$OSTYPE" in
    linux-gnu*)
        log "Linux detected!"
        # TODO: add support for other package managers (pacman, dnf, ...)
        if command -v apt >/dev/null 2>&1; then
            log "Using Ubuntu/Debian - apt detected!"
            export DEBIAN_FRONTEND=noninteractive
            PACKAGE_MANAGER="apt"
            sudo apt update
            sudo apt upgrade -y
        else
            die "Unsupported Linux distribution: no supported package manager found"
        fi
        ;;
    darwin*)
        log "MacOS detected!"
        PACKAGE_MANAGER="brew"
        ;;
    *)
        die "Unsupported OS: ${OSTYPE:-unknown}"
        ;;
esac

package_manager() {
    case "$PACKAGE_MANAGER" in
        apt)
            sudo DEBIAN_FRONTEND=noninteractive apt -y "$@"
            ;;
        brew)
            brew "$@"
            ;;
        *)
            die "No package manager configured"
            ;;
    esac
}

# ------------------------------------------------------------------------------
# Homebrew (required on MacOS, optional elsewhere)

# Make an already-installed brew usable from this shell session
brew_shellenv() {
    local candidate
    for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew \
        /home/linuxbrew/.linuxbrew/bin/brew "$HOME/.linuxbrew/bin/brew"; do
        if [ -x "$candidate" ]; then
            eval "$("$candidate" shellenv)"
            return 0
        fi
    done
    return 1
}

install_homebrew() {
    if command -v brew >/dev/null 2>&1 || brew_shellenv; then
        log "Updating homebrew"
        brew update
        brew upgrade
        return 0
    fi

    # The installer refuses to run as root, and there is no sane way around it
    if [ "$EUID" -eq 0 ]; then
        if [ "$PACKAGE_MANAGER" = "brew" ]; then
            die "Homebrew cannot be installed as root, and it is required on MacOS"
        fi
        log "Skipping Homebrew: it cannot be installed as root"
        return 0
    fi

    log "Installing homebrew"
    NONINTERACTIVE=1 /bin/bash -c \
        "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew_shellenv || die "Homebrew installed but 'brew' could not be located"
    brew update
}

# On MacOS brew provides every package below, so it has to be installed first.
# On Linux the installer itself needs a compiler and a few utilities, which apt
# provides in the package step - so that call is deferred until after it.
if [ "$PACKAGE_MANAGER" = "brew" ]; then
    install_homebrew
fi

# ------------------------------------------------------------------------------
# Install packages

# Packages whose name is the same across every supported platform
declare -a packages_global=(
    tmux
    htop
    git
    cmake
    gcc
    whois
    gettext
    ripgrep
    unzip
    curl
    telnet
    lua5.1
    liblua5.1-0-dev
    shellcheck
    bat
    pipx
)

declare -a packages_mac=(
    python3
    ninja
    node
    lua@5.1
    fd
    go
)
declare -a packages_deb=(
    python3
    python3-dev
    python3-pip
    python3-venv
    ninja-build
    npm
    build-essential
    lua5.1
    liblua5.1-0-dev
    fd-find
    golang-go
    xclip
    # Required by the Homebrew installer on Linux
    procps
    file
)

if [ "$PACKAGE_MANAGER" = "brew" ]; then
    # Exits non-zero when the command line tools are already installed
    xcode-select --install 2>/dev/null || log "Xcode command line tools already installed"
    packages_all=("${packages_global[@]}" "${packages_mac[@]}")
else
    packages_all=("${packages_global[@]}" "${packages_deb[@]}")
fi

package_manager install "${packages_all[@]}"

# Linuxbrew, now that its build dependencies are in place.
# NOTE: ~/.zprofile eval's `brew shellenv` for interactive shells
if [ "$PACKAGE_MANAGER" != "brew" ]; then
    install_homebrew
fi

# Install fzf from source
"$CURR_DIR/scripts/install_fzf.sh" || die "Error installing fzf"

# Install uv (python env manager)
"$CURR_DIR/scripts/install_uv.sh"

# Install npm packages
if command -v npm >/dev/null 2>&1; then
    log "Installing tree-sitter-cli"
    npm_prefix="$(npm config get prefix)"
    if [ -w "$npm_prefix" ]; then
        npm install -g tree-sitter-cli
    else
        sudo npm install -g tree-sitter-cli
    fi
fi

# ------------------------------------------------------------------------------

# 1. Install ZSH, OMZ, and p10k
# NOTE: gated on the artifacts themselves, not on $SHELL: zsh can already be
# the login shell on a machine where OMZ/p10k have never been installed
"$CURR_DIR/scripts/install_zsh.sh" --chsh

P10K_DIR="${ZSH_CUSTOM:-"$HOME"/.oh-my-zsh/custom}/themes/powerlevel10k"
clone_or_update https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
correct_ownership "$P10K_DIR"

if [ ! -f "$HOME/.zsh_history" ]; then
    touch "$HOME/.zsh_history"
    correct_ownership "$HOME/.zsh_history"
fi

# ------------------------------------------------------------------------------
# 2. Symlinks - existing regular files/dirs are backed up as <name>.bak
log "Symlinking..."
"$CURR_DIR/scripts/make_symlinks.sh" "$CURR_DIR"

# ------------------------------------------------------------------------------
# 3. User configuration

# Github repos
mkdir -p "$GHDIR"

# Nvim config
if [ -d "$CURR_DIR/nvim" ]; then
    # Single source of truth for the version: install.env
    [ -n "$NVIM_VERSION" ] || die "NVIM_VERSION is not set (expected from install.env)"

    nvim_current=""
    if command -v nvim >/dev/null 2>&1; then
        nvim_current="$(nvim --version | awk 'NR==1 { print $2 }')"
    fi

    if [ "$nvim_current" != "$NVIM_VERSION" ]; then
        log "Installing Neovim $NVIM_VERSION"
        "$CURR_DIR/scripts/install_nvim.sh" --nvim-version "$NVIM_VERSION"
        log "Neovim installed successfully!"
    else
        log "Found local installation of Neovim $NVIM_VERSION"
    fi

    # Install neovim plugins requirements
    # TODO: put into dedicated script
    if [ "$PACKAGE_MANAGER" = "brew" ]; then
        "$CURR_DIR/scripts/macos-zathura.sh"
        brew install pngpaste
    fi

    "$CURR_DIR/scripts/lazygit-install.sh"

    # Virtualenv holding the debug adapter, see nvim/lua/dmacario/lazy/dap.lua
    DEBUGPY_VENV="$HOME/.virtualenvs/debugpy"
    mkdir -p "$HOME/.virtualenvs"
    if [ ! -x "$DEBUGPY_VENV/bin/python3" ]; then
        log "Creating the debugpy virtualenv"
        python3 -m venv "$DEBUGPY_VENV" # FIXME: pin python version
    fi
    "$DEBUGPY_VENV/bin/python3" -m pip install --upgrade pip debugpy
fi

# Tmux config
# Install the Tmux Plugin Manager - loaded from ~/.tmux/plugins/tpm by tmux.conf
clone_or_update https://github.com/tmux-plugins/tpm.git "$HOME/.tmux/plugins/tpm"

log "Setup complete! Restart your shell for all the changes to take effect."
