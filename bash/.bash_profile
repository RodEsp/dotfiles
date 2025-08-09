# PATH
export PATH="$PATH"

# ENV VARS
source ~/.env

# ALIASES
alias cdi='zi'
alias cd='z'
alias edit-bashP='hx ~/.bash_profile'
alias ff='fastfetch'
alias ft='framework_tool'
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

# Enable starship (but not in warp)
if [[ "$TERM" == *kitty* || "$TERM" == *ghostty* ]]; then
	export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
	eval "$(starship init bash)"
fi

# Enable fnm
eval "$(fnm env --shell bash)"

# Enable zoxide
eval "$(zoxide init bash)"
