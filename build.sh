#!/usr/bin/env bash
set -euo pipefail

ZIP_FILE="${1:-osdev_wiki.zip}"
OUT_FILE="${2:-osdev_wiki.zim}"

if [ ! -f "$ZIP_FILE" ]; then
    echo "Usage: $0 <path_to_osdev_wiki.zip> [output_file.zim]"
    exit 1
fi

BUILD_DIR="$(mktemp -d -t osdev_build_XXXXXX)"
trap 'rm -rf "$BUILD_DIR"' EXIT

echo "==> Extracting $ZIP_FILE..."
unzip -q -o "$ZIP_FILE" -d "$BUILD_DIR"

WIKI_DIR="$BUILD_DIR/wiki.osdev.org"
if [ ! -d "$WIKI_DIR" ]; then
    echo "Error: expected wiki.osdev.org directory inside zip"
    exit 1
fi

echo "==> Preparing 48x48 illustration..."
python3 -c "
from PIL import Image
img = Image.open('$WIKI_DIR/favicon.ico')
img = img.resize((48, 48), Image.Resampling.LANCZOS)
img.save('$WIKI_DIR/illustration_48.png', 'PNG')
"

echo "==> Compiling into $OUT_FILE using zimwriterfs..."
zimwriterfs \
  --welcome=index.html \
  --illustration=illustration_48.png \
  --language=eng \
  --name=osdev_wiki \
  --title="OSDev Wiki" \
  --description="OSDev.org Wiki - Operating System Development" \
  --creator="OSDev.org" \
  --publisher="Kiwix" \
  "$WIKI_DIR" \
  "$OUT_FILE"

echo "==> Done! Output: $OUT_FILE"
