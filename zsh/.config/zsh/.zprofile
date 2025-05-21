# PATH
export PATH="$PATH"

# ALIASES
alias l='eza --icons --hyperlink --sort=type -la'
alias ls='eza --icons --sort=type'
alias ll='eza --icons --hyperlink --sort=type -lahgo --git'
alias cd='z'
alias cdi='zi'
alias ff='fastfetch'
alias ct='cargo xtask'
alias bbic="brew update &&\
    brew bundle install --cleanup --file=~/dotfiles/Brewfile &&\
    brew upgrade"

# ALIAS FUNCTIONS
function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
                builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
}

# Enable brew - has to be first, before other brew installed packages
eval "$(/opt/homebrew/bin/brew shellenv)"

# Enable starship (but not in warp)
if [[ "$TERM" == *kitty* || "$TERM" == *ghostty* ]]; then
        eval "$(starship init bash)"
fi

# Enable zoxide
eval "$(zoxide init bash)"

# Enable fnm
eval "$(fnm env --shell bash)"

