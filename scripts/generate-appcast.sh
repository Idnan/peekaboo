#!/bin/bash
set -e

# Usage: ./generate-appcast.sh <version> <zip-path> <repo-url> [private-key-path]
# Example: ./generate-appcast.sh 1.0.1 ./Peekaboo-1.0.1.zip https://github.com/idnan/peekaboo /tmp/key

VERSION=$1
ZIP_PATH=$2
REPO_URL=$3
PRIVATE_KEY=$4

if [ -z "$VERSION" ] || [ -z "$ZIP_PATH" ] || [ -z "$REPO_URL" ]; then
    echo "Usage: $0 <version> <zip-path> <repo-url> [private-key-path]"
    exit 1
fi

ZIP_NAME=$(basename "$ZIP_PATH")
FILE_SIZE=$(stat -f%z "$ZIP_PATH" 2>/dev/null || stat --printf="%s" "$ZIP_PATH")
PUB_DATE=$(date "+%a, %d %b %Y %H:%M:%S %z")
DOWNLOAD_URL="$REPO_URL/releases/download/v$VERSION/$ZIP_NAME"

# Sign if private key provided
SIGNATURE=""
if [ -n "$PRIVATE_KEY" ] && [ -f "$PRIVATE_KEY" ]; then
    if [ -n "$SPARKLE_BIN" ] && [ -f "$SPARKLE_BIN/sign_update" ]; then
        SIGNATURE=$("$SPARKLE_BIN/sign_update" "$ZIP_PATH" -f "$PRIVATE_KEY")
    elif [ -f "/tmp/Sparkle/bin/sign_update" ]; then
        SIGNATURE=$(/tmp/Sparkle/bin/sign_update "$ZIP_PATH" -f "$PRIVATE_KEY")
    else
        echo "Error: sign_update not found. Set SPARKLE_BIN or ensure /tmp/Sparkle exists"
        exit 1
    fi
fi

if [ -z "$SIGNATURE" ]; then
    echo "Error: Could not generate signature"
    exit 1
fi

# Output the item XML
cat << EOF
    <item>
      <title>Version $VERSION</title>
      <pubDate>$PUB_DATE</pubDate>
      <sparkle:version>$VERSION</sparkle:version>
      <sparkle:shortVersionString>$VERSION</sparkle:shortVersionString>
      <description><![CDATA[
        <h2>What's New in $VERSION</h2>
        <p>See GitHub release notes for details.</p>
      ]]></description>
      <enclosure 
        url="$DOWNLOAD_URL"
        length="$FILE_SIZE"
        type="application/octet-stream"
        sparkle:edSignature="$SIGNATURE" />
    </item>
EOF
