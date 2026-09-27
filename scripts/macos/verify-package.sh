#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/common.sh"
mount="$(mktemp -d)"
trap 'hdiutil detach "$mount" >/dev/null 2>&1 || true; rmdir "$mount" 2>/dev/null || true' EXIT
hdiutil attach "$PACKAGE_ROOT/AIFRED-VST3-macos-arm64.dmg" -readonly -nobrowse -mountpoint "$mount"
app="$mount/Install AIFRED.app"
codesign --verify --deep --strict "$app"
codesign --verify --deep --strict "$app/Contents/Resources/payload/Aifred.vst3"
payload="$app/Contents/Resources/payload"
(cd "$payload" && shasum -a 256 -c SHA256SUMS) >/dev/null
lipo "$payload/Aifred.vst3/Contents/MacOS/Aifred" -verify_arch arm64
lipo "$app/Contents/MacOS/Install AIFRED" -verify_arch arm64
unzip -tq "$payload/Ollama/Ollama-darwin.zip"
echo 'DMG, installer signature, payload hashes, architecture and Ollama archive verified.'

if [[ "${1:-}" == --install-smoke-test ]]; then
  bash "$app/Contents/Resources/install-payload.sh" "$payload"
  data="$HOME/Library/Application Support/Aifred/beta"
  diff -qr "$payload/Aifred.vst3" "$HOME/Library/Audio/Plug-Ins/VST3/AIFRED Beta/Aifred.vst3"
  diff -qr "$payload/IntelligenceHost" "$data/IntelligenceHost"
  curl -fsS http://127.0.0.1:8787/health
  bash "$data/Uninstall AIFRED.command"
  [[ ! -e "$HOME/Library/Audio/Plug-Ins/VST3/AIFRED Beta/Aifred.vst3" && ! -e "$data/IntelligenceHost" ]]
  echo 'Installation, real model provisioning, host readiness and uninstall smoke test passed.'
fi
