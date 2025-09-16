# Set PATH
export PATH="$PATH:/Users/rodesp/git/gwctl/bin:/Users/rodesp/git/cloud/target/release:/Users/rodesp/.local/bin:/Library/Developer/CommandLineTools/usr/bin"

# zsh completion for .files
setopt globdots

# ENV VARS
source ~/.env

# ALIASES
alias bbic="brew update &&\
    brew bundle install --cleanup --file=~/dotfiles/Brewfile &&\
    brew upgrade"
alias bat='bat --paging=never'
alias cd='z'
alias cdi='zi'
alias cr='cargo run -q --'
alias cx='cargo xtask'
alias ff='fastfetch'
alias grep="rg --colors='match:fg:yellow'"
alias j="jctl"
alias k='kubectl'
alias l='eza --icons --hyperlink --sort=type -la'
alias ll='eza --icons --hyperlink --sort=type -lahgo --git'
alias ls='eza --icons --sort=type -l'
alias psql_log="cd /opt/homebrew/var/postgresql@17/pg_log"

# ALIAS FUNCTIONS
function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
                builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
}

highlight() {
    local HIGHLIGHT=$1
    shift  # remove the highlight term from $@

    # Print file contents, with grep injecting color around matches
    rg --colors='match:fg:yellow' "$HIGHLIGHT|$" "$@"
}

# Enable brew - has to be first, before other brew installed packages
eval "$(/opt/homebrew/bin/brew shellenv)"

# Enable starship prompt
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

# Enable zoxide
eval "$(zoxide init zsh)"

# Enable fnm
eval "$(fnm env --shell zsh)"

# added by orbstack: command-line tools and integration
# this won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Completions
fpath+=($ZDOTDIR/completions)

rustup completions zsh > $ZDOTDIR/completions/_rustup
rustup completions zsh cargo > $ZDOTDIR/completions//_cargo
 
autoload -Uz compinit
compinit

source <(kubectl completion zsh)
source <(gwctl completion zsh)
source <(k3d completion zsh)
source <(jctl autocomplete zsh)
eval "$(uv generate-shell-completion zsh)"

# Print important TODOs
todui ls --format json-pretty | jq '.[] | select(.group=="important") | .name' | tr -d '"'

# Enable shift+arrow-key selection in terminal
source ~/git/zsh-shift-select/zsh-shift-select.plugin.zsh
