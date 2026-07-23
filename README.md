# dotfiles

Personal macOS setup: Homebrew packages, zsh, git, VSCode, and Claude Code configuration.

## Setup on a new machine

```sh
git clone <repo-url> ~/Developer/dotfiles
cd ~/Developer/dotfiles
./install.sh
```

The script installs Homebrew, everything in the `Brewfile` (formulae, casks, and VSCode extensions), uv, volta, and Claude Code.
It then copies the config files below into place.
It is safe to re-run.
Files that already match the repo are left alone, and differing files are backed up to `~/.dotfiles-backup/` before being overwritten.

## Contents

| Path | Installed to |
| --- | --- |
| `zsh/.zshrc` | `~/.zshrc` |
| `zsh/.zshenv` | `~/.zshenv` |
| `zsh/.zprofile` | `~/.zprofile` |
| `zsh/.p10k.zsh` | `~/.p10k.zsh` |
| `git/.gitconfig` | `~/.gitconfig` |
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` |
| `claude/settings.json` | `~/.claude/settings.json` |
| `vscode/settings.json` | `~/Library/Application Support/Code/User/settings.json` |

## Saving config changes to the repo

The live files are plain copies, so changes made on the machine are not tracked automatically.
When a change is worth keeping, copy the live files back into the repo and refresh the `Brewfile`:

```sh
cd ~/Developer/dotfiles
command cp ~/.zshrc ~/.zshenv ~/.zprofile ~/.p10k.zsh zsh/
command cp ~/.gitconfig git/
command cp ~/.claude/CLAUDE.md ~/.claude/settings.json claude/
command cp "$HOME/Library/Application Support/Code/User/settings.json" vscode/
brew bundle dump --force --file=Brewfile --formulae --casks --taps --vscode
```

`command cp` bypasses the interactive overwrite prompts that `.zshrc` configures for the plain `cp` alias.
Review with `git diff`, commit what you meant to change, and drop the rest with `git restore <file>`.

## Applying repo changes to a machine

After pulling changes made on another computer, re-run the install script:

```sh
./install.sh
```
