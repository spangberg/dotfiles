# ======================================================================================================================
# ~/.zshrc - interactive shell configuration
#
# Environment/PATH setup (brew shellenv, EDITOR, etc.) belongs in ~/.zprofile,
# which runs once at login before this file
# ======================================================================================================================


# Powerlevel10k instant prompt — must be first, before any output
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# ----------------------------------------------------------------------------------------------------------------------
# History
# ----------------------------------------------------------------------------------------------------------------------
HISTFILE=~/.zsh_history                                 # Explicitly declare where history is saved
HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY                                   # Append to history file instead of overwriting
setopt SHARE_HISTORY                                    # Share history across all sessions
setopt HIST_IGNORE_DUPS                                 # Ignore duplicate commands in history
setopt HIST_IGNORE_SPACE                                # Ignore commands that start with a space
setopt HIST_SAVE_NO_DUPS                                # Don't save duplicate commands in history
setopt HIST_REDUCE_BLANKS                               # Remove extra blanks from commands in history


# ----------------------------------------------------------------------------------------------------------------------
# Completion
# ----------------------------------------------------------------------------------------------------------------------
zmodload zsh/complist                                   # Required for menuselect keymap (arrow keys in menu)
autoload -Uz compinit                                   # Load completion system

# compinit normally does a security check on its cache dump every startup, which add latency.
# Here we rebuild the dump only if it's older than 24h (the (#qN.mh+24) glob qualifier means 
# "match files older than 24h"); otherwise we trust the cache with -C for a faster launch.
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zstyle ':completion:*' menu select                      # Use arrow keys to select completion options
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # case-insensitive matching
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=0\;33  # colorize matches + yellow selection highlight
zstyle ':completion:*' group-name ''                    # group results by category
zstyle ':completion:*' special-dirs true                # show . and .. in completion menu
zstyle ':completion:*' squeeze-slashes false            # allow /*/ glob expansion in paths


# ----------------------------------------------------------------------------------------------------------------------
# Navigation
# ----------------------------------------------------------------------------------------------------------------------
setopt AUTO_CD                                          # Change to a directory by typing its name
setopt AUTO_PUSHD                                       # Push old directory onto stack on cd
setopt PUSHD_IGNORE_DUPS                                # Don't push duplicate directories onto stack
setopt AUTO_PARAM_SLASH                                 # Add trailing slash to directory names in completion


# ----------------------------------------------------------------------------------------------------------------------
# Completion
# ----------------------------------------------------------------------------------------------------------------------
setopt AUTO_MENU                                        # Show completion menu automatically
setopt NO_CASE_GLOB                                     # Case-insensitive globbing
setopt NO_CASE_MATCH                                    # Case-insensitive matching
setopt GLOB_DOTS                                        # Include dotfiles in globbing
setopt EXTENDED_GLOB                                    # Enable extended globbing (e.g., ^foo, foo*(bar|baz), etc.)


# ----------------------------------------------------------------------------------------------------------------------
# Shell Behavior
# ----------------------------------------------------------------------------------------------------------------------
setopt INTERACTIVE_COMMENTS                             # Allow comments in interactive shell
unsetopt PROMPT_SP                                      # Don't auto-erase partial lines before prompt
[[ -t 0 ]] && stty stop undef                           # Disable ^S/^Q flow control


# ----------------------------------------------------------------------------------------------------------------------
# Modern Tool Replacement Aliases
# ----------------------------------------------------------------------------------------------------------------------
# bat → cat
alias cat='bat'
alias catp='bat --style=plain'                          # plain output, no decorations
alias cath='bat --style=plain --pager=never'            # no paging (good for piping)
 
# ripgrep → grep
alias grep='rg'                                         # muscle memory redirect
alias rgi='rg -i'                                       # case-insensitive
alias rgh='rg --hidden'                                 # include hidden files
 
# fd → find
alias find='fd'                                         # muscle memory redirect (note: fd flags differ from find)
alias fda='fd -H'                                       # include hidden files
alias fdl='fd -l'                                       # long listing format
 
# eza → ls
alias ls='eza --group-directories-first'
alias ll='eza -lh --group-directories-first --git'      # long list with git status
alias la='eza -lah --group-directories-first --git'     # include hidden files
alias lt='eza --tree --level=2'                         # tree view
 
# fzf
alias preview='fzf --preview "bat --color=always {}"'   # fuzzy file finder with bat preview
alias rgf='rg --color=always -l "" | fzf --ansi --preview "rg --color=always {q} {}"'  # interactive rg+fzf search
 
# jq / yq
alias jqp='jq --color-output . | bat --language=json --style=plain'    # pretty-print JSON with bat
alias yqp='yq . | bat --language=yaml --style=plain'                   # pretty-print YAML with bat


# ----------------------------------------------------------------------------------------------------------------------
# Navigation Aliases
# ----------------------------------------------------------------------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'                                       # return to previous directory
alias ~='cd ~'


# ----------------------------------------------------------------------------------------------------------------------
# Git Aliases
# ----------------------------------------------------------------------------------------------------------------------
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit -m'
alias gca='git commit --amend --no-edit'                # amend without changing message
alias gp='git push'
alias gpf='git push --force-with-lease'                 # safer than --force
alias gl='git pull'
alias glo='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias gds='git diff --staged'
alias gco='git checkout'
alias gsw='git switch'
alias gbr='git branch'
alias gst='git stash'
alias gstp='git stash pop'
alias lg='lazygit'                                      # open lazygit TUI


# ----------------------------------------------------------------------------------------------------------------------
# GitHub CLI (gh) Aliases
# ----------------------------------------------------------------------------------------------------------------------
alias ghpr='gh pr create'                               # open a PR from current branch
alias ghprl='gh pr list'                                # list open PRs
alias ghprv='gh pr view --web'                          # open current PR in browser
alias ghprc='gh pr checkout'                            # check out a PR by number
alias ghprf='gh pr list | fzf | awk "{print \$1}" | xargs gh pr checkout'  # fuzzy pick + checkout a PR
alias ghis='gh issue list'                              # list issues
alias ghic='gh issue create'                            # create an issue
alias ghrv='gh repo view --web'                         # open current repo in browser
alias ghrc='gh repo clone'                              # clone a repo (gh repo clone owner/repo)
alias ghrun='gh run list'                               # list recent CI runs
alias ghrunw='gh run watch'                             # watch a CI run live in terminal


# ----------------------------------------------------------------------------------------------------------------------
# GitHub CLI (gh) Aliases
# ----------------------------------------------------------------------------------------------------------------------
alias rm='rm -i'                                        # prompt before delete
alias cp='cp -i'                                        # prompt before overwrite
alias mv='mv -i'                                        # prompt before overwrite
alias mkdir='mkdir -pv'                                 # create parents automatically, verbose


# ----------------------------------------------------------------------------------------------------------------------
# Utility Aliases
# ----------------------------------------------------------------------------------------------------------------------
alias df='df -h'                                        # human-readable disk usage
alias du='du -h'                                        # human-readable file sizes
alias dud='du -d1 -h'                                   # sizes of immediate subdirectories only
 
alias path='echo $PATH | tr ":" "\n"'                   # print PATH one entry per line
alias reload='source ~/.zshrc'                          # reload config without restarting shell
alias zshrc='code ~/.zshrc'                             # quick edit your config


# ----------------------------------------------------------------------------------------------------------------------
# Networking Aliases
# ----------------------------------------------------------------------------------------------------------------------
alias myip='curl -s https://ifconfig.me'                # public IP
alias localip='ipconfig getifaddr en0'                  # local IP (macOS; use hostname -I on Linux)
alias ping='ping -c 5'                                  # stop after 5 packets by default
alias ports='lsof -i -P -n | grep LISTEN'               # show open ports


# ----------------------------------------------------------------------------------------------------------------------
# uv and Volta Aliases
# ----------------------------------------------------------------------------------------------------------------------
# uv
alias uvr='uv run'                                      # uv run python / uv run pytest etc.
alias uva='uv add'                                      # add a dependency
alias uvad='uv add --dev'                               # add a dev dependency
alias uvs='uv sync'                                     # sync environment from lockfile
alias uvl='uv lock --upgrade'                           # upgrade lockfile
alias uvt='uv tool install'                             # install a global tool
alias uvp='uv python'                                   # uv python install / list / pin

# Volta
alias vl='volta list'                                   # see installed versions
alias vi='volta install'                                # install a node tool/version
alias vp='volta pin'                                    # pin version to current project


# ----------------------------------------------------------------------------------------------------------------------
# Powerlevel10k
# ----------------------------------------------------------------------------------------------------------------------
source "$(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme"

# Load p10k config generated by the setup wizard (run 'p10k configure' to re-run)
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh


# ----------------------------------------------------------------------------------------------------------------------
# Plugins — order matters, syntax-highlighting must be last
# ----------------------------------------------------------------------------------------------------------------------

# Autosuggestions — grey ghost text from history as you type, → to accept
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)  # history first, completion as fallback
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20             # skip suggestions for very long commands
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'       # dim grey to distinguish from typed text

# fzf — key bindings (^R, ^T, alt-C) and fuzzy completion
source <(fzf --zsh)

# zoxide — smarter cd with frecency tracking
eval "$(zoxide init zsh)"

# uv - PATH setup; guarded so shells still work on a machine where uv is not installed yet
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# Syntax highlighting — must be sourced last
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
