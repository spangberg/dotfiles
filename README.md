# dotfiles

Personal macOS setup: Homebrew packages, zsh, git, VSCode, and Claude Code configuration.

## Setup on a new machine

```sh
git clone <repo-url> ~/Developer/dotfiles
cd ~/Developer/dotfiles
./install.sh
```

The script installs Homebrew, everything in the `Brewfile` (formulae, casks, and VSCode extensions), uv, volta, and Claude Code.
It then symlinks the config files below into place.
It is safe to re-run.
Any pre-existing config files are backed up to `~/.dotfiles-backup/` before being replaced.

## Contents

| Path | Linked to |
| --- | --- |
| `zsh/.zshrc` | `~/.zshrc` |
| `zsh/.zshenv` | `~/.zshenv` |
| `zsh/.zprofile` | `~/.zprofile` |
| `zsh/.p10k.zsh` | `~/.p10k.zsh` |
| `git/.gitconfig` | `~/.gitconfig` |
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` |
| `claude/settings.json` | `~/.claude/settings.json` |
| `vscode/settings.json` | `~/Library/Application Support/Code/User/settings.json` |

## Keeping things up to date

Because the live files are symlinks into this repo, edits made anywhere (for example via `p10k configure` or VSCode's settings UI) land in the repo automatically.
Review and commit them from here.

To refresh the `Brewfile` after installing or removing packages:

```sh
brew bundle dump --force --file=Brewfile --formulae --casks --taps --vscode
```
