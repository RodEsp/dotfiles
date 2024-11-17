#!/usr/bin/env bash

# A rebuild script that commits on a successful build
set -e

# Edit your config
hx ~/dotfiles/nixos/rodesp-fw13.nix # TODO: Use $EDITOR instead of hx

# cd to your config dir
pushd ~/dotfiles/nixos/

# Early return if no changes were detected (thanks @singiamtel!)
if git diff --quiet '*.nix'; then
    echo "No changes detected, exiting."
    popd
    exit 0
fi

# Autoformat your nix files
alejandra . &>/dev/null \
  || ( alejandra . ; echo "formatting failed!" && exit 1)

# Shows your changes
git diff -U0 '*.nix'

echo "Do you wish to rebuilt NixOS with these changes?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) exit;;
    esac
done

# Rebuild, output simplified errors, log trackebacks
sudo nixos-rebuild switch 2>&1 | tee nixos-switch.log
# (cat nixos-switch.log | grep --color error && exit 1)

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep current)

# Commit all changes witih the generation metadata
echo ""
echo "Don't forget to commit your current generation!"
echo ""
echo "$current"

# Back to where you were
popd

# Notify all OK!
notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
