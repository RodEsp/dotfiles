#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq coreutils
set -euo pipefail

# Name of your package (must match the attr name in your flake or default.nix)
PACKAGE_NAME="cursor"

# Resolve script directory (so you can run this from anywhere)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔍 Getting current version from ${SCRIPT_DIR}/default.nix ..."
currentVersion=$(nix-instantiate --eval -E "
  let
    pkgs = import <nixpkgs> {};
    ${PACKAGE_NAME} = import \"${SCRIPT_DIR}\" {
      inherit (pkgs) lib appimageTools fetchurl;
    };
  in ${PACKAGE_NAME}.version
" | tr -d '"')

echo "Current version: $currentVersion"

# Fetch metadata for the latest Linux x86_64 build from Cursor API
api_url="https://api2.cursor.sh/updates/api/download/stable/linux-x64/cursor"
echo "Checking for updates from $api_url ..."
result=$(curl -s "$api_url")

latestVersion=$(echo "$result" | jq -r '.version')
downloadUrl=$(echo "$result" | jq -r '.downloadUrl')

echo "Latest version upstream: $latestVersion"
echo "Download URL: $downloadUrl"

# Exit early if already up to date
if [[ "$latestVersion" == "$currentVersion" ]]; then
  echo "Already up to date. Nothing to do."
  exit 0
fi

# Ensure the download works
echo "Verifying URL..."
if ! curl --output /dev/null --silent --head --fail "$downloadUrl"; then
  echo "❌ ERROR: Download URL is not valid!"
  exit 1
fi

# Prefetch new source and compute hash
echo "Fetching source to compute hash..."
source=$(nix-prefetch-url "$downloadUrl" --name "cursor-$latestVersion")
hash=$(nix-hash --to-sri --type sha256 "$source")

echo "Fetched and hashed successfully."
echo "New version: $latestVersion"
echo "New hash: $hash"

# Update derivation in-place
echo "Updating derivation..."
default_nix="${SCRIPT_DIR}/default.nix"

# Update version attribute
sed -i "s/version = \".*\";/version = \"${latestVersion}\";/" "$default_nix"

# Update URL for fetchurl
sed -i "s|url = \".*\";|url = \"${downloadUrl}\";|" "$default_nix"

# Update hash for fetchurl
sed -i "s|hash = \".*\";|hash = \"${hash}\";|" "$default_nix"

echo "✅ Updated $PACKAGE_NAME to version $latestVersion"

