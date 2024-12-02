# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  lib,
  pkgs,
  ...
}: let
  unstable =
    import (builtins.fetchTarball "https://github.com/nixos/nixpkgs/tarball/nixos-unstable")
    {
      config = {
        allowUnfree = true;
      };
    };
  master =
    import (builtins.fetchTarball "https://github.com/nixos/nixpkgs/tarball/master")
    {
      config = {
        allowUnfree = true;
      };
    };
in {
  # ===== System Services =====

  # services = {};

  # ===== System Programs =====

  programs = {
    git = {
      enable = true;
      config = {
        user = {
          name = "RodEsp";
          email = "1084688+RodEsp@users.noreply.github.com";
        };
        init.defaultbranch = "main";
        commit.gpgsign = true;
      };
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # ===== System packages =====

  nixpkgs.config.allowUnfree = true; # Allow unfree packages

  environment.systemPackages = with pkgs; [
    git
    gitui
    jq
    nil # nix language server
    nixfmt-rfc-style # official formatter for Nix code
    python312
    python312Packages.python-lsp-server
    python312Packages.python-lsp-ruff
    ruff
    smartgithg

    # nixos-unstable branch
    unstable.zed-editor

    # master branch
  ];

  # ===== System Env Vars =====

  # environment.variables = {};
}
