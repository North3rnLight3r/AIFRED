# Chat and Intelligence Host

## Components

Chat uses three local pieces:

1. The VST3 sends a validated `FilteredMixContext` to the host.
2. `AifredIntelligenceHost` listens on `http://127.0.0.1:8787` and routes the
   request.
3. The default Ollama provider listens on
   `http://127.0.0.1:11434` and serves `aifred:latest`.

The host is local-only. It exposes health, chat, and settings endpoints on the
loopback interface; it does not expose a public network listener.

## Installer setup

The setup package contains `Ollama/OllamaSetup.exe` and `model/Modelfile`. If
Ollama is absent, setup runs the bundled installer. It then runs the Ollama
server if necessary and creates `aifred:latest` from the Modelfile. The
Modelfile declares the base model, so Ollama may download that base model on
first setup.

The Intelligence Host starts with the beta channel and is registered in the
current user's Run key. Existing settings are preserved.

## Provider configuration

The supported providers are `ollama`, `openai`, and `openai-compatible`.

- Ollama: endpoint `http://127.0.0.1:11434`, model `aifred:latest`, blank API
  key.
- OpenAI: configure the endpoint, model, and API key appropriate to the
  installed host build.
- OpenAI-compatible: configure an HTTP(S) endpoint, model, and API key.

Use the Options panel to save these values. The host validates the provider,
endpoint, model, timeout, and port before saving.

## Health checks

Open these URLs locally when troubleshooting:

- `http://127.0.0.1:8787/health` — host identity, channel, provider, model, and
  availability.
- `http://127.0.0.1:8787/v1/settings` — public settings metadata; API key
  contents are not returned.
- `http://127.0.0.1:11434/api/tags` — Ollama model inventory.

Chat requires a healthy beta host and an available selected provider. DSP
analysis remains independent of provider availability.
