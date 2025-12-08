# PATH
export PATH="$PATH"

# ENV VARS
source ~/.env

# ALIASES
alias bat='bat --paging=never'
alias cdi='zi'
alias ff='fastfetch'
alias ft='framework_tool'
alias k="kubectl"
alias l='eza --icons --hyperlink --sort=type -la'
alias list-generations="nixos-rebuild list-generations"
alias nixRS='/home/rodesp/dotfiles/nixos/nixos-rebuild.sh'

# ALIAS FUNCTIONS
function nix-shell-unstable() {
  nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz "$@"
}
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

# Only run this stuff in interactive shells
case $- in
  *i*) # Interactive shell 
    alias cd='z'
    alias grep="rg -i --colors='match:fg:yellow'"
		alias ll='eza --icons --hyperlink --sort=type -lahgo --git'
		alias ls='eza --icons --sort=type -l'

		# Enable zoxide
		eval "$(zoxide init bash)"
    ;;
  *)
  	echo "Non interactive mode" 
    ;;
esac

# Auto completion
source <(kubectl completion bash)
complete -o default -F __start_kubectl k

# uv
export PATH="/home/rodesp/.config/../bin:$PATH"
