#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

has() {
  command -v "$1" >/dev/null 2>&1
}

section() {
  printf '\n==> %s\n' "$1"
}

if [ "$(uname -s)" != "Darwin" ]; then
  echo "This bootstrap is intended for macOS."
  exit 1
fi

section "Checking Xcode command line tools"
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
  echo "Finish the Xcode command line tools installer, then rerun this script."
  exit 0
fi

section "Checking Homebrew"
if ! has brew; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

section "Installing Homebrew tools"
brew bundle --file "$ROOT/Brewfile"

section "Linking dotfiles"
"$ROOT/install.sh"

section "Installing oh-my-zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "oh-my-zsh already exists."
fi

section "Installing zsh-git-prompt"
if [ ! -d "$HOME/zsh-git-prompt" ]; then
  git clone https://github.com/zsh-git-prompt/zsh-git-prompt.git "$HOME/zsh-git-prompt"
else
  echo "zsh-git-prompt already exists."
fi

section "Setting up Node"
mkdir -p "$HOME/.nvm"
export NVM_DIR="$HOME/.nvm"
if [ -s "$(brew --prefix nvm)/nvm.sh" ]; then
  . "$(brew --prefix nvm)/nvm.sh"
  nvm install 22.15.0
  nvm alias default 22.15.0
  nvm use default
  corepack enable || true
else
  echo "nvm was not found after brew bundle; skipping Node install."
fi

section "Setting up Bun"
if ! has bun; then
  curl -fsSL https://bun.sh/install | bash
else
  echo "bun already exists."
fi

section "Done"
cat <<'NEXT'
Manual next steps:
  1. Import terminal profile/style assets from assets/.
  2. Run: gh auth login
  3. Restore SSH keys or create a new key, then add it to GitHub.
  4. Create ~/.zshenv and ~/.npmrc locally from the example files if needed.
  5. Open nvim once so lazy.nvim installs plugins.
  6. Review CODEX_HANDOFF.md with Codex for remaining preferences.
NEXT
