# Release process

## Source and workflow

The supported Windows release workflow is `.github/workflows/build.yml`. It
checks out full history and recursive submodules because release manifests use
Git metadata. The workflow builds from the checked-out commit, runs the
headless-safe test path, packages the beta, verifies its inventory and hashes,
and uploads the three release artifacts.

The workflow produces:

- `AIFRED-VST3-windows.zip` — the complete extracted payload.
- `AIFRED-VST3-Setup.exe` — the single-file Windows installer embedding that
  payload.
- `AIFRED-Uninstall.exe` — the beta uninstaller.

On a version tag, the release job publishes those artifacts to the matching
GitHub release using `docs/RELEASE_NOTES.md`.

## Local release validation

```powershell
./scripts/windows/build.ps1 -Action release -SkipGuiTests
```

The release script prepares an owned staging directory, writes `manifest.json`,
checks every file hash, confirms the plugin matches the exact build target, and
promotes the verified stage to `out/windows-x64/current`.

The beta package downloads the current Ollama Windows setup executable during
packaging unless `out/windows-x64/build/OllamaSetup.exe` is already present.
The final installer still creates the AIFRED model at install time because the
base model weights are not stored in this repository.

## Release limitations

The manifest reports build and repository validation only. It does not certify
DAW-specific loading, code signing, or every Windows host configuration.
macOS remains signing-required and Linux remains unvalidated according to
`scripts/release-layout.json`.
