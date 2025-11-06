{
  lib,
  appimageTools,
  fetchurl,
}: let
  pname = "cursor";
  version = "2.0.63";

  src = fetchurl {
    url = "https://downloads.cursor.com/production/505046dcfad2acda3d066e32b7cd8b6e2dc1fdcd/linux/x64/Cursor-2.0.63-x86_64.AppImage";
    hash = "sha256-7wA1R0GeUSXSViviXAK+mc14CSE2aTgFrbcBKj5dTbI=";
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
  }
