#!/bin/bash

set -eo pipefail

# Version is normally provided by install.env via setup.sh
NVIM_VERSION="${NVIM_VERSION:-latest}"
COMPILE="false"
while [[ $# -gt 0 ]]; do
    case "$1" in
        --nvim-version)
            NVIM_VERSION="$2"
            shift 2
            ;;
        --compile)
            COMPILE="true"
            shift
            ;;
        *)
            echo "Unknown argument: $1" >&2
            exit 1
            ;;
    esac
done

SUDO=""
if [ "$EUID" -ne 0 ]; then
    SUDO="sudo"
fi

njobs="$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1)"

if [ "$COMPILE" = "true" ]; then
    echo "Compiling Nvim $NVIM_VERSION from source"
    GHDIR=${GHDIR:-"$HOME/github"}
    NVIM_SRC="$GHDIR/neovim/neovim"
    mkdir -p "$GHDIR/neovim"

    if [ ! -d "$NVIM_SRC/.git" ]; then
        git clone https://github.com/neovim/neovim.git "$NVIM_SRC"
    else
        echo "Found local clone of Neovim repo"
        # Stale build artifacts from another version make the build fail
        make -C "$NVIM_SRC" distclean || true
    fi

    git -C "$NVIM_SRC" fetch --prune --tags origin
    if [ "$NVIM_VERSION" = "latest" ]; then
        git -C "$NVIM_SRC" checkout master
        git -C "$NVIM_SRC" pull --ff-only
    else
        # Checking out the tag directly: `git pull` on a detached HEAD fails
        git -C "$NVIM_SRC" checkout "tags/$NVIM_VERSION"
    fi

    make -C "$NVIM_SRC" -j"$njobs" CMAKE_BUILD_TYPE="${NVIM_CMAKE_BUILD_TYPE:-"RelWithDebInfo"}"
    $SUDO make -C "$NVIM_SRC" install
else
    # Release asset for this platform
    case "$OSTYPE" in
        darwin*)
            case "$(uname -m)" in
                arm64 | aarch64) NVIM_ASSET="nvim-macos-arm64" ;;
                x86_64 | amd64) NVIM_ASSET="nvim-macos-x86_64" ;;
                *) echo "Unsupported architecture: $(uname -m)" >&2 && exit 1 ;;
            esac
            ;;
        linux-gnu*)
            case "$(uname -m)" in
                x86_64 | amd64) NVIM_ASSET="nvim-linux-x86_64" ;;
                aarch64 | arm64) NVIM_ASSET="nvim-linux-arm64" ;;
                *) echo "Unsupported architecture: $(uname -m)" >&2 && exit 1 ;;
            esac
            ;;
        *)
            echo "Unsupported OS: ${OSTYPE:-unknown}" >&2
            exit 1
            ;;
    esac

    if [ "$NVIM_VERSION" = "latest" ]; then
        NVIM_URL="https://github.com/neovim/neovim/releases/latest/download/$NVIM_ASSET.tar.gz"
    else
        NVIM_URL="https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/$NVIM_ASSET.tar.gz"
    fi

    echo "Downloading Nvim $NVIM_VERSION ($NVIM_ASSET) from releases"
    tmpdir="$(mktemp -d)"
    # shellcheck disable=SC2064  # expand tmpdir now, it is what we want removed
    trap "rm -rf '$tmpdir'" EXIT

    # -f so that a 404 fails here instead of unpacking an HTML error page
    curl -fLo "$tmpdir/nvim.tar.gz" "$NVIM_URL"

    if [[ "$OSTYPE" == darwin* ]]; then
        # The MacOS release tarballs are quarantined by Gatekeeper
        xattr -c "$tmpdir/nvim.tar.gz" 2>/dev/null || true
    fi

    $SUDO rm -rf "/opt/$NVIM_ASSET"
    $SUDO tar -C /opt -xzf "$tmpdir/nvim.tar.gz"
    $SUDO mkdir -p /usr/local/bin
    # -f: the symlink survives the rm above, so plain `ln -s` would fail here
    $SUDO ln -sfn "/opt/$NVIM_ASSET/bin/nvim" /usr/local/bin/nvim
fi
