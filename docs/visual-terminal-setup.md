# Visual Terminal Setup

This repo preserves the terminal look from the older dotfiles repo.

## Assets

- `assets/Solarized Dark.terminal`
- `assets/Solarized Light.terminal`
- `assets/railscasts.terminal`
- `assets/solarized-dark.itermcolors`
- `assets/fonts/*Powerline*`
- `assets/ios-linen-texture.jpg`

## Fast Setup

1. Install the apps/tools with `./scripts/bootstrap-macos.sh`.
2. Install the fonts in `assets/fonts/`.
3. Import one of the terminal color profiles:
   - Apple Terminal: open a `.terminal` file from `assets/`.
   - iTerm2: import `assets/solarized-dark.itermcolors`.
4. Set the terminal font to a Powerline font, such as `Menlo for Powerline` or `DejaVu Sans Mono for Powerline`.
5. Open a new shell and confirm that `zsh-git-prompt` renders git status cleanly.
6. Start tmux and confirm truecolor with Neovim.

## Current Preference

The current setup keeps oh-my-zsh for the first transfer and uses `zsh-git-prompt` for the git display. Longer term, decide whether to keep that or switch to Starship.

## Ghostty

The `Brewfile` installs Ghostty because the current tmux config is tuned for it. This repo does not yet include a managed Ghostty config because the final visual preferences should be confirmed on the new machine after fonts and profiles are available.
