#!/bin/bash

set -eo pipefail

# This script syncs the user between the host environment and the devcontainer.
# It is specific for ubuntu >=24.04 images

# Check runs as root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root." >&2
    exit 1
fi

user=""
uid=""
gid=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --user)
            user="$2"
            shift 2
            ;;
        --uid)
            uid="$2"
            shift 2
            ;;
        --gid)
            gid="$2"
            shift 2
            ;;
    esac
done

if [ -z "$user" ]; then
    echo "Missing --user" >&2
fi
if [ -z "$uid" ]; then
    echo "Missing --uid" >&2
fi
if [ -z "$gid" ]; then
    echo "Missing --gid" >&2
fi

if [ "$uid" -lt 1000 ]; then
    uid=1000
fi
if [ "$gid" -lt 1000 ]; then
    gid=1000
fi

# Delete old user (ubuntu)
userdel -r ubuntu

# Create new user (provided) - defaults to 1000:1000
groupadd --gid="$gid" "$user"
useradd --create-home --shell /bin/bash --gid "$user" --groups sudo --uid="$uid" "$user"

# Make sudoer, no password
mkdir -p "/etc/sudoers.d"
echo "$user ALL=(ALL:ALL) NOPASSWD: ALL" | tee "/etc/sudoers.d/$user"

echo "Created user $user ($uid:$gid)"
