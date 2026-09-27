# Installation

## Windows

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

## macOS Apple silicon

Requires macOS 14 or later on Apple silicon and a VST3-compatible DAW.
Download `AIFRED-VST3-macos-arm64.dmg`, open it, and open `Install AIFRED.app`.
This beta is ad hoc signed, without Developer ID signing or Apple notarization.
If blocked, attempt to open the installer, then approve it using System Settings
> Privacy & Security > Open Anyway. Click Install and wait for the model download
and host readiness check to finish. Rescan VST3 plugins in your DAW.

The DMG bundles the compiled VST3 (including reference-pool client), shared DSP
contract, self-contained .NET host, intelligence assets, Ollama runtime, and
AIFRED Modelfile. No developer tools are required on the user's computer.
Live reference-pool data remains served by the configured online service.

The plugin installs under `~/Library/Audio/Plug-Ins/VST3/AIFRED Beta`.
The host and Ollama runtime install under `~/Library/Application Support/Aifred/beta`.
LaunchAgents start the host and installer-owned Ollama service at login.
Existing settings are retained. The base model downloads during setup if absent.

To uninstall, open `Uninstall AIFRED.command` in the beta data folder.
Installation diagnostics are in `logs/install.log` in that folder.
