#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v code >/dev/null 2>&1; then
  echo "VS Code CLI 'code' was not found. Open VS Code and install the shell command first."
  exit 1
fi

while IFS= read -r extension; do
  [ -z "$extension" ] && continue
  code --install-extension "$extension"
done < "$ROOT/vscode/extensions.txt"
