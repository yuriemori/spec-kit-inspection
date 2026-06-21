#!/usr/bin/env bash

set -euo pipefail

python -m pip install --user uv
export PATH="$HOME/.local/bin:$PATH"
uv tool install specify-cli --force --from git+https://github.com/github/spec-kit.git
