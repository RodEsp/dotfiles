# PATH
export PATH="$PATH"

# ENV VARS
source ~/.env

# ALIASES
alias bat='bat --paging=never'
alias cdi='zi'
alias cd='z'
alias edit-bashP='hx ~/.bash_profile'
alias ff='fastfetch'
alias ft='framework_tool'
alias grep="rg --colors='match:fg:yellow'"
alias k="kubectl"
alias l='eza --icons --hyperlink --sort=type -la'
alias list-generations="nixos-rebuild list-generations"
alias ll='eza --icons --hyperlink --sort=type -lahgo --git'
alias ls='eza --icons --sort=type -l'
alias nixRS='/home/rodesp/dotfiles/nixos/nixos-rebuild.sh'
alias nvoff='/home/rodesp/dotfiles/nixos/nvidia-offload'

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

# Enable starship prompt
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init bash)"

# Enable fnm
if [ -z "${IN_NIX_SHELL:-}" ]; then
	eval "$(fnm env --shell bash)"
fi

# Enable zoxide
eval "$(zoxide init bash)"

# Auto completion
source <(kubectl completion bash)
complete -o default -F __start_kubectl k
