# Field Line vs Frame Line Numbering

## Understanding the Difference

When working with interlaced video, it's crucial to understand the difference between **field line numbers** and **frame line numbers**.

### Frame Lines
- A complete video **frame** consists of all the scan lines
- NTSC: 525 total frame lines
- PAL: 625 total frame lines
- Frame lines are numbered from top to bottom of the full frame

### Field Lines  
- A **field** contains roughly half the frame lines (due to interlacing)
- NTSC: ~262-263 lines per field
- PAL: ~312-313 lines per field
- In interlaced video, each frame has two fields:
  - **First field** (odd field): contains odd-numbered frame lines
  - **Second field** (even field): contains even-numbered frame lines
- Field lines are numbered **0-based** within each field

## Mask Line Stage Numbering

**The mask_line stage uses FIELD LINE NUMBERS (0-based), NOT frame line numbers.**

### Common Examples

#### NTSC Closed Captions
- **Traditionally stated as**: "Line 21" (using 1-based numbering)
- **What this means**: Field line at index 20 of the first field (0-based)
- **In mask_line format**: `F:20`
- ❌ NOT frame line 21
- ❌ NOT field line index 21 (that would be traditional "line 22")
- ✅ Field line index 20 in the first field (traditional "line 21" in 1-based)

#### PAL Teletext/WSS
- **Range**: Field lines 6-22
- **In mask_line format**: `A:6-22` (both fields)
- These are field line numbers, not frame lines

#### PAL WSS (Wide Screen Signaling)
- **Location**: Field line 23 of the first field
- **In mask_line format**: `F:23`

### Line Specification Format

Format: `PARITY:LINE` or `PARITY:START-END`

Where PARITY is:
- `F` = First field only
- `S` = Second field only
- `A` = All fields (both)

Examples:
- `F:20` - Field line index 20, first field only (NTSC CC - traditional "line 21")
- `S:15-20` - Field line indices 15-20, second field only
- `A:6-22` - Field line indices 6-22, both fields (PAL teletext)
- `F:20,A:10` - Field line index 20 in first field + field line index 10 in all fields

### Valid Ranges

**NTSC** (field line numbers):
- Range: 0 to ~261
- First active field line: typically 20
- Last active field line: typically 259

**PAL** (field line numbers):
- Range: 0 to ~311
- First active field line: typically 22
- Last active field line: typically 310

## Why This Matters

Using the wrong numbering system will result in masking the wrong lines! For example:
- Frame line 21 in NTSC would be in the first field at field line ~11 (21÷2)
- Traditional video "line 21" uses 1-based counting, so it's field line index 20 in 0-based
- NTSC closed captions are at **field line index 20** (traditional "line 21"), not frame line 21

Always use **0-based field line indices** when configuring the mask_line stage.
