# Sink stages

Sink stages are the **endpoints of a decode-orc pipeline**. They consume processed data from upstream stages and write results to disk or hardware. Unlike transform stages, sink stages do not produce outputs that can be connected further downstream.

A pipeline may contain **multiple sink stages** in parallel, allowing the same processed stream to be written in different formats or to different destinations.

Sink stages are used to:

* Write final video outputs (TBC + metadata)
* Export auxiliary data such as audio, EFM, or closed captions
* Output video directly to hardware for monitoring or capture
* Export intermediate data for inspection or external tools

---

## Analogue Audio Sink

| | |
|-|-|
| **Stage id** | `audio_sink` |
| **Stage name** | Analogue Audio Sink |
| **Connections** | 1 input → no outputs |
| **Purpose** | Export analogue audio to a WAV file |

**Use this stage when:**

* Your source contains analogue audio tracks
* You want to export audio independently of video output
* You want to inspect or process audio externally

**What it does**

This stage extracts analogue audio samples from the incoming stream and writes them to a standard WAV file. Audio remains synchronised to the processed video timeline.

**Parameters**

* `output` (string)
    - Path to the output WAV file.
    - Required.

**Notes**

* Digital audio (if present) is not handled by this stage.
* Audio stacking or selection must be performed upstream (e.g. via `stacker`).

---

## Chroma Sink

| | |
|-|-|
| **Stage id** | `chroma_sink` |
| **Stage name** | Chroma Sink |
| **Connections** | 1 input → no outputs |
| **Purpose** | Export decoded chroma information for inspection or external processing |

**Use this stage when:**

* Debugging or validating chroma decoding
* Inspecting chroma independently of luma
* Feeding chroma data into external analysis tools

**What it does**

This stage writes chroma samples to disk in a raw format suitable for offline inspection or research workflows.

**Parameters**

* `output` (string)
    - Path to the chroma output file.
    - Required.

**Notes**

* The exact chroma format depends on the upstream decoding stages.
* This stage is primarily intended as a diagnostic / research tool.

---

## Closed Caption Sink

| | |
|-|-|
| **Stage id** | `cc_sink` |
| **Stage name** | Closed Caption Sink |
| **Connections** | 1 input → no outputs |
| **Purpose** | Extract and write closed-caption (CC) data |

**Use this stage when:**

* Working with NTSC sources containing Line 21 closed captions
* You want to extract captions for archival or conversion
* You want to inspect CC data independently of video

**What it does**

This stage scans the incoming video stream for closed-caption data and writes decoded caption packets to a file.

**Parameters**

* `output` (string)
    - Path to the closed-caption output file.
    - Required.

**Notes**

* CC data must be preserved upstream (e.g. not masked out).
* Masking Line 21 before this stage will prevent caption extraction.

---

## EFM Sink

| | |
|-|-|
| **Stage id** | `efm_sink` |
| **Stage name** | EFM Sink |
| **Connections** | 1 input → no outputs |
| **Purpose** | Write raw EFM disc data to file |

**Use this stage when:**

* Archiving LaserDisc EFM data
* Feeding EFM data into external decoding or analysis tools
* Verifying EFM integrity after stacking or correction

**What it does**

This stage writes EFM (Eight-to-Fourteen Modulation) data extracted from the pipeline to disk, preserving field alignment and timing.

**Parameters**

* `output` (string)
    - Path to the EFM output file.
    - Required.

**Notes**

* EFM stacking behaviour is controlled upstream (e.g. in `stacker`).
* This stage does not modify EFM data.

---

## HackDAC Sink

| | |
|-|-|
| **Stage id** | `hackdac_sink` |
| **Stage name** | HackDAC Sink |
| **Connections** | 1 input → no outputs |
| **Purpose** | Output video directly to HackDAC hardware |

**Use this stage when:**

* You want real-time analogue video output
* Monitoring pipeline output on CRT or analogue equipment
* Testing signal characteristics on real hardware

**What it does**

This stage streams processed video fields directly to connected HackDAC hardware.

**Parameters**

* Hardware-specific parameters may be supported depending on build and platform.
* Typical configurations are provided externally rather than via stage parameters.

**Notes**

* This stage is hardware-dependent.
* Timing and field order must already be correct upstream.

---

## LD Sink

| | |
|-|-|
| **Stage id** | `ld_sink` |
| **Stage name** | LD Sink |
| **Connections** | 1 input → no outputs |
| **Purpose** | Write an ld-decode-compatible TBC and metadata output |

**Use this stage when:**

* Producing final archival-quality outputs
* Feeding results back into the ld-decode ecosystem
* Preserving full metadata, audio, and disc data

**What it does**

This stage writes:

* A `.tbc` file containing processed video fields
* A metadata database compatible with ld-decode
* Associated audio and EFM data if present

The output can be used directly with existing ld-decode tools.

**Parameters**

* `output` (string)
    - Base path for output files.
    - Required.

**Notes**

* This is the most common “final output” sink stage.
* All upstream corrections, stacking, and parameter overrides should be complete before this stage.

---

## Notes on Sink Stages

* Sink stages terminate pipeline branches.
* Multiple sink stages may consume the same upstream output.
* Sink stages do not alter timing or metadata beyond their specific export role.

This document is intended to complement the source-stage documentation :contentReference[oaicite:0]{index=0} and the transform-stage documentation, forming a complete reference for decode-orc pipeline construction.
