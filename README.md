# OSDev Wiki ZIM Archive (for Kiwix)

Offline ZIM archive of the [OSDev Wiki](https://wiki.osdev.org) for use with [Kiwix](https://kiwix.org).

## Download

You can download the latest precompiled `.zim` file from the [Releases](https://github.com/myakupozluk/osdev-wiki-zim/releases) page:
* **File:** `osdev_wiki.zim` (~129 MB)
* **Articles:** 1,460+ articles, 1,990+ media assets
* **Features:** Built-in Full-Text Search index, illustrations, and offline-compatible assets.

## How It's Built

Because `wiki.osdev.org` uses Cloudflare challenge on direct bot scrapers (like `mwoffliner`), this ZIM is compiled from the official weekly static HTML archives provided by OSDev at `https://files.osdev.org/osdev_wiki.zip` using openZIM's `zimwriterfs`.

### Requirements
* `unzip`
* `python3` with `Pillow` (PIL)
* `zim-tools` (`zimwriterfs`)

### Build Script

```bash
#!/usr/bin/env bash
set -e

# 1. Download official archive (or via browser if Cloudflare challenge is active)
# wget https://files.osdev.org/osdev_wiki.zip

# 2. Extract
mkdir -p build && cd build
unzip -q ../osdev_wiki.zip

# 3. Generate 48x48 PNG favicon required by zimwriterfs
python3 -c "
from PIL import Image
img = Image.open('wiki.osdev.org/favicon.ico')
img = img.resize((48, 48), Image.Resampling.LANCZOS)
img.save('wiki.osdev.org/illustration_48.png', 'PNG')
"

# 4. Compile into ZIM
zimwriterfs \
  --welcome=index.html \
  --illustration=illustration_48.png \
  --language=eng \
  --name=osdev_wiki \
  --title="OSDev Wiki" \
  --description="OSDev.org Wiki - Operating System Development" \
  --creator="OSDev.org" \
  --publisher="Kiwix" \
  wiki.osdev.org \
  ../osdev_wiki.zim
```

## License

Content from OSDev Wiki is licensed under [Creative Commons CC0 1.0 Universal (Public Domain)](https://wiki.osdev.org/OSDev_Wiki:Copyrights).
