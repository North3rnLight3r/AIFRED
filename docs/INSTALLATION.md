# Windows installation

## Requirements

- Windows x64.
- A DAW that can load VST3 plugins.
- Administrator approval for the installer. The installer writes the shared
  VST3 location and registers the beta Intelligence Host at Windows logon.
- Internet access during first setup if Ollama must install or if the base
  model named by `models/aifred/Modelfile` is not already available locally.

## Install

1. Download `AIFRED-VST3-Setup.exe` from the GitHub release.
2. Run it and approve the Windows elevation prompt.
3. Wait for the installer to install the plugin and Intelligence Host, start
   Ollama, create `aifred:latest`, and start the host on port 8787.
4. Rescan VST3 plugins in the DAW. Insert AIFRED on the main mix or analysis
   bus and route the main signal to Mix A.

The installer keeps existing AIFRED settings. It installs the beta-owned
plugin under `%CommonProgramFiles%\VST3\AIFRED Beta` and the beta host under
`%LOCALAPPDATA%\Aifred\beta\IntelligenceHost`.

## Uninstall

Use `AIFRED-Uninstall.exe` from the release artifact. It stops the beta host,
removes the beta plugin, shared DSP files, startup entry, and host binaries.
It does not remove Ollama or user settings.

## First launch

The DSP meters do not require chat or Ollama. If chat is not ready, AIFRED can
still measure audio. The Chat panel becomes usable after the local host reports
that the selected provider and model are available.
