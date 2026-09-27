# Release process

`.github/workflows/build.yml` builds Windows x64 and macOS Apple silicon from
one clean checkout SHA, with full Git history and recursive submodules.
It runs repository, Python, .NET and headless C++ contract tests, verifies the
staged file inventory and hashes, and packages the frozen beta without changing
plugin or backend source. The macOS job verifies the mounted DMG, installer
signature, payload hashes, architectures and Ollama ZIP integrity.

After both jobs succeed on main, publication verifies that both manifests
match the workflow SHA and that main still points to that SHA. It publishes
one latest release titled **AIFRED VST3 beta**, using the packaging tag
`v0.3.6-beta-installers` and the unchanged product version 0.3.6.
The tag points to the exact commit used for both platform builds.
Only after the new assets are uploaded and checked does it delete superseded
GitHub releases and all other remote tags, as required for this frozen beta.
PR builds never publish. Workflow dispatch on main also builds and publishes.

Assets:

- `AIFRED-VST3-Setup.exe`
- `AIFRED-VST3-windows.zip`
- `AIFRED-Uninstall.exe`
- `AIFRED-VST3-macos-arm64.dmg`

The macOS job selects Xcode 26.3 for the frozen source's C++20 `jthread` and
`stop_token` support and sets the deployment target to macOS 14.

Local validation (macOS requires Xcode 26.3 or a compatible newer toolchain):

```powershell
./scripts/windows/build.ps1 -Action release -SkipGuiTests
```

```sh
bash scripts/macos/build.sh release --skip-gui-tests
bash scripts/macos/verify-package.sh
```

The macOS DMG includes a native AppKit installer and a complete compiled
payload, including the self-contained .NET host and bundled Ollama runtime.
Installation uses only macOS system tools, verifies hashes before copying,
registers per-user LaunchAgents, creates the AIFRED model, and checks host/chat
readiness. It retains user settings. Both platforms download their Ollama
runtime during packaging; model weights download during installation if absent.
Reference-pool data remains supplied by the frozen plugin's configured service.

The macOS beta is ad hoc signed and **not Developer ID signed or notarized**,
per the approved unsigned beta distribution policy. See the installation guide
for the macOS approval step. Intel Macs and Linux are not supported by this
release. Build validation does not certify DAW-specific loading.
