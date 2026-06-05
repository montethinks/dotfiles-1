#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

backup_path() {
  local target="$1"
  if [ -e "$target" ] || [ -L "$target" ]; then
    local backup="${target}.backup.$(date +%Y%m%d%H%M%S)"
    echo "Backing up $target -> $backup"
    mv "$target" "$backup"
  fi
}

link_file() {
  local source="$1"
  local target="$2"
  mkdir -p "$(dirname "$target")"
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    echo "Already linked: $target"
    return
  fi
  backup_path "$target"
  ln -s "$source" "$target"
  echo "Linked $target"
}

echo "Linking dotfiles from $ROOT"

link_file "$ROOT/zsh/.zshrc" "$HOME/.zshrc"
link_file "$ROOT/zsh/.zprofile" "$HOME/.zprofile"
link_file "$ROOT/zsh/.bashrc" "$HOME/.bashrc"
link_file "$ROOT/zsh/.profile" "$HOME/.profile"
link_file "$ROOT/nvim/.config/nvim/init.lua" "$HOME/.config/nvim/init.lua"
link_file "$ROOT/nvim/.config/nvim/lazy-lock.json" "$HOME/.config/nvim/lazy-lock.json"
link_file "$ROOT/vim/.vimrc" "$HOME/.vimrc"
link_file "$ROOT/tmux/.tmux.conf" "$HOME/.tmux.conf"
link_file "$ROOT/git/.gitconfig" "$HOME/.gitconfig"
link_file "$ROOT/git/.config/git/ignore" "$HOME/.config/git/ignore"
link_file "$ROOT/gh/.config/gh/config.yml" "$HOME/.config/gh/config.yml"
link_file "$ROOT/bin/dev-session.sh" "$HOME/bin/dev-session.sh"

chmod +x "$ROOT/bin/dev-session.sh"

cat <<'NEXT'

Next:
  1. Run: brew bundle --file Brewfile
  2. Install oh-my-zsh if you want to preserve the current prompt baseline.
  3. Install or clone zsh-git-prompt to ~/zsh-git-prompt for the git prompt.
  4. Create ~/.zshenv and ~/.npmrc locally from the example files if needed.
  5. Run nvim once so lazy.nvim can install plugins.

Preference questions for the next Codex are in CODEX_HANDOFF.md.
NEXT
