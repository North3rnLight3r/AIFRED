#!/bin/bash
set -euo pipefail
uid="$(id -u)"
data="$HOME/Library/Application Support/Aifred/beta"
plugins="$HOME/Library/Audio/Plug-Ins/VST3/AIFRED Beta"
for label in com.north3rnlight3r.aifred-intelligence-host com.north3rnlight3r.aifred-beta-ollama; do
  launchctl bootout "gui/$uid/$label" 2>/dev/null || true
  rm -f "$HOME/Library/LaunchAgents/$label.plist"
done
for target in "$plugins/Aifred.vst3" "$plugins/shared-dsp" "$data/IntelligenceHost" "$data/model" "$data/intelligence" "$data/Ollama.app"; do
  [[ ! -L "$target" ]] || { echo "Refusing symlink: $target"; exit 1; }
  rm -rf "$target"
done
rmdir "$plugins" 2>/dev/null || true
echo 'AIFRED beta removed. User settings, logs and Ollama model weights retained.'
