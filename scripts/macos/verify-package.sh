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
  # .NET stores Mac host settings inside the installed host directory.
  settings='{"provider_mode":"ollama","endpoint":"http://127.0.0.1:11434","model_name":"aifred:latest","packaging_test":"retain-user-settings"}'
  printf '%s' "$settings" > "$data/IntelligenceHost/settings.json"
  bash "$app/Contents/Resources/install-payload.sh" "$payload"
  [[ "$(cat "$data/IntelligenceHost/settings.json")" == "$settings" ]]
  bash "$data/Uninstall AIFRED.command"
  [[ ! -e "$HOME/Library/Audio/Plug-Ins/VST3/AIFRED Beta/Aifred.vst3" && ! -e "$data/IntelligenceHost/AifredIntelligenceHost" ]]
  [[ "$(cat "$data/IntelligenceHost/settings.json")" == "$settings" ]]
  echo 'Installation, model provisioning, host readiness, settings retention, reinstall and uninstall passed.' 
fi
