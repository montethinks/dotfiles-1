# Codex Handoff

Goal: recreate Monte's terminal/editor/dev preferences on a new machine without copying secrets.

Initial decisions:

- Use zsh as the interactive shell.
- Keep oh-my-zsh for the first transfer.
- Install `zsh-git-prompt`; this is what produces the current screenshot-style git prompt.
- Preserve tmux + Ghostty + Neovim behavior.
- Preserve legacy Solarized/Railscasts terminal profiles and Powerline fonts from `assets/`.
- Use `~/.config/nvim/init.lua` as canonical Neovim config.
- Exclude `~/.zshenv`, `~/.npmrc`, `~/.config/gh/hosts.yml`, and all auth/session/cache directories.
- Install `fd`, `bat`, `fzf`, `eza`, `zoxide`, `delta`, `yq`, `gh`, `lazygit`, `tmux`, and `neovim`.

After install, ask Monte:

1. Confirm zsh is the default shell; if not, decide whether to run `chsh -s /bin/zsh`.
2. Keep oh-my-zsh, migrate to plain zsh + `zsh-git-prompt`, or try `starship`?
3. Prefer HTTPS or SSH for `gh` and git remotes?
4. Use work email, personal email, or per-directory git identities?
5. Install AI CLIs: Codex, opencode, Claude, Kiro, Antigravity?
6. Enable Copilot in Neovim by default?
7. Which language servers should be installed globally: TypeScript, Lua, Ruby, Go?
8. Should `dev-session.sh` launch `claude-code`, `codex`, `opencode`, or ask each time?

Known source-machine notes:

- `gh` is installed and configured with `co: pr checkout`.
- `~/.config/gh/config.yml` is safe to copy; `hosts.yml` is auth state and must stay out.
- `~/.zshenv` and `~/.npmrc` contained tokens and were replaced with examples.
- The current Neovim config uses lazy.nvim and plugins pinned in `lazy-lock.json`.
- The tmux config is tuned for `tmux-256color`, Ghostty truecolor, macOS `pbcopy`, mouse support, and Alt-hjkl pane navigation.
- The current prompt is set in `zsh/.zshrc` as `PROMPT='%B%m%~%b$(git_super_status) %# '`, after sourcing `~/zsh-git-prompt/zshrc.sh`.
- A historical laptop setup script exists at `/Users/monte.williams/studio/laptop-setup/monte-build.sh`; use `docs/laptop-setup-review.md` before reusing anything from it.
- For fastest setup on a new Mac, start with `./scripts/bootstrap-macos.sh`, then follow `docs/visual-terminal-setup.md`.
