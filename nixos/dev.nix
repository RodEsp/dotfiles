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
  master = import (builtins.fetchTarball "https://github.com/nixos/nixpkgs/tarball/master") {
    config = {
      allowUnfree = true;
    };
  };
in {
  # ===== Docker =====
  virtualisation.docker.enable = true;

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
    gcc # c compiler
    fnm # nodejs version manager
    git
    gnumake
    jq
    kubectl
    lens
    python312
    rustup

    # LSPs formatters
    alejandra # nix language formatter
    biome # toolchain for web dev
    hyprls # hypr config language lsp
    nil # nix lsp
    nixfmt-rfc-style # official formatter for Nix code
    python312Packages.python-lsp-ruff
    python312Packages.python-lsp-server
    ruff # python linter & formatter
    taplo # TOML toolkit (formatter)
    typescript-language-server
    vscode-langservers-extracted

    # nixos-unstable branch
    unstable.code-cursor
    unstable.gitui
    unstable.k3d
    unstable.k3s
    unstable.smartgithg
    unstable.zig
    unstable.zls

    # master branch
  ];

  # ===== System Env Vars =====

  # environment.variables = {};
}
