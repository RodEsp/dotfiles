{
  appimageTools,
  fetchurl,
}: let
  pname = "cursor-ide";
  version = "2.0.34";

  src = fetchurl {
    url = "https://downloads.cursor.com/production/45fd70f3fe72037444ba35c9e51ce86a1977ac11/linux/x64/Cursor-${version}-x86_64.AppImage";
    hash = "sha256-x51N2BttMkfKwH4/Uxn/ZNFVPZbaNdsZm8BFFIMmxBM=";
  };
in
  appimageTools.wrapType2 {inherit pname version src;}
