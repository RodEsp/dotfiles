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
    cruise # docker TUI
    fnm # nodejs version manager
    gcc # c compiler
    git
    gnumake
    go
    jq
    kubectl
    lens # k8s IDE/GUI
    protobuf
    python312
    rustup

    # LSPs formatters
    alejandra # nix language formatter
    docker-language-server
    hyprls # hypr config language lsp
    nil # nix lsp
    nixfmt-rfc-style # official formatter for Nix code
    python312Packages.python-lsp-ruff
    python312Packages.python-lsp-server
    ruff # python linter & formatter
    taplo # TOML toolkit (formatter)
    # typescript-language-server
    vscode-langservers-extracted

    # nixos-unstable branch
    unstable.biome # toolchain for web dev and JS ecosystem LSP
    unstable.gitui
    unstable.k3d
    unstable.k3s
    unstable.jjui # tui for jujutsu
    unstable.jujutsu # version control CLI
    unstable.shellcheck # shellscript/bash linter
    unstable.shfmt # shellscript/bash formatter
    unstable.smartgit
    unstable.zig
    unstable.zls

    # custom
    (callPackage ./cursor/default.nix {})
  ];

  # ===== System Env Vars =====

  # environment.variables = {};
}
