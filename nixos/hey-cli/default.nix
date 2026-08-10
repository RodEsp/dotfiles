{pkgs ? import <nixpkgs> {}}:
pkgs.buildGoModule rec {
  pname = "hey-cli";
  version = "1.4.0";

  src = pkgs.fetchFromGitHub {
    owner = "basecamp";
    repo = "hey-cli";
    rev = "v${version}";
    hash = "sha256-y86pSryOZZGCQPCiprjENOeqvXejhbB3piRxy/w6WJ4=";
  };

  # Instructs Nix to only build the entry point inside the cmd/hey folder
  subPackages = ["cmd/hey"];

  # Leave this empty at first; Nix will throw a hash mismatch error
  # and output the correct vendorHash during your first build attempt.
  vendorHash = "sha256-Nupd+16J+aXwNnstS6W86jjx1Usuwsw4FJSU6tdcQ3o=";

  meta = with pkgs.lib; {
    description = "HEY CLI and Agent Skills";
    homepage = "https://github.com";
    license = licenses.mit; # Verify the official LICENSE file in the repo
  };
}
