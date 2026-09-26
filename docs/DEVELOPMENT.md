# Development

## Windows prerequisites

- Visual Studio C++ Build Tools with the x64 compiler and Windows SDK.
- CMake 3.24 or newer.
- Ninja.
- Python 3.12 or newer.
- .NET SDK 10.0.
- PowerShell.

CMake downloads JUCE 8.0.14 during the first configure. The Windows preset
uses `out/windows-x64/build` and produces the VST3 at
`plugin-aifred/Aifred_artefacts/Release/VST3/Aifred.vst3` below that build
directory.

## Build and test

From the repository root:

```powershell
./scripts/windows/build.ps1 -Action test
```

For a headless CI run, exclude the interactive GUI snapshot test:

```powershell
./scripts/windows/build.ps1 -Action test -SkipGuiTests
```

The CI workflow uses the second form because
`aifred_gui_layout_tests` requires an interactive desktop. The remaining
frontend, state, reference-pool, core, host-contract, repository, and shared
core checks still run.

## Repository boundaries

`shared-dsp` and the Intelligence Host are checked against
`shared-core.lock.json`. A change to those canonical shared files must update
that inventory deliberately. The Windows beta build does not load a separate
DSP implementation from another product tree.

Do not commit `out/`, IDE outputs, published binaries, model weights, API keys,
or local settings. The repository contains the AIFRED Modelfile, not a copy of
the base model weights.
