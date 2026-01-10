# PATH
export PATH="$PATH"

# ENV VARS
source ~/.env

# HISTORY
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="l:ls:ll:clear"
export HISTTIMEFORMAT='%F %T - '
shopt -s histappend
export PROMPT_COMMAND="history -a; history -n"

# ALIASES
alias bat='bat --paging=never'
alias cdi='zi'
alias cr='cargo run -q --'
alias cx="cargo xtask"
alias ff='fastfetch'
alias ft='framework_tool'
alias k="kubectl"
alias l='eza --icons --hyperlink --sort=type -la'
alias list-generations="nixos-rebuild list-generations"
alias open="xdg-open"

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
    alias grep="rg -. -i --colors='match:fg:yellow'"
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

# fzf
eval "$(fzf --bash)"
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:-1,fg+:#d3c6aa,bg:-1,bg+:#262626
  --color=hl:#83c092,hl+:#83c092,info:#a7c080,marker:#83c092
  --color=prompt:#e67e80,spinner:#7fbbb3,pointer:#7fbbb3,header:#87afaf
  --color=border:#445055,label:#aeaeae,query:#d9d9d9
  --border="sharp" --border-label="" --preview-window="border-sharp" --padding="0,1"
  --margin="0,1" --prompt="> " --marker=">" --pointer="◆"
  --separator="─" --scrollbar="│" --layout="reverse" --info="right"'
