#!/bin/bash

set -e

REPO="amzxyz/rime_wanxiang"
ZIP_FILE="rime-wanxiang-flypy-fuzhu.zip"
GRAM_FILE="wanxiang-lts-zh-hans.gram"
OUTPUT_DIR="Rime"

echo "Fetching latest release from $REPO..."

# Get latest release tag from HTML page
LATEST_RELEASE=$(curl -s "https://github.com/$REPO/releases" | grep -o 'download/v[0-9.]*' | head -n 1 | cut -d'/' -f2)

if [ -z "$LATEST_RELEASE" ]; then
    echo "Error: Could not fetch latest release"
    exit 1
fi

echo "Latest release: $LATEST_RELEASE"

# Download zip file from rime_wanxiang repo
ZIP_URL="https://github.com/$REPO/releases/download/$LATEST_RELEASE/$ZIP_FILE"
echo "Downloading $ZIP_FILE from $ZIP_URL..."
curl -L -o "$ZIP_FILE" "$ZIP_URL"

# Download gram file from RIME-LMDG repo (different repo)
GRAM_URL="https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/$GRAM_FILE"
echo "Downloading $GRAM_FILE from $GRAM_URL..."
curl -L -o "$GRAM_FILE" "$GRAM_URL"

# Remove existing Rime directory if it exists
if [ -d "$OUTPUT_DIR" ]; then
    echo "Removing existing $OUTPUT_DIR directory..."
    rm -rf "$OUTPUT_DIR"
fi

# Create Rime directory and extract zip into it
echo "Extracting $ZIP_FILE to $OUTPUT_DIR/..."
mkdir -p "$OUTPUT_DIR"
unzip -q "$ZIP_FILE" -d "$OUTPUT_DIR"

# Move gram file to Rime folder
echo "Moving $GRAM_FILE to $OUTPUT_DIR/..."
mv "$GRAM_FILE" "$OUTPUT_DIR/"

# Copy existing custom files to Rime/ (overwrite)
echo "Copying existing custom files to $OUTPUT_DIR/..."
cp -f custom_phrase.txt "$OUTPUT_DIR/"
cp -f squirrel.custom.yaml "$OUTPUT_DIR/"
cp -f squirrel.yaml "$OUTPUT_DIR/"
cp -f wanxiang_pro.custom.yaml "$OUTPUT_DIR/"
cp -f wanxiang_pro.schema.yaml "$OUTPUT_DIR/"

# Cleanup
echo "Cleaning up..."
rm "$ZIP_FILE"

echo "Installation complete! Files are in $OUTPUT_DIR/"
