#!/usr/bin/env bash

set -euo pipefail

python -m pip install --user uv==0.11.23

path_line='export PATH="$HOME/.local/bin:$PATH"'
for profile in "$HOME/.bashrc" "$HOME/.zshrc"; do
  touch "$profile"
  grep -qxF "$path_line" "$profile" || echo "$path_line" >> "$profile"
done

export PATH="$HOME/.local/bin:$PATH"

if ! command -v specify >/dev/null 2>&1; then
  uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
fi
