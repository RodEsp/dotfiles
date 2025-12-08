{
  lib,
  appimageTools,
  fetchurl,
}: let
  pname = "cursor";
  version = "2.2.36";

  src = fetchurl {
    url = "https://downloads.cursor.com/production/55c9bc11e99cedd1fb93fbb7996abf779c58315f/linux/x64/Cursor-2.2.36-x86_64.AppImage";
    hash = "sha256-t6PJJcTlLVPd3MfJEdMfsbwUMeDBOfAGZiQArGrHzLo=";
  };

  appimageContents = appimageTools.extractType2 {inherit pname version src;};
in
  appimageTools.wrapType2 {
    inherit pname version src;

    executableName = "cursor";
    desktopName = "Cursor";
    iconName = "cursor";

    extraInstallCommands = ''
      # Install .desktop file
      mkdir -p $out/share/applications
      cat > $out/share/applications/cursor.desktop <<-EOF
      [Desktop Entry]
      Name=Cursor
      Comment=The AI Code Editor.
      Exec=cursor %F
      Icon=co.anysphere.cursor
      Type=Application
      StartupNotify=false
      StartupWMClass=Cursor
      Categories=TextEditor;Development;IDE;
      MimeType=application/x-cursor-workspace;
      Keywords=cursor;

      X-AppImage-Version=${version}
      EOF

      # Install icon from app image
      mkdir -p $out/share/icons/hicolor/512x512/apps
      cp "${appimageContents}/co.anysphere.cursor.png" $out/share/icons/hicolor/512x512/apps/co.anysphere.cursor.png
    '';

    meta = {
      description = "AI enabled IDE based on VSCode";
      homepage = "https://cursor.com";
      changelog = "https://cursor.com/changelog";
      license = lib.licenses.unfree;
      platforms = ["x86_64-linux"];
      mainProgram = "cursor";
    };

    passthru.updateScript = ./update.sh;
  }
