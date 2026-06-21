#!/usr/bin/env bash

set -euo pipefail

python -m pip install --user uv

path_line='export PATH="$HOME/.local/bin:$PATH"'
for profile in "$HOME/.bashrc" "$HOME/.zshrc"; do
  touch "$profile"
  grep -qxF "$path_line" "$profile" || echo "$path_line" >> "$profile"
done

export PATH="$HOME/.local/bin:$PATH"
uv tool install specify-cli --force --from git+https://github.com/github/spec-kit.git
