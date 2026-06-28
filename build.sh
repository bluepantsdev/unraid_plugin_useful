#!/bin/bash
# Build the useful.txz Slackware package
# Run this on a Linux host to produce a release artifact

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN="useful"
VERSION=$(date +%Y.%m.%d)
PKG_DIR="${SCRIPT_DIR}/pkg_build"
SRC_DIR="${SCRIPT_DIR}/src"
RELEASE_DIR="${SCRIPT_DIR}/release"
PLG="${SCRIPT_DIR}/${PLUGIN}.plg"

echo "Building $PLUGIN v$VERSION..."

# Clean and prep
rm -rf "$PKG_DIR"
mkdir -p "$PKG_DIR" "$RELEASE_DIR"

# Copy src tree into pkg_build
cp -a "$SRC_DIR"/. "$PKG_DIR"/

# Slackware package requires install/slack-desc
mkdir -p "$PKG_DIR/install"
cat > "$PKG_DIR/install/slack-desc" << SLACK
       |-----handy-ruler------------------------------------------------------|
useful: useful (Useful Scripts Plugin for Unraid)
useful:
useful: A collection of useful scripts and settings accessible
useful: from the Unraid web UI.
useful:
useful: https://github.com/bluepantsdev/unraid_plugin_useful
useful:
SLACK

# Build the .txz (Slackware package = tar.xz with specific structure)
cd "$PKG_DIR"
tar --owner=root --group=root -cJf "$RELEASE_DIR/${PLUGIN}.txz" .

# Generate SHA256
SHA=$(sha256sum "$RELEASE_DIR/${PLUGIN}.txz" | awk '{print $1}')
echo "$SHA" > "$RELEASE_DIR/${PLUGIN}.txz.sha256"

echo "Done. Package: $RELEASE_DIR/${PLUGIN}.txz"
echo "SHA256: $SHA"

# Patch useful.plg with current version and SHA256
if [[ ! -f "$PLG" ]]; then
    echo "ERROR: $PLG not found, cannot patch." >&2
    exit 1
fi

sed -i "s|<!ENTITY version.*|<!ENTITY version   \"$VERSION\">|" "$PLG"
sed -i "s|<!ENTITY pkgSHA256.*|<!ENTITY pkgSHA256 \"$SHA\">|" "$PLG"
sed -i "s|<SHA256>.*</SHA256>|<SHA256>$SHA</SHA256>|" "$PLG"

echo "Patched $PLG:"
grep -E 'ENTITY version|ENTITY pkgSHA256|<SHA256>' "$PLG"
