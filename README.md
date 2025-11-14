# dotfiles

Any folders containing a `./config` subfolder are managed with [`stow`](https://www.gnu.org/software/stow/manual/stow.html) ([guide](https://gist.github.com/andreibosco/cb8506780d0942a712fc)).
They are added this way so that you can individually choose which packages' configuration to symlink using `stow <pkg>` from the root of this repo.

The `nixos/` folder contains my NixOS configuration, save for the `/etc/nixos/configuration.nix` and `/etc/nixos/hardware-configuration.nix` files.

My `/etc/nixos/configuration.nix` file:
```nix
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  options,
  ...
}: let
  hostname = "rodesp-fw13";
in {
  networking.hostName = hostname;

  imports = [
    /etc/nixos/hardware-configuration.nix
    (/home/rodesp/dotfiles/nixos + "/${hostname}.nix")
  ];
}
```

To modify and rebuild NixOS I use the [`nixos/nixos-rebuild.sh`](./nixos/nixos-rebuild.sh) script.

## Licensing

All files, configuration, and source code in this repo are licensed under [LICENSE](/LICENSE) unless otherwise specified within the file itself.
