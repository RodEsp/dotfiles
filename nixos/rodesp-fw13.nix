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
    ./dev.nix
    ./main-user.nix
    ./steam.nix
    ./nvidia.nix
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  # ===== Linux Kernel =====

  boot.kernelPackages = pkgs.linuxPackages_xanmod_stable;

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

  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true; # To connect to Bambu Lab printer we must disable the firewall because NixOS's firewall does not support SSDP and multicast yet
      # Bambu Lab Printer Ports - https://wiki.bambulab.com/en/general/printer-network-ports
      # allowedTCPPorts = [1990 2021 3000 322 6000 990];
    };
  };

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
    power-profiles-daemon.enable = lib.mkDefault true; # AMD has better battery life with PPD over TLP: https://community.frame.work/t/responded-amd-7040-sleep-states/38101/1
    printing.enable = true; # Enable CUPS to print documents.
    udev.extraRules = ''
      # Always authorize thunderbolt connections when they are plugged in.
      # This is to make sure the USB hub of Thunderbolt is working.
      ACTION=="add", SUBSYSTEM=="thunderbolt", ATTR{authorized}=="0", ATTR{authorized}="1"
    '';
    gvfs.enable = true; # GNOME virtual file system - allows things to interact with various filesystems & protocols
    udisks2.enable = true; # daemon that implements D-Bus interfaces used to query & manipulate storage devices
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
  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-runtime-7.0.20"
  ];

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    brightnessctl # control screen/device brightness
    clipse # clipboard manager
    everforest-gtk-theme
    framework-tool
    glib # system libraries in C, mainly for GNOME stuff
    google-chrome
    grim # screenshot tool (grabs images from wayland compositors)
    hyprgui # GUI for configuring Hyprland
    hyprpicker # wlroot-compatible wayland screen color picker
    hyprpolkitagent # a polkit authentication daemon. It is required for GUI applications to be able to request elevated privileges.
    legcord # Discord client
    libnotify # notification library
    libreoffice
    nano
    nautilus
    networkmanagerapplet
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
    stow # symlink farm manager (for adding dotfiles to ~/.config folder)
    swaynotificationcenter # notification daemon
    swww # wallpaper daemon
    xcur2png # converts x cursor images to PNG

    # terminal related
    bat # better cat
    btop # tui system resource monitor
    eza # modern alternative to ls
    fastfetch # system information display tool (better neofetch)
    kitty # terminal emulator
    nix-search-cli # nix-search command
    starship # terminal prompt manager
    ueberzugpp # allows drawing images on the terminal on Wayland (for yazi image preview)
    wl-clipboard # commandline copy/paste utils for wayland
    zoxide # smarter cd command

    # 3d printing
    bambu-studio
    freecad-wayland

    # nixos-unstable branch
    unstable.ghostty # terminal emulator
    unstable.helix # terminal text/code editor

    # overrides
    (flameshot.override {enableWlrSupport = true;})

    # games
    (callPackage ./vintagestory.nix {})

    # warp terminal
    (callPackage ./warp-terminal/package.nix {})
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
