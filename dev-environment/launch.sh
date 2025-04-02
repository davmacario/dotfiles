#!/usr/bin/env bash

set -euo pipefail

usage() {
    echo -e "Set up the dev environment from a repository containing the Dotfiles"
    echo -e "Usage: $0 --repo <repo_url> --entrypoint <script_name> [--branch <branch_name>]"
    echo ""
    echo -e "Arguments:"
    echo -e "--repo <repo_url>              URL of the repository containing the dotfiles"
    echo -e "--entrypoint <script_name>     name of the script that will be used to install the dotfiles;"
    echo -e "                               must be located in the repo"
    echo -e "[--branch <branch_name>]       optionally, provide the Git branch name; if not provided, the"
    echo -e "                               default branch will be used"
}

REQUIREMENTS_PKG=(
    git
)

check_requirements() {
    for req in "${REQUIREMENTS_PKG[@]}"; do
        if ! [ -x "$(command -v "$req")" ]; then
            echo "Missing requirement: $req"
            exit 1
        fi
    done
}

check_requirements

REPO_DOTFILES=${REPO_DOTFILES:-""}
ENTRYPOINT=${ENTRYPOINT:-""}
CUSTOM_BRANCH=${CUSTOM_BRANCH:-""}

# while [[ $# -gt 0 ]]; do
#     case $1 in
#         repo)
#             REPO_DOTFILES=$2
#             shift
#             shift
#             ;;
#         entrypoint)
#             ENTRYPOINT=$2
#             shift
#             shift
#             ;;
#         branch)
#             CUSTOM_BRANCH=$2
#             shift
#             shift
#             ;;
#         \?)
#             echo "Invalid option -$2" >&2
#             usage
#             exit 1
#             ;;
#     esac
# done

# check if required arguments are provided
echo "Repo: $REPO_DOTFILES"
echo "Entrypoint: $ENTRYPOINT"
if [ -z "$REPO_DOTFILES" ] || [ -z "$ENTRYPOINT" ]; then
    echo "--repo and --entrypoint are required arguments!"
    usage
    exit 1
fi

cd "$HOME" || (echo "HOME not set" && exit 1)
if [ ! -d ./dotfiles ]; then
    git clone "$REPO_DOTFILES" ./dotfiles
fi
cd ./dotfiles || exit 1
if [ -n "$CUSTOM_BRANCH" ]; then
    git checkout "$CUSTOM_BRANCH"
fi
git pull -p

bash -c "$ENTRYPOINT"
