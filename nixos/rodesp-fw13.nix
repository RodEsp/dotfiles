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
in {
  imports = [
    ./main-user.nix
    ./steam.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  ## Framework Laptop Specifics
  services.fwupd.enable = true;
  # we need fwupd 1.9.7 to downgrade the fingerprint sensor firmware
  services.fwupd.package =
    (import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/bb2009ca185d97813e75736c2b8d1d8bb81bde05.tar.gz";
      sha256 = "sha256:003qcrsq5g5lggfrpq31gcvj82lb065xvr7bpfa8ddsw8x4dnysk";
    }) {inherit (pkgs) system;})
    .fwupd;
  ## End Framework Specifics

  ## AMD Specifics
  # AMD has better battery life with PPD over TLP:
  # https://community.frame.work/t/responded-amd-7040-sleep-states/38101/13
  services.power-profiles-daemon.enable = lib.mkDefault true;
  ## End AMD Specifics

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Desktop Environment
  services = {
    xserver = {
      enable = true;
      # desktopManager.gnome.enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };

  # Enable Hyprland/Desktop Environment
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;
  programs.waybar.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable main-user module.
  main-user.enable = true;
  main-user.userName = "rodesp";
  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.rodesp = {
  #   isNormalUser = true;
  #   description = "Rodrigo Espinosa de los Monteros";
  #   extraGroups = [
  #     "networkmanager"
  #     "wheel"
  #   ];
  #   packages = with pkgs; [
  #     #  thunderbird
  #   ];
  # };

  # Install firefox.
  programs.firefox.enable = true;

  # Fonts
  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    font-awesome
    (nerdfonts.override {
      fonts = [
        "NerdFontsSymbolsOnly"
        "FiraCode"
        # "FiraMono"
      ];
    })
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages
  environment.systemPackages = with pkgs; [
    gnome.adwaita-icon-theme
    alejandra
    brightnessctl
    eza
    fastfetch
    font-awesome
    fprintd
    framework-tool
    git
    gitui
    glib
    google-chrome
    grim
    helix
    jq
    kitty
    nano
    gnome.nautilus
    networkmanagerapplet
    nil
    nixfmt-rfc-style
    nix-search-cli
    nwg-displays
    nwg-look
    satty
    signal-desktop
    slack
    slurp
    wget
    wl-clipboard
    xcur2png
    yazi
    zoxide
    unstable.clipse
    unstable.warp-terminal

    # Hyprland/Desktop Environment
    hyprpicker
    rofi-power-menu
    rofi-wayland # app launcher
    ## notification center
    swaynotificationcenter # notification daemon
    libnotify # notification library
    ## end notification center
    swww # wallpaper daemon
    unstable.hyprgui
    unstable.hyprpolkitagent
  ];

  services.espanso.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.ssh.startAgent = true; # Can't enable this at the same time as gnupg.enableSSHSupport
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable fingerprint sensor
  services.fprintd.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
