# Monte's Dotfiles

Portable terminal, editor, tmux, git, and GitHub CLI preferences.

This repo intentionally excludes secrets and machine-local state. Do not copy `~/.zshenv`, `~/.npmrc`, `~/.ssh`, `~/.aws/credentials`, `~/.gnupg` private keys, `~/.config/gh/hosts.yml`, or app auth/session directories into this repo.

## What Is Included

- zsh and bash startup files
- Neovim config and `lazy-lock.json`
- Vim fallback config
- tmux config tuned for Ghostty, Neovim, mouse support, vi copy mode, and macOS clipboard
- git defaults and aliases
- GitHub CLI non-auth preferences
- `dev-session.sh` tmux launcher
- `Brewfile` for core tools and preferred CLI utilities

## Install

```sh
./install.sh
brew bundle --file Brewfile
```

Then install or restore the pieces that are intentionally not committed:

- oh-my-zsh, if keeping the current shell baseline
- `~/zsh-git-prompt`, used for the current git prompt
- local secrets in `~/.zshenv`
- local npm/GitHub Packages auth in `~/.npmrc`
- `gh auth login`
- app auth for Codex, Copilot, opencode, Kiro, AWS, and similar tools

## Current Shell Direction

Keep oh-my-zsh for the first machine transfer because the current `.zshrc` expects it and uses `robbyrussell`. Longer term, this can move to plain zsh plus `zsh-git-prompt`, or to `starship` if a richer cross-machine prompt feels better.

## Preferred CLI Tools

The `Brewfile` includes current tools and adds preferred utilities:

`fd`, `bat`, `fzf`, `eza`, `zoxide`, `delta`, `yq`, `rg`, `jq`, `tree`, `gh`, `lazygit`, `tmux`, `neovim`, `nvm`, `bun`, `pyenv`, `awscli`, `sops`, and `terraform`.
