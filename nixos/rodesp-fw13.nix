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
  imports = [
    ./dev.nix
    ./main-user.nix
    ./steam.nix
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  # ===== Nix Settings =====
  # nix.settings.experimental-features = ["nix-command" "flakes"];

  # ===== Autoupgrade NixOS =====

  # system.autoUpgrade.enable = true;
  # system.autoUpgrade.allowReboot = true;

  # ===== Boot Configuration =====

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ===== Framework Laptop Specifics =====

  services.fwupd.enable = true;
  # we need fwupd 1.9.7 to downgrade the fingerprint sensor firmware
  services.fwupd.package =
    (import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/bb2009ca185d97813e75736c2b8d1d8bb81bde05.tar.gz";
      sha256 = "sha256:003qcrsq5g5lggfrpq31gcvj82lb065xvr7bpfa8ddsw8x4dnysk";
    }) {inherit (pkgs) system;})
    .fwupd;

  # ===== Hardware Configuration =====

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    keyboard.zsa.enable = true;
  };

  # ===== Security =====

  security = {
    rtkit.enable = true; # PulseAudio server (or others) uses this to acquire realtime priority
  };

  # ===== Networking =====

  networking.networkmanager.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # ===== System Configuration =====
  time.timeZone = "America/New_York";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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
  };

  # ===== System Services =====

  services = {
    power-profiles-daemon.enable = lib.mkDefault true; # AMD has better battery life with PPD over TLP: https://community.frame.work/t/responded-amd-7040-sleep-states/38101/1
    blueman.enable = true;
    fprintd.enable = true; # Enable fingerprint sensor
    hypridle.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    printing.enable = true; # Enable CUPS to print documents.
    xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      xkb = {
        layout = "us,latam";
        variant = "";
        options = "grp:alt_shift_toggle";
      };
    };
  };

  # ===== User Configuration =====

  main-user.enable = true;
  main-user.userName = "rodesp";

  # ===== System Fonts =====

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      font-awesome
      (nerdfonts.override {
        fonts = [
          "NerdFontsSymbolsOnly"
          "FiraCode"
        ];
      })
    ];
  };

  # ===== XDG Portal =====

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];
    };
  };

  # ===== System Programs =====

  programs = {
    # _1password.enable = true;
    # _1password-gui.enable = true;
    firefox.enable = true;
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    hyprlock.enable = true;
    # winbox.enable = true;
    waybar.enable = true;
    yazi = {
      enable = true;
      settings = {
        yazi = lib.importTOML /home/rodesp/.config/yazi/yazi.toml;
        theme = lib.importTOML /home/rodesp/.config/yazi/theme.toml;
      };
    };
  };

  # ===== System packages =====

  nixpkgs.config.allowUnfree = true; # Allow unfree packages

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    bat
    brightnessctl # control screen/device brightness
    btop
    clipse
    everforest-gtk-theme
    eza
    fastfetch
    framework-tool
    glib
    google-chrome
    grim # screenshot tool (grabs images from wayland compositors)
    helix
    hyprgui
    hyprpicker
    hyprpolkitagent
    kitty
    libnotify # notification library
    libreoffice
    nano
    nautilus
    networkmanagerapplet
    nix-search-cli # nix-search command
    nwg-displays # GUI for managing monitors/displays
    nwg-look # GTK3 settings editor for wlroots-based Wayland environments
    pavucontrol # sound/volume device controller
    playerctl
    rofi-power-menu
    rofi-wayland # app launcher/system level menu
    satty # screenshot/image annotation tool
    signal-desktop
    slack
    slurp # region selector for wayland compositors (for screenshots)
    stow
    swaynotificationcenter # notification daemon
    swww # wallpaper daemon
    wget
    wl-clipboard
    xcur2png
    zoxide
    # nixos-unstable branch
    unstable.ghostty

    # master branch
    master.warp-terminal
  ];

  # ===== System Env Vars =====

  environment.variables = {
    NIXOS_OZONE_WL = "1"; # Allow/force applications to run directly on wayland (without xwayland)
    XDG_DATA_HOME = "$HOME/.config/";
    XDG_CONFIG_HOME = "$HOME/.config/";
    EDITOR = "hx";
    TERMINAL = "warp-terminal";
  };
}
