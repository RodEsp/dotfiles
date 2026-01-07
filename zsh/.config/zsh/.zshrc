# Set PATH
export PATH="$PATH:/Users/rodesp/.local/bin:/Library/Developer/CommandLineTools/usr/bin"

export HISTSIZE=10000
export SAVEHIST=10000
setopt globdots # zsh completion for .files
setopt APPEND_HISTORY # Append history to the history file, don't overwrite it
setopt SHARE_HISTORY # Share history between sessions
setopt INC_APPEND_HISTORY # Append to history file as soon as command is ran (hit enter)
setopt HIST_IGNORE_DUPS # ignore running duplicate commands
setopt HIST_IGNORE_ALL_DUPS # remove history lines that are dups

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
# eval "$(starship init zsh)"
eval -- "$(PATH= /Users/rodesp/git/starship/target/debug/starship init zsh --print-full-init)"

# Enable zoxide
eval "$(zoxide init zsh)"

# Enable fnm
eval "$(fnm env --shell zsh)"

# Completions
fpath+=($ZDOTDIR/completions)

rustup completions zsh > $ZDOTDIR/completions/_rustup
rustup completions zsh cargo > $ZDOTDIR/completions/_cargo
 
autoload -Uz compinit
compinit

# eval "$(uv generate-shell-completion zsh)"

# Enable shift+arrow-key selection in terminal
source ~/git/zsh-shift-select/zsh-shift-select.plugin.zsh
eval "$(mise activate zsh)"

#compdef opencode
###-begin-opencode-completions-###
#
# yargs command completion script
#
# Installation: opencode completion >> ~/.zshrc
#    or opencode completion >> ~/.zprofile on OSX.
#
_opencode_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" opencode --get-yargs-completions "${words[@]}"))
  IFS=$si
  if [[ ${#reply} -gt 0 ]]; then
    _describe 'values' reply
  else
    _default
  fi
}
if [[ "'${zsh_eval_context[-1]}" == "loadautofunc" ]]; then
  _opencode_yargs_completions "$@"
else
  compdef _opencode_yargs_completions opencode
fi
###-end-opencode-completions-###

