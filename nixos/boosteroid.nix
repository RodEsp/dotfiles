{
  stdenv,
  lib,
  dpkg,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  libxfixes,
  libxi,
  libx11,
  libxcb,
  libxcb-wm,
  libxcb-image,
  libxcb-keysyms,
  libxcb-render-util,
  libxkbcommon,
  wayland,
  libgcc,
  freetype,
  systemd,
  alsa-lib,
  fontconfig,
  pcre2,
  dbus,
  numactl,
  pulseaudio,
  libva-minimal,
  xz,
  libva,
  libvdpau,
}:
stdenv.mkDerivation {
  pname = "boosteroid";
  version = "1.10.9 (beta)";

  # They don't provide a way to download a specific version, and I didn't find developer contacts yet.
  src = fetchurl {
    url = "https://boosteroid.com/linux/installer/boosteroid-install-x64.deb";
    curlOpts = "--user-agent 'Mozilla/5.0'";
    hash = "sha256-62mgMlpEMqugq7Zjia+xJ8Ff7O3Vc4zE/Z/F+8wwQZE=";
  };
  unpackPhase = "dpkg-deb -x $src .";

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    numactl
    pulseaudio

    libva-minimal
    xz # liblzma.so.5
    libva # libva-x11.so.2
    libvdpau # libvdpau.so.1
    libxfixes # libXfixes.so.3
    libxi # libXi.so.6
    libx11 # libX11-xcb.so.1
    libxcb
    libxcb-wm
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxkbcommon
    wayland
    libgcc.lib
    freetype # libfreetype.so.6
    systemd # libudev.so.1
    alsa-lib # libasound.so.2
    fontconfig # libfontconfig.so.1
    pcre2 # libpcre2-16.so.0
    dbus.lib # libdbus-1.so.3
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "Boosteroid";
      desktopName = "Boosteroid";
      exec = "Boosteroid";
      icon = "boosteroid";
      comment = "Cloud gaming client";
      categories = ["Game"];
    })
  ];

  installPhase = ''
    mkdir -p $out/bin

    install -m755 "opt/BoosteroidGamesS.R.L./bin/Boosteroid" $out/bin/Boosteroid
    install -dm755 "$out/share/applications"
    install -dm755 "$out/share/icons/Boosteroid"
    install -m644 "usr/share/applications/Boosteroid.desktop" "$out/share/applications/Boosteroid.desktop"
    install -m644 "usr/share/icons/Boosteroid/icon.svg" "$out/share/icons/Boosteroid/icon.svg"

    substituteInPlace $out/share/applications/Boosteroid.desktop \
      --replace "/opt/BoosteroidGamesS.R.L./bin/Boosteroid" "$out/bin/Boosteroid" \
      --replace "/usr/share/icons/Boosteroid/icon.svg" "$out/share/icons/Boosteroid/icon.svg"

    # Doesn't work in Wayland — tries to call XGetKeyboardControl from libX11 and dumps stack.
    wrapProgram $out/bin/Boosteroid \
      --set QT_QPA_PLATFORM xcb
  '';

  meta = with lib; {
    homepage = "https://boosteroid.com/downloads/";
    description = "Boosteroid cloud gaming client";
    maintainers = with maintainers; [cab404];
    license = licenses.unfree;
    mainProgram = "Boosteroid";
    platforms = ["x86_64-linux"];
  };

  mainProgram = "Boosteroid";
}
