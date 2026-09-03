#!/bin/bash

set -eo pipefail

if command -v uv >/dev/null 2>&1; then
    echo "uv already installed ($(uv --version))"
    # Fails when uv came from a package manager - not a reason to stop
    uv self update || echo "Could not update uv (continuing)"
else
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi
