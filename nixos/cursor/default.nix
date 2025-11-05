{
  lib,
  appimageTools,
  fetchurl,
}: let
  pname = "cursor";
  version = "2.0.60";

  src = fetchurl {
    url = "https://downloads.cursor.com/production/c6d93c13f57509f77eb65783b28e75a857b74c03/linux/x64/Cursor-${version}-x86_64.AppImage";
    hash = "sha256-g/FMqKk/FapbRTQ5+IG1R2LHVlDXDNDc3uN9lJMMcaI=";
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
