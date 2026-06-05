# Laptop Setup Script Review

Source script on the current machine:

`/Users/monte.williams/studio/laptop-setup/monte-build.sh`

Companion docs:

- `/Users/monte.williams/studio/laptop-setup/build-script-usage.md`
- `/Users/monte.williams/studio/laptop-setup/script-diff.md`

## Usefulness

The script is useful as historical source material for what this machine needed: Homebrew, Xcode command line tools, AWS/SOPS/Terraform/Leapp, git defaults, nvm, VS Code, VS Code extensions, `zsh-git-prompt`, and macOS SSH keychain behavior.

Do not run it as-is for this dotfiles setup. Prefer this repo's `Brewfile` and `install.sh`, then handle auth and preference questions explicitly.

## Good Ideas To Keep

- Check for Xcode command line tools early.
- Install Homebrew if missing.
- Use Homebrew for repeatable package/app installs.
- Set git basics: name, email, editor, pager, pull behavior, aliases, rerere.
- Install `zsh-git-prompt`.
- Configure macOS SSH agent keychain persistence after the user has keys.
- Install useful VS Code extensions if VS Code remains part of the workflow.

## Do Not Copy Blindly

- `sudo spctl --master-disable`; disabling Gatekeeper should be an explicit manual choice.
- Directly appending snippets to `~/.zshrc` and `~/.zprofile`; this dotfiles repo symlinks managed files instead.
- Sourcing `~/.zshrc` from `~/.zprofile`; the repo version intentionally removed this.
- Installing Node `v20.14`; this source machine currently uses Node `v22.15.0`.
- Running `brew update` unconditionally in automation; it can be slow/noisy and may fail under restricted environments.
- App installs that may be work-specific: MongoDB Compass, Notion, Postman, Leapp.
- Writing SSH config before confirming desired SSH/GitHub auth approach.

## Possible Future Additions

- Add an optional `scripts/bootstrap-macos.sh` that installs Homebrew, runs `brew bundle`, installs oh-my-zsh, and prints manual auth steps.
- Add a `vscode/extensions.txt` plus an installer loop.
- Add a `git/personal.gitconfig` and `git/work.gitconfig` split if Monte wants per-directory identities.
- Add an interactive prompt for the agent pane command in `bin/dev-session.sh`.
