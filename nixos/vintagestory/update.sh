#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq coreutils
# shellcheck shell=bash
set -euo pipefail

# Name of your package (must match the attr name in your flake or default.nix)
PACKAGE_NAME="vintagestory"

# Resolve script directory (so you can run this from anywhere)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔍 Getting current version from ${SCRIPT_DIR}/default.nix ..."
currentVersion=$(nix-instantiate --eval -E "
  let
    pkgs = import <nixpkgs> {};
    ${PACKAGE_NAME} = import \"${SCRIPT_DIR}\" {
      inherit (pkgs) lib stdenv fetchurl makeWrapper makeDesktopItem copyDesktopItems xorg gtk2 sqlite openal cairo libGLU SDL2 freealut libglvnd pipewire libpulseaudio dotnet-runtime_8;
    };
  in ${PACKAGE_NAME}.version
" | tr -d '"')

echo "Current version: $currentVersion"

echo "Checking for latest version on CDN..."
# Parse current version
IFS='.' read -r current_major current_minor current_patch <<<"$currentVersion"

# Start from current version - we'll check major, then minor, then patch
found_version="$currentVersion"

# Check major versions first (e.g., 1.x.x -> 2.0.0 -> ...)
for major in $(seq "$current_major" $((current_major + 5))); do
    # Determine starting minor: if same major, start from current_minor, else start from 0
    if [[ $major -eq $current_major ]]; then
        start_minor=$current_minor
    else
        start_minor=0
    fi

    # Check minor versions for this major
    for minor in $(seq "$start_minor" $((start_minor + 50))); do
        # Determine starting patch: if same major.minor, start from current_patch, else start from 0
        if [[ $major -eq $current_major && $minor -eq $current_minor ]]; then
            start_patch=$((current_patch + 1))
        else
            start_patch=0
        fi

        # Check patch versions for this major.minor
        for patch in $(seq "$start_patch" $((start_patch + 50))); do
            test_version="${major}.${minor}.${patch}"
            test_url="https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_${test_version}.tar.gz"
            if curl --output /dev/null --silent --head --fail "$test_url"; then
                found_version="$test_version"
            else
                # If patch 0 doesn't exist, this minor version doesn't exist
                if [[ $patch -eq 0 ]]; then
                    break 2 # Break out of patch and minor loops
                else
                    break # Break out of patch loop, continue with next minor
                fi
            fi
        done
    done
done

latestVersion="$found_version"

if [[ -z "$latestVersion" ]]; then
    echo "❌ ERROR: Could not determine latest version!"
    exit 1
fi

echo "Latest version available on CDN: $latestVersion"

# Construct download URL
downloadUrl="https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_${latestVersion}.tar.gz"

# Exit early if already up to date
if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "Already up to date. Nothing to do."
    exit 0
fi

# Ensure the download works
echo "Verifying URL... $downloadUrl"
if ! curl --output /dev/null --silent --head --fail "$downloadUrl"; then
    echo "❌ ERROR: Download URL is not valid!"
    exit 1
fi

# Prefetch new source and compute hash
echo "Fetching source to compute hash..."
source=$(nix-prefetch-url "$downloadUrl" --name "vintagestory-$latestVersion")
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
sed -i "s|url = \".*vs_client_linux-x64_.*\.tar\.gz\";|url = \"${downloadUrl}\";|" "$default_nix"

# Update hash for fetchurl
sed -i "s|hash = \".*\";|hash = \"${hash}\";|" "$default_nix"

echo "✅ Updated $PACKAGE_NAME to version $latestVersion"
