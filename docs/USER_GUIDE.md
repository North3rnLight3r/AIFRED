# User guide

## Signal routing

Insert AIFRED on the signal you want to measure and route that signal to Mix A.
For A/B comparison, enable the wrapper's second input and route the comparison
signal to Mix B without sending it to the master twice.

The plugin accepts mono or stereo Mix A and Mix B inputs. The Compare view
reports values for A and B and defines Delta as `A - B`.

## Views

- **Analyze** measures the live Mix A input.
- **Reference** keeps the live analysis visible and compares it with a selected
  analyzed reference when the reference is compatible.
- **Compare** measures Mix A and Mix B side by side.
- **Options** selects the chat provider, endpoint, API key, and model.
- **Help** shows the routing and provider guidance inside the plugin.

## DSP profiles

The profiles are fixed in the shared DSP contract:

- `MIX_BALANCED`: general-purpose mix analysis.
- `SPECTRUM_SURGICAL`: higher-resolution frequency inspection.
- `MASTERING_PRECISION`: mastering and final-stage metering.
- `STEREO_PHASE_DIAGNOSTIC`: stereo, balance, side/mid, width, and correlation.

The profile changes measurement windows and required metrics. It does not apply
mix processing or change the audio signal.

## Measurements

AIFRED presents sample peak, RMS, true peak, momentary and short-term loudness,
integrated loudness, loudness range, crest, correlation, channel energy,
balance, side/mid, width, spectrum, bands, and vectorscope data according to the
selected profile. An unavailable value means the required observation is not
valid or fresh enough; it is not substituted with an estimate.

The spectrum display range is presentation-only. It does not change the
authoritative FFT values.

## Options and saved state

Provider settings are stored by the plugin and can also be managed by the
Intelligence Host. The beta host uses port 8787; Ollama uses port 11434. DAW
plugin state stores the selected profile, display settings, mode, and provider
fields required to restore the session.
