# Troubleshooting

## The plugin does not appear in the DAW

Confirm that the DAW scans VST3 plugins and rescan after installation. The
beta plugin is installed at:

`%CommonProgramFiles%\VST3\AIFRED Beta\Aifred.vst3`

If the DAW has a plugin cache, clear or rescan that cache. Confirm that the DAW
and plugin architecture are both Windows x64.

## Chat says the host is unavailable

1. Open `http://127.0.0.1:8787/health`.
2. Confirm `host_identity` is `AifredIntelligenceHost` and
   `product_channel` is `beta`.
3. Check the host logs at `%LOCALAPPDATA%\Aifred\beta\logs`.
4. Start the installed host again if the startup entry was disabled.

The host executable is under `%LOCALAPPDATA%\Aifred\beta\IntelligenceHost`.

## Ollama is unavailable or the model is missing

Open `http://127.0.0.1:11434/api/tags`. If it does not respond, start Ollama
or restart setup. If `aifred:latest` is absent, rerun the setup so it can run
the bundled Modelfile. The base model download requires network access and
enough disk space for Ollama's model storage.

## Chat responds with provider errors

Check the provider, endpoint, model, and API key in Options. For Ollama, leave
the key blank and use port 11434. For remote providers, check network access
and credentials. A provider error does not invalidate DSP measurements.

## Reference mode has no values

Wait for the Official pool status to finish loading, check network access to the
pool URL, and confirm the selected entry contains the metric being displayed.
For local references, choose a file with usable audio and wait for analysis to
complete. Compatibility-sensitive deltas require matching metadata.

## Installer fails

Run setup again as administrator. Do not delete existing settings while
troubleshooting. The installer requires the bundled payload to contain the
VST3, host, `model/Modelfile`, and `Ollama/OllamaSetup.exe`; a corrupt or
incomplete download should be replaced with the release artifact again.

## Host port conflict

The beta host uses 8787 and Ollama uses 11434. Stop another process using the
same port, or choose a valid host setting through the supported settings route.
The plugin and host must agree on the beta channel and host port.
