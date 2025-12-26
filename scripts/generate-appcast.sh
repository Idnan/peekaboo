#!/bin/bash

# Generate Sparkle appcast entry for a new release
# Usage: ./generate-appcast.sh <version> <zip-path> <private-key-path>

set -e

VERSION=$1
ZIP_PATH=$2
PRIVATE_KEY=$3

if [ -z "$VERSION" ] || [ -z "$ZIP_PATH" ]; then
    echo "Usage: $0 <version> <zip-path> [private-key-path]"
    echo "Example: $0 1.0.1 ./Peekaboo-1.0.1.zip ~/.sparkle_private_key"
    exit 1
fi

# Get file info
FILE_SIZE=$(stat -f%z "$ZIP_PATH" 2>/dev/null || stat --printf="%s" "$ZIP_PATH")
PUB_DATE=$(date -R 2>/dev/null || date "+%a, %d %b %Y %H:%M:%S %z")

# Generate signature if private key provided
SIGNATURE=""
if [ -n "$PRIVATE_KEY" ] && [ -f "$PRIVATE_KEY" ]; then
    # Use Sparkle's sign_update tool
    if command -v sign_update &> /dev/null; then
        SIGNATURE=$(sign_update "$ZIP_PATH" -f "$PRIVATE_KEY")
    else
        echo "Warning: sign_update not found. Install Sparkle tools or sign manually."
        SIGNATURE="SIGNATURE_PLACEHOLDER"
    fi
else
    SIGNATURE="SIGNATURE_PLACEHOLDER"
fi

# GitHub repo URL - update this to match your repo
REPO_URL="https://github.com/peekabook/peekaboo"
DOWNLOAD_URL="$REPO_URL/releases/download/v$VERSION/Peekaboo-$VERSION.zip"

cat << EOF

    <item>
      <title>Version $VERSION</title>
      <pubDate>$PUB_DATE</pubDate>
      <sparkle:version>$VERSION</sparkle:version>
      <sparkle:shortVersionString>$VERSION</sparkle:shortVersionString>
      <description><![CDATA[
        <h2>What's New in $VERSION</h2>
        <ul>
          <li>Update this with your release notes</li>
        </ul>
      ]]></description>
      <enclosure 
        url="$DOWNLOAD_URL"
        length="$FILE_SIZE"
        type="application/octet-stream"
        sparkle:edSignature="$SIGNATURE" />
    </item>

EOF

echo ""
echo "Add the above XML to appcast.xml inside the <channel> tag."
echo "Remember to update the release notes!"

