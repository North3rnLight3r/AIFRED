#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/common.sh"
require_macos
require_tools swiftc hdiutil codesign ditto python3
package_source="${1:-$CURRENT_ROOT}"
mkdir -p "$PACKAGE_ROOT"
image_root="$(mktemp -d)"
trap 'rm -rf "$image_root"' EXIT
app="$image_root/Install AIFRED.app"
resources="$app/Contents/Resources"
mkdir -p "$resources" "$app/Contents/MacOS"
ditto "$package_source" "$resources/payload"
python3 - "$resources/payload" <<'PYHASH'
import hashlib, pathlib, sys
root = pathlib.Path(sys.argv[1])
lines = []
for p in sorted(root.rglob('*')):
    if p.is_file():
        lines.append(hashlib.file_digest(p.open('rb'), 'sha256').hexdigest() + '  ' + p.relative_to(root).as_posix() + '\n')
(root / 'SHA256SUMS').write_text(''.join(lines))
PYHASH
cp "$SCRIPT_DIR/install-payload.sh" "$resources/install-payload.sh"
cat > "$app/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleIdentifier</key><string>com.aifred.beta.installer</string>
<key>CFBundleName</key><string>Install AIFRED</string>
<key>CFBundleExecutable</key><string>Install AIFRED</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>CFBundleShortVersionString</key><string>0.3.6</string>
<key>CFBundleVersion</key><string>1</string>
<key>LSMinimumSystemVersion</key><string>14.0</string>
<key>NSHighResolutionCapable</key><true/>
</dict></plist>
PLIST
swiftc -O -target arm64-apple-macos14.0 -framework AppKit "$SCRIPT_DIR/Installer.swift" -o "$app/Contents/MacOS/Install AIFRED"
codesign --force --sign - "$app"
codesign --verify --deep --strict "$app"
cp "$ROOT/docs/MACOS_INSTALLATION.txt" "$image_root/READ ME.txt"
hdiutil create -volname 'AIFRED VST3 beta' -srcfolder "$image_root" -ov -format UDZO "$PACKAGE_ROOT/AIFRED-VST3-macos-arm64.dmg"
hdiutil verify "$PACKAGE_ROOT/AIFRED-VST3-macos-arm64.dmg"
echo "Created $PACKAGE_ROOT/AIFRED-VST3-macos-arm64.dmg"
