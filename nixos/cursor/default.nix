{
  lib,
  appimageTools,
  fetchurl,
}: let
  pname = "cursor";
  version = "2.1.48";

  src = fetchurl {
    url = "https://downloads.cursor.com/production/ce371ffbf5e240ca47f4b5f3f20efed084991120/linux/x64/Cursor-2.1.48-x86_64.AppImage";
    hash = "sha256-Uq61ZZZzlRyDqPaNnJbteFQ4KC9usD5DdUSTGgvo2wI=";
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
