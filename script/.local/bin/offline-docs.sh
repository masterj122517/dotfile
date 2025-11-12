#!/usr/bin/env bash
# Usage: ./offline-docs.sh <URL>
# Example: ./offline-docs.sh https://ziglang.org/documentation/0.15.1/

set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 <URL>"
    exit 1
fi

URL="$1"

# Trim spaces just in case
URL="$(echo "$URL" | tr -d '[:space:]')"

# Normalize folder name: e.g. ziglang.org_documentation_0.15.1
FOLDER="$(echo "$URL" | sed 's|https\?://||; s|/|_|g')"

echo "[*] Starting offline mirror of $URL"
echo "[*] Output folder: $FOLDER"
sleep 1

wget \
  --mirror \
  --convert-links \
  --adjust-extension \
  --page-requisites \
  --no-parent \
  --continue \
  --limit-rate=1M \
  --wait=1 \
  -P "$FOLDER" \
  "$URL"

echo "[✓] Mirror complete!"
echo "[*] To view locally:"
echo "    cd $FOLDER && python3 -m http.server 8000"
echo "    Visit: http://localhost:8000"
