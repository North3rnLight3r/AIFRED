# Reference mode

Reference mode has two sources: the Official reference pool and a local audio
file.

## Official pool

When the plugin starts, it requests the public pool at
`https://north3rnlight3r.com/api/v1/reference/pool`. The response must declare
the `aifred.references.v1` contract. A valid entry supplies its public identity
and the measurements actually present in the response.

Select an entry from the Official reference menu. The reference panel shows
live values, supplied reference values, and deltas when those values exist.
Missing measurements remain unavailable; scalar measurements are not converted
into invented ranges.

The shared DSP filter only treats a reference as compatible for metric
relationships when the reference includes matching schema, profile, and sample
rate metadata. An entry can therefore display supplied reference data while
still being ineligible for compatibility-sensitive relationships.

## Local reference

Choose **LOAD LOCAL REFERENCE** and select a WAV, AIFF, MP3, or FLAC file. The
file is analyzed locally using the current profile. A local reference is used
only after it contains usable signal data. Selecting a new local reference
clears the selected Official entry.

## Interpreting unavailable data

`No analyzed reference target`, `Measured reference value unavailable`, and
similar messages are intentional. They distinguish no reference, an
unavailable reference, incompatible metadata, and an observation that is not
fresh or sufficient. A reference never changes the live audio signal.
