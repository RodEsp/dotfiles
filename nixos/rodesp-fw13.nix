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
    # ./nvidia.nix
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  # ===== Linux Kernel =====

  # boot.kernelPackages = pkgs.linuxPackages_xanmod_stable;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.kernelModules = ["amdgpu"];
  boot.kernelParams = [
    "video=card2-eDP-1:2256x1504@60"
    "video=DP-2:2560x1600@59.97"
  ];

  # ===== Nix Settings =====
  # nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  # ===== Autoupgrade NixOS =====

  # system.autoUpgrade.enable = true;
  # system.autoUpgrade.allowReboot = true;

  # ===== Boot Configuration =====

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ===== Filesystems (drives) =====

  fileSystems."/run/media/rodesp/WDBLACK_P40_EXT4" = {
    device = "/dev/disk/by-uuid/0f8a5ea4-e05a-4e0b-ab92-ccc5ad11c556";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
    ];
  };

  # ===== Framework Laptop Specifics =====

  services.fwupd.enable = true;
  # we need fwupd 1.9.7 to downgrade the fingerprint sensor firmware
  services.fwupd.package =
    (import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/bb2009ca185d97813e75736c2b8d1d8bb81bde05.tar.gz";
      sha256 = "sha256:003qcrsq5g5lggfrpq31gcvj82lb065xvr7bpfa8ddsw8x4dnysk";
    }) {inherit (pkgs) system;}).fwupd;

  # ===== Hardware Configuration =====

  hardware = {
    enableRedistributableFirmware = true;
    graphics.enable = true;
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
      # UniFi ports - https://help.ui.com/hc/en-us/articles/218506997-Required-Ports-Reference
      allowedTCPPorts = [
        22
        53
        443
        1900
        6789
        8080
        8443
        8880
        8883
      ];
      allowedUDPPorts = [
        10001
        53
        3478
        443
        123
      ];
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
    espanso = {
      enable = true;
      package = pkgs.espanso-wayland;
    };
    fprintd.enable = true; # Enable fingerprint sensor
    hypridle.enable = true;
    # tailscale.enable = true;
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
    unifi = {
      enable = true;
      unifiPackage = pkgs.unifi;
      mongodbPackage = pkgs.mongodb-ce;
    };
    xserver = {
      enable = true;
      videoDrivers = ["amdgpu"];
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
      nerd-fonts.fira-code
      fira-code-symbols
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
    appimage = {
      enable = true;
      binfmt = true;
    };
    bash.interactiveShellInit = ''
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
    '';
    command-not-found.enable = false;
    firefox.enable = true;
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    hyprlock.enable = true;
    nix-index.enable = true;
    nix-ld.enable = true;
    winbox.enable = true;
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
    # hyprgui # GUI for configuring Hyprland -- Was removed in 25.05
    hyprpicker # wlroot-compatible wayland screen color picker
    hyprpolkitagent # a polkit authentication daemon. It is required for GUI applications to be able to request elevated privileges.
    legcord # Discord client
    libnotify # notification library
    libreoffice
    nautilus
    networkmanagerapplet
    nwg-displays # GUI for managing monitors/displays
    nwg-look # GTK3 settings editor for wlroots-based Wayland environments
    pavucontrol # sound/volume device controller
    pciutils # Collection of programs for inspecting and manipulating configuration of PCI devices
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
    vlc # media player
    xcur2png # converts x cursor images to PNG
    zulip # IM client

    # terminal related
    bat # better cat
    btop # tui system resource monitor
    blesh # Better BASH autocomplete
    eza # modern alternative to ls
    fastfetch # system information display tool (better neofetch)
    glow # terminal markdown renderer
    kitty # terminal emulator
    nano
    nix-search-cli # nix-search command
    ripgrep # grep but better and written in Rust
    starship # terminal prompt manager
    ueberzugpp # allows drawing images on the terminal on Wayland (for yazi image preview)
    wl-clipboard # commandline copy/paste utils for wayland
    zoxide # smarter cd command

    # 3d printing
    bambu-studio
    freecad-wayland

    # nixos-unstable branch
    unstable.affine # second-brain/note taking app
    unstable.ghostty # terminal emulator
    unstable.helix # terminal text/code editor
    unstable.mission-center # Resource monitor (CPU, Memory, Disk, Network, GPU)

    # overrides
    (flameshot.override {enableWlrSupport = true;})

    # games
    (callPackage ./vintagestory/default.nix {})
  ];

  # ===== System Env Vars =====

  environment.variables = {
    NIXOS_OZONE_WL = "1"; # Allow/force applications to run directly on wayland (without xwayland)
    XDG_DATA_HOME = "$HOME/.config/";
    XDG_CONFIG_HOME = "$HOME/.config/";
    EDITOR = "hx";
    TERMINAL = "ghostty";
  };
}
