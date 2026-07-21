# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv zsh)"

export EDITOR='code --wait'
export VISUAL='code --wait'
export PAGER='bat --style=plain'        # use bat for paging (man pages etc.)
export MANPAGER='sh -c "col -bx | bat --language=man --style=plain"'  # bat-powered man pages