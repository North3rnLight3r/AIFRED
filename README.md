<Header>
   <p class><img width="168" height="168" alt="aifred-mascot" src="https://github.com/user-attachments/assets/edb2e034-af9f-4774-a739-7e277d912539" /p>
</Header>

# AIFRED VST - Beta

  
AIFRED is a Windows x64 and macOS Apple silicon VST3 plugin for real-time mix analysis, reference
comparison, A/B measurement, and local or remote chat grounded in the current
mix snapshot.

The beta installer contains the VST3, shared DSP contract, self-contained
Intelligence Host, platform-specific Ollama runtime, and AIFRED Modelfile. The Windows installer requires
administrator approval; the macOS installer installs for the current account. During setup, Ollama creates `aifred:latest` from the
bundled Modelfile; Ollama may download the Modelfile's base model, so network
access is required unless that model is already installed.

## Documentation

- [Documentation index](docs/README.md)
- [Installation](docs/INSTALLATION.md)
- [User guide](docs/USER_GUIDE.md)
- [Chat and Intelligence Host](docs/CHAT_AND_INTELLIGENCE.md)
- [Reference mode](docs/REFERENCE_MODE.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [Development](docs/DEVELOPMENT.md)
- [Release process](docs/RELEASE.md)

### Getting the most accurate mix analysis

AIFRED analyzes a rolling history of recent DSP measurements rather than relying on a single instantaneous meter reading.

When EQ, filters, dynamics, gain, stereo processing, or other effects are being actively adjusted, BufferHunter may capture multiple transitional mix states. Those observations can remain within the recent analysis window for a short period after the adjustment is complete.

For best results, allow your project to play normally for **at least 30 seconds after making significant processing changes** before requesting a new analysis.

This allows the observation window to represent the mix you actually settled on rather than the intermediate states produced whiimport { useAudioEngine } from './hooks/useAudioEngine'
