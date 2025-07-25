# PATH
export PATH="$PATH"

# ENV VARS
source ~/.env

# ALIASES
alias l='eza --icons --hyperlink --sort=type -la'
alias ls='eza --icons --sort=type -l'
alias ll='eza --icons --hyperlink --sort=type -lahgo --git'
alias cd='z'
alias cdi='zi'
alias nixRS='/home/rodesp/dotfiles/nixos/nixos-rebuild.sh'
alias list-generations="nixos-rebuild list-generations"
alias nvoff='/home/rodesp/dotfiles/nixos/nvidia-offload'
alias edit-bashP='hx ~/.bash_profile'
alias ff='fastfetch'
alias ft='framework_tool'

# ALIAS FUNCTIONS
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Enable starship (but not in warp)
if [[ "$TERM" == *kitty* || "$TERM" == *ghostty* ]]; then
	eval "$(starship init bash)"
fi

# Enable fnm
eval "$(fnm env --shell bash)"

# Enable zoxide
eval "$(zoxide init bash)"
