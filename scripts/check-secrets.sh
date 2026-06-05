#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$ROOT"

if rg -n -i \
  "(token|secret|password|passwd|api[_-]?key|private[_-]?key|credential|access[_-]?key|bearer|oauth|ghp_[A-Za-z0-9_]+)" \
  . \
  --glob '!CODEX_HANDOFF.md' \
  --glob '!README.md' \
  --glob '!zsh/.zshenv.example' \
  --glob '!npm/.npmrc.example' \
  --glob '!scripts/check-secrets.sh'; then
  echo "Potential secret-looking strings found."
  exit 1
fi

echo "No secret-looking strings found."
