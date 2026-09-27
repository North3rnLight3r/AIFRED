# AIFRED VST3 beta

Windows x64 and macOS Apple silicon installers are built from the identical
source commit, with the frozen beta plugin and backend behavior preserved.

- Windows: run `AIFRED-VST3-Setup.exe`; the ZIP and uninstaller are also supplied.
- macOS 14+ Apple silicon: open `AIFRED-VST3-macos-arm64.dmg`, then
  `Install AIFRED.app`, and click Install. The beta is unsigned and not notarized;
  if blocked, approve it in System Settings > Privacy & Security > Open Anyway.

Both installers include the VST3, shared DSP contract, self-contained
Intelligence Host, bundled Ollama runtime, and AIFRED Modelfile.
Setup creates `aifred:latest` locally and may download its base model.
No compiler or .NET SDK is needed. Live reference-pool data requires access
to the plugin's configured online service. Existing settings are retained.
