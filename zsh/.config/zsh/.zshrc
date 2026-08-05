# Set PATH
export PATH="$PATH:/Users/rodesp/.local/bin:/Library/Developer/CommandLineTools/usr/bin"

export HISTSIZE=10000
export SAVEHIST=10000
setopt globdots             # zsh completion for .files
setopt APPEND_HISTORY       # Append history to the history file, don't overwrite it
setopt SHARE_HISTORY        # Share history between sessions
setopt INC_APPEND_HISTORY   # Append to history file as soon as command is ran (hit enter)
setopt HIST_IGNORE_DUPS     # ignore running duplicate commands
setopt HIST_IGNORE_ALL_DUPS # remove history lines that are dups

# ENV VARS
# shellcheck disable=SC1090
source ~/.env

# ALIASES
alias bbic="brew update &&\
    brew bundle install --file=~/dotfiles/Brewfile &&\
    brew upgrade"
alias bat='bat --paging=never'
alias cd='z'
alias cdi='zi'
alias cr='cargo run -q --'
alias cx='cargo xtask'
alias derapi="restish derapi"
alias ff='fastfetch'
alias ghprs='gh search prs --state open "user-review-requested:@me"'
alias grep="rg --colors='match:fg:yellow'"
alias k='kubectl'
alias l='eza --icons --hyperlink --sort=type -la'
alias ll='eza --icons --hyperlink --sort=type -lahgo --git'
alias ls='eza --icons --sort=type -l'
alias path='echo "$PATH" | sed '\''s/:/\n/g'\'
alias p='pnpm'
alias px='pnpx'
alias tf='terraform'

# ALIAS FUNCTIONS
function y() {
        local tmp
        tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
                builtin cd -- "$cwd" || exit
        fi
        rm -f -- "$tmp"
}

highlight() {
  local HIGHLIGHT=$1
  shift # remove the highlight term from $@

  # Print file contents, with grep injecting color around matches
  rg --colors='match:fg:yellow' "$HIGHLIGHT|$" "$@"
}

tn() {
  local exit_code=$?
  local cmd=${__tn_last_cmd%%' && tn'}
  cmd=${cmd%%'; tn'}
  cmd=${cmd%%'| tn'}
  if [ $exit_code -eq 0 ]; then
    terminal-notifier -title "$cmd" -message "Succeeded" -activate "com.mitchellh.ghostty" -sound default
  else
    terminal-notifier -title "$cmd" -message "Failed (exit $exit_code)" -activate "com.mitchellh.ghostty" -sound default
  fi
}
preexec() {
  __tn_last_cmd=$1
}

# Quickly ask Opencode a question
function _o() {
  local cmd="opencode run \"$*\" -m opencode/deepseek-v4-flash-free"
  print -r -- "$cmd"
  eval "$cmd"
}
alias o='noglob _o'

# Enable brew - has to be first, before other brew installed packages
eval "$(/opt/homebrew/bin/brew shellenv)"

# Enable starship prompt
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

# Enable zoxide
eval "$(zoxide init zsh)"

# Enable fnm
eval "$(fnm env --shell zsh)"

# Enable fzf
# shellcheck disable=SC1090
source <(/opt/homebrew/bin/fzf --zsh)

###################
### Completions ###
###################
fpath+=("$ZDOTDIR/completions")

rustup completions zsh >"$ZDOTDIR/completions/_rustup"
rustup completions zsh cargo >"$ZDOTDIR/completions/_cargo"
xan completions zsh >"$ZDOTDIR/completions/_xan"

autoload bashcompinit && bashcompinit
autoload -Uz compinit
compinit

eval "$(uv generate-shell-completion zsh)"
# shellcheck disable=SC1090
source <(restish completion zsh)
compdef _restish restish
# shellcheck disable=SC1090
source <(COMPLETE=zsh jj)
complete -C '/opt/homebrew/bin/aws_completer' aws

_opencode_yargs_completions() {
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT - 1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" opencode --get-yargs-completions "${words[@]}"))
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

# Use FZF for tab completions
# shellcheck disable=SC1090
source ~/.config/zsh/fzf-zsh-completion.sh
bindkey '^I' fzf_completion

#######################
### END COMPLETIONS ###
#######################

# Enable shift+arrow-key selection in terminal
# shellcheck disable=SC1090
source ~/git/zsh-shift-select/zsh-shift-select.plugin.zsh

# AWS profile picker
pick-aws-profile() {
  AWS_PROFILE="$(grep profile "$HOME/.aws/config" | cut -d' ' -f2 | sed 's/\]//g' | fzf)"
  export AWS_PROFILE
}

# Automatically activate/deactivate mise when changing directories
_mise_local_autoload() {
  # Check if a mise configuration file exists in the current dir or any ancestor
  local dir="$PWD"
  local found=0
  while true; do
    if [[ -f "$dir/.mise.toml" || -f "$dir/mise.toml" || -f "$dir/.tool-versions" ]]; then
      found=1
      break
    fi
    [[ "$dir" == "/" ]] && break
    dir="${dir:h}"
  done
  if [[ "$found" -eq 1 ]]; then
    if [[ -z "$__MISE_ORIG_PATH" ]]; then
      export __MISE_ORIG_PATH="$PATH"
      # Dynamically load the project environment without affecting global tools
      echo "mise detected, enabling it"
      # eval "$(mise hook-env -s zsh)"
      # shellcheck disable=SC1090
      source <(mise activate zsh)
    fi
  elif [[ -n "$__MISE_ORIG_PATH" ]]; then
    echo "restoring PATH..."
    # Restore your original system PATH when leaving a mise project
    export PATH="$__MISE_ORIG_PATH"
    unset __MISE_ORIG_PATH
  fi
}
# Register the function to run on shell startup and every directory change
add-zsh-hook chpwd _mise_local_autoload
_mise_local_autoload
