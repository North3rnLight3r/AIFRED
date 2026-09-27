#!/bin/bash
set -euo pipefail
export PATH="/usr/bin:/bin:/usr/sbin:/sbin"
[[ "$(uname -s)" == Darwin && "$(uname -m)" == arm64 ]] || { echo 'Requires an Apple silicon Mac.' >&2; exit 1; }
[[ "$(id -u)" != 0 ]] || { echo 'Run Install AIFRED as your normal user, without sudo.' >&2; exit 1; }
payload="${1:?Missing payload}"
data="$HOME/Library/Application Support/Aifred/beta"
plugins="$HOME/Library/Audio/Plug-Ins/VST3/AIFRED Beta"
mkdir -p "$data/logs"
exec > >(tee -a "$data/logs/install.log") 2>&1
echo 'Verifying installation payload…'
(cd "$payload" && shasum -a 256 -c SHA256SUMS) >/dev/null
# Refuse symlink destinations and validate copies before replacing owned components.
install_tree() {
  local source="$1" target="$2" candidate previous
  candidate="$target.candidate"
  previous="$target.previous"
  [[ ! -L "$target" && ! -e "$candidate" && ! -e "$previous" ]] || { echo "Unsafe or incomplete destination: $target"; exit 1; }
  mkdir -p "$(dirname "$target")"
  ditto "$source" "$candidate"
  diff -qr "$source" "$candidate" >/dev/null
  [[ ! -e "$target" ]] || mv "$target" "$previous"
  if ! mv "$candidate" "$target"; then
    [[ ! -e "$previous" ]] || mv "$previous" "$target"
    exit 1
  fi
  rm -rf "$previous"
}
uid="$(id -u)"
label=com.north3rnlight3r.aifred-intelligence-host
launchctl bootout "gui/$uid/$label" 2>/dev/null || true
echo 'Installing plugin and self-contained Intelligence Host…'
install_tree "$payload/Aifred.vst3" "$plugins/Aifred.vst3"
install_tree "$payload/shared-dsp" "$plugins/shared-dsp"
for component in IntelligenceHost model intelligence; do
  install_tree "$payload/$component" "$data/$component"
done
cp "$payload/manifest.json" "$data/manifest.json"
cp "$payload/aifred-settings.example.json" "$data/aifred-settings.example.json"
cp "$payload/uninstall.command" "$data/Uninstall AIFRED.command"
chmod +x "$data/Uninstall AIFRED.command" "$data/IntelligenceHost/AifredIntelligenceHost"
echo 'Installing bundled Ollama runtime…'
ollama="$data/Ollama.app/Contents/Resources/ollama"
if [[ ! -x "$ollama" ]]; then
  unpack="$(mktemp -d)"
  trap 'rm -rf "$unpack"' EXIT
  ditto -x -k "$payload/Ollama/Ollama-darwin.zip" "$unpack"
  install_tree "$unpack/Ollama.app" "$data/Ollama.app"
fi
mkdir -p "$HOME/Library/LaunchAgents"
# Generate XML with escaped user paths using the system JXA runtime; no Python/.NET SDK needed.
write_agent() {
  /usr/bin/osascript -l JavaScript - "$1" "$2" "$3" "$4" <<'JXA'
ObjC.import('Foundation');
function run(a) {
  var d = $.NSMutableDictionary.alloc.init;
  d.setObjectForKey($(a[0]), $('Label'));
  var args = a[0].endsWith('ollama') ? [a[1], 'serve'] : [a[1], '--channel', 'beta'];
  d.setObjectForKey($(args), $('ProgramArguments'));
  d.setObjectForKey($(true), $('RunAtLoad'));
  d.setObjectForKey($(true), $('KeepAlive'));
  d.setObjectForKey($(a[2]), $('StandardOutPath'));
  d.setObjectForKey($(a[2]), $('StandardErrorPath'));
  if (!d.writeToFileAtomically($(a[3]), true)) throw Error('Cannot write LaunchAgent');
}
JXA
  chmod 644 "$4"
}
ready() { curl -fsS --max-time 2 http://127.0.0.1:11434/api/tags >/dev/null 2>&1; }
if ! ready; then
  ollama_label=com.north3rnlight3r.aifred-beta-ollama
  ollama_agent="$HOME/Library/LaunchAgents/$ollama_label.plist"
  write_agent "$ollama_label" "$ollama" "$data/logs/ollama.log" "$ollama_agent"
  launchctl bootout "gui/$uid/$ollama_label" 2>/dev/null || true
  launchctl bootstrap "gui/$uid" "$ollama_agent"
fi
for attempt in $(seq 1 60); do ready && break; sleep 1; done
ready || { echo 'Ollama failed to start. See logs/ollama.log.'; exit 1; }
base_model="$(awk 'toupper($1)=="FROM" {print $2; exit}' "$data/model/Modelfile")"
[[ -n "$base_model" ]] || { echo 'Modelfile has no base model.'; exit 1; }
echo "Preparing local chat model ($base_model)…"
"$ollama" show "$base_model" >/dev/null 2>&1 || "$ollama" pull "$base_model"
"$ollama" create aifred:latest -f "$data/model/Modelfile"
"$ollama" show aifred:latest >/dev/null
agent="$HOME/Library/LaunchAgents/$label.plist"
write_agent "$label" "$data/IntelligenceHost/AifredIntelligenceHost" "$data/logs/host.log" "$agent"
launchctl bootstrap "gui/$uid" "$agent"
launchctl kickstart -k "gui/$uid/$label"
echo 'Checking Intelligence Host and chat readiness…'
for attempt in $(seq 1 60); do
  health="$(curl -fsS --max-time 3 http://127.0.0.1:8787/health || true)"
  if [[ -n "$health" ]] && /usr/bin/osascript -l JavaScript - "$health" <<'JXA'
function run(a) {
  var h = JSON.parse(a[0]);
  if (h.host_identity !== 'AifredIntelligenceHost' || h.product_channel !== 'beta' || !h.ai_available)
    throw Error('Host or model not ready');
}
JXA
  then
    echo 'AIFRED installed; plugin, Intelligence Host and local chat are ready.'
    exit 0
  fi
  sleep 1
done
echo 'Intelligence Host/model readiness failed. See logs/host.log and logs/host-error.log.'
exit 1
