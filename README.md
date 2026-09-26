# AIFRED Beta

AIFRED is a Windows x64 VST3 plugin for real-time mix analysis, reference
comparison, A/B measurement, and local or remote chat grounded in the current
mix snapshot.

The beta installer contains the VST3, shared DSP contract, self-contained
Intelligence Host, Ollama Windows installer, and AIFRED Modelfile. It requires
administrator approval. During setup, Ollama creates `aifred:latest` from the
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

## Repository scope

The Windows beta workflow is the supported release path. macOS is locally
scaffolded and requires signing; Linux is scaffolded but not validated.
