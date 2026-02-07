# Source Stages

Source stages are the starting point of your processing pipeline. They load video captures from disk and make them available for processing. Every project needs at least one source stage.

## LD PAL Source

Loads PAL LaserDisc captures that were decoded using ld-decode. This is your starting point for working with PAL format LaserDiscs (used in Europe, Australia, and most of the world outside North America and Japan).

### Parameters

- **TBC File Path**
  - Select your PAL `.tbc` file captured and decoded with ld-decode. The matching `.tbc.db` metadata file will be loaded automatically from the same location.
  - File Extension: `.tbc`
  - Required: No (you can add the file later)

- **PCM Audio File Path**
  - If you captured analogue audio, select the `.pcm` audio file. This is the raw stereo audio that was recorded alongside the video.
  - File Extension: `.pcm`
  - Required: No

- **EFM Data File Path**
  - If you captured digital audio/data (EFM), select the `.efm` file. This contains the raw digital data stream from the LaserDisc.
  - File Extension: `.efm`
  - Required: No

## LD NTSC Source

Loads NTSC LaserDisc captures that were decoded using ld-decode. This is your starting point for working with NTSC format LaserDiscs (used in North America, Japan, and other NTSC regions).

### Parameters

- **TBC File Path**
  - Select your NTSC `.tbc` file captured and decoded with ld-decode. The matching `.tbc.db` metadata file will be loaded automatically from the same location.
  - File Extension: `.tbc`
  - Required: No (you can add the file later)

- **PCM Audio File Path**
  - If you captured analogue audio, select the `.pcm` audio file. This is the raw stereo audio that was recorded alongside the video.
  - File Extension: `.pcm`
  - Required: No

- **EFM Data File Path**
  - If you captured digital audio/data (EFM), select the `.efm` file. This contains the raw digital data stream from the LaserDisc.
  - File Extension: `.efm`
  - Required: No

---

# Transform Stages

Transform stages modify and improve your video. They can fix problems, combine multiple captures, or adjust how the video is processed. Connect them between your source and sink stages.

## Field Map

Lets you select which fields to keep and in what order. This is useful for removing damaged sections, reordering captures that started at the wrong point, or skipping over bad areas of your LaserDisc.  Note that the field map also handles analogue audio and raw EFM data associated with the fields.

**Example:** If you have 100 fields but want to skip fields 20-30 because they're badly damaged, you would use: `0-19,31-99`

### When to use this
- Remove damaged or corrupted sections from your capture
- Reorder fields from captures that didn't start at the beginning
- Skip over sections with severe playback problems
- Align multiple captures before stacking them

### Parameters

- **Field Ranges**
  - Enter ranges of fields you want to keep, separated by commas. For example: `0-10,20-30,11-19` would output fields 0-10 first, then 20-30, then 11-19.
  - Leave empty to pass all fields through unchanged.
  - Default: `""` (pass everything through)
  - Required: No

- **Random Seed**
  - Used for testing - creates a repeatable pattern of simulated field problems. Most users should leave this at 0.
  - Default: `0`
  - Required: No

## Stacker

Stacking is the act of combining multiple captures into a single output.  If you've captured mutliple LaserDiscs with the same content (master), the Stacker combines them into a single superior output by intelligently choosing the best parts from each capture. This dramatically reduces dropouts and visual noise.  The stacker can also process analogue audio and raw EFM data.

**How it works:** For each point in the video, the Stacker looks at the same point across all your captures and picks the best data. Different modes use different strategies for deciding what's "best."

### Stacking Modes
- **Auto**: Automatically picks the best algorithm (recommended for most users)
- **Mean**: Averages all captures together - smooths out random noise
- **Median**: Takes the middle value - best for removing extreme outliers
- **Smart Mean**: Only averages captures that are similar to each other - combines benefits of mean and median
- **Smart Neighbor**: Like Smart Mean but also looks at neighboring pixels
- **Neighbor**: Uses neighboring pixels to make context-aware decisions

### When to use this
- You have 2 or more captures of the same LaserDisc
- Your captures have dropouts in different locations
- You want the highest quality output possible
- You're seeing random noise or artifacts that vary between captures

### Parameters

- **Stacking Mode**
  - Choose how captures are combined. "Auto" works well for most cases. Try "Smart Mean" if Auto doesn't give good results, or "Median" if you have lots of random noise.
  - Options: Auto, Mean, Median, Smart Mean, Smart Neighbor, Neighbor
  - Default: `Auto`
  - Required: No

- **Smart Threshold**
  - Controls how picky the "Smart" modes are. Lower values (5-10) are very selective and only combine very similar data. Higher values (20-30) are more forgiving. Only matters for Smart Mean and Smart Neighbor modes.
  - Range: 0-128
  - Default: `15`
  - Required: No

- **Disable Differential Dropout Detection**
  - Leave this OFF (unchecked) to let the Stacker rescue pixels that were incorrectly marked as dropouts. Only turn it ON if you notice the Stacker is making mistakes and you want it to strictly trust the dropout markers.
  - Default: `false` (OFF - allow recovery)
  - Required: No

- **Passthrough Universal Dropouts**
  - Turn this ON if every single one of your captures has the same physical damage in the same spots (like a permanent scratch). The Stacker won't try to fix these since no good data exists. Leave OFF for normal use.
  - Default: `false` (OFF - try to fix everything)
  - Required: No

- **Audio Stacking Mode**
  - Choose how to combine audio from multiple captures. Most users should stick with the default.
  - Required: No

- **EFM Stacking Mode**
  - Choose how to combine EFM from multiple captures. Most users should stick with the default.
  - Required: No

## Source Align

Makes sure multiple captures are synchronized before stacking. If your captures didn't all start at exactly the same frame of the LaserDisc, this stage figures out the offset and aligns them automatically using the frame numbers embedded in the video.

**Why you need this:** Each capture might have started a few frames earlier or later. Before combining them with the Stacker, they need to line up exactly so field 100 from capture A matches field 100 from capture B.

### When to use this
- ALWAYS use this before the Stacker if you have multiple captures
- Your captures started at different points on the disc
- You've used Field Map stages and need to re-synchronize

### Parameters

- **Alignment Map**
  - Usually leave this empty to let the stage automatically detect alignment using frame numbers. Only fill this in if automatic detection isn't working and you know the exact offsets (advanced users only).
  - Example: `1+2, 2+2, 3+1` means skip 2 fields from input 1, 2 fields from input 2, and 1 field from input 3.
  - Default: `""` (auto-detect)
  - Required: No

- **Enforce Field Order**
  - Keep this ON to ensure the output starts with a "first field" (top field). This prevents interlacing problems. Only turn OFF if you specifically need different behavior.
  - Default: `true` (ON)
  - Required: No

## Dropout Correct

Fixes dropouts (missing or corrupted video data) by intelligently filling them in with good data from nearby lines or the opposite field. This is essential for getting clean, watchable video from damaged LaserDiscs.

**How it works:** When the decoder finds a dropout, this stage looks for similar lines nearby and copies that data to fill in the gap. It's smart about finding lines with matching content and chroma phase.

### When to use this
- Your LaserDisc has visible dropouts (white flashes, streaks, or corrupted areas)
- After stacking, to clean up any remaining dropouts
- Before final video export to ensure clean output

### Parameters

- **Overcorrect Extension**
  - Expand the dropout regions by this many samples before correcting. Useful if you notice faint edges around corrected dropouts. For heavily damaged discs, try 12-24. For clean discs, leave at 0.
  - Range: 0-48 samples
  - Default: `0`
  - Required: No

- **Intrafield Only**
  - ON: Only use data from within the same field (more conservative, less chance of motion artifacts)
  - OFF: Can use data from the opposite field too (better coverage, might show motion artifacts in fast movement)
  - Most users should leave this OFF.
  - Default: `false` (OFF)
  - Required: No

- **Max Replacement Distance**
  - How far (in lines) to search for good replacement data. Larger values give more options but might use less similar data. 10 works well for most cases.
  - Range: 1-50 lines
  - Default: `10`
  - Required: No

- **Match Chroma Phase**
  - PAL only: Ensures replacement lines have the correct color phase. Keep this ON unless you're seeing color problems in corrected areas.
  - Default: `true` (ON)
  - Required: No

- **Highlight Corrections**
  - Turn this ON to see where dropouts were corrected - they'll show as bright white. Useful for checking the correction results. Turn OFF for normal viewing.
  - Default: `false` (OFF)
  - Required: No

## Dropout Map

Advanced tool for manually marking or unmarking dropout areas that the automatic detection missed or got wrong. This lets you tell the Dropout Correct stage exactly where problems are, field by field.

**This is advanced!** Most users won't need this - automatic dropout detection works well. Use this if you notice specific areas that should be corrected but aren't, or areas being incorrectly corrected.

### When to use this
- Automatic dropout detection missed obvious problems
- False positives: areas being corrected that don't need it
- You need precise control over specific problem areas
- Testing or debugging dropout correction

### Parameters

- **Dropout Map**
  - Advanced: Enter a JSON-formatted list of dropout additions and removals for specific fields. Format: `[{field:0,add:[{line:10,start:100,end:200}],remove:[{line:15,start:50,end:75}]}]`
  - Leave empty for normal use. See advanced documentation for formatting details.
  - Default: `[]` (empty)
  - Required: No

## Mask Line

Blacks out specific field lines in your video. This is useful for removing visible VBI (Vertical Blanking Interval) data like timecode, closed captions, or teletext that you don't want to appear in your final video output.

**How it works:** The stage replaces specified lines with a solid color at your chosen IRE level (usually black at 0 IRE). You can mask different lines on first and second fields, and the masking happens in the processing pipeline so later stages see the masked output.

**⚠️ IMPORTANT WARNING:** If you mask lines that observers need (like line 20 for NTSC closed captions, or lines 10-20 for other VBI data), those observers will stop working because the data they need will be gone. If you want to extract closed captions, VITC timecode, or other metadata, do NOT mask those lines. Place observer stages (like Closed Caption Sink) before the Mask Line stage in your pipeline, or don't mask the lines they need.

### When to use this
- Remove visible VBI lines (timecode, teletext, etc.) from final video
- Hide closed caption data (line 20/21) that shows as white dots on some displays
- Clean up the top and bottom of video frames
- Remove test signals or other unwanted line data

### When NOT to use this
- If you need to extract closed captions - masking line 20 will prevent caption extraction
- If you're using VITC timecode - don't mask lines 6-22
- If you need any VBI metadata - observers read from the stage output and won't see masked lines

### Parameters

Use the **Config Tool** button (easier) or enter line ranges manually:

- **Field Ranges**
  - Specify which lines to mask using format: `F:start-end,start-end;S:start-end`
  - `F:` = first field, `S:` = second field
  - Line numbers are 0-based (line 21 in specs = line 20 in this format)
  - Examples:
    - `F:20` - Mask NTSC closed caption line (first field only)
    - `F:10-20,S:10-20` - Mask NTSC VBI area (both fields)
    - `F:20-21,S:20-21` - Mask PAL teletext/WSS (both fields)
  - Default: `""` (no masking)
  - Required: No

- **IRE Level**
  - The brightness level to use for masked lines. 0 = black (recommended). Higher values make masked lines gray instead of black.
  - Range: 0.0 (black) to 110.0 (white)
  - Default: `0.0` (black)
  - Required: No

### Using the Config Dialog

Click the **Config Tool** button to use the easy preset dialog:

**NTSC Presets:**
- **None** - No masking (pass through)
- **Closed Captions** - Masks line 20 (first field only) to hide CC data
- **VBI Area** - Masks lines 10-20 on both fields to remove all visible VBI

**Custom Ranges:**
- Add your own line ranges for first and second fields
- Useful for masking specific test signals or other data

**⚠️ Remember:** If you enable CC or VBI masking, observers won't be able to extract that data!

## Video Parameters

Advanced controls for overriding video timing and geometry parameters. Normally these are detected automatically from your TBC file, but sometimes they're wrong or need adjustment for special processing needs.

**Most users don't need this!** Only use if you know the auto-detected parameters are incorrect, or you have specific technical requirements.

### When to use this
- The auto-detected video parameters are clearly wrong
- You want to crop or adjust the active video area
- Testing different parameter configurations
- Working with unusual or non-standard video sources

### Parameters

All parameters default to -1, which means "use the value from the source file." Only change values you specifically need to override.

- **Field Width**
  - Override the width of each field in samples. -1 uses the source file's value. Only change if you know the detected width is wrong.
  - Range: -1 to 10000
  - Default: `-1` (auto)
  - Required: No

- **Field Height**
  - Override the height of each field in lines. -1 uses the source file's value. Only change if you know the detected height is wrong.
  - Range: -1 to 1200
  - Default: `-1` (auto)
  - Required: No

- **Colour Burst Start**
  - Sample position where the color burst begins. Used by the chroma decoder. -1 = auto detect. Advanced users only.
  - Range: -1 to 10000
  - Default: `-1` (auto)
  - Required: No

- **Colour Burst End**
  - Sample position where the color burst ends. Used by the chroma decoder. -1 = auto detect. Advanced users only.
  - Range: -1 to 10000
  - Default: `-1` (auto)
  - Required: No

- **Active Video Start**
  - Sample position where active video begins (excluding horizontal blanking). Affects cropping. -1 = auto detect.
  - Range: -1 to 10000
  - Default: `-1` (auto)
  - Required: No

- **Active Video End**
  - Sample position where active video ends (excluding horizontal blanking). Affects cropping. -1 = auto detect.
  - Range: -1 to 10000
  - Default: `-1` (auto)
  - Required: No

## Field Invert

Swaps the field order (top/bottom fields). Use this if your video looks slightly "combed" or has incorrect interlacing, which usually means the field order was detected backwards.

**Quick test:** If your output video has a "venetian blind" effect or horizontal combing in motion, try adding this stage.

### When to use this
- Interlaced video shows combing artifacts or looks wrong
- Field order was auto-detected incorrectly
- You need to deliberately reverse field order for testing

### Parameters

*This stage has no parameters - it simply swaps field order.*

---

# Sink Stages

Sink stages are your final output - they save your processed video and data to disk. Add these at the end of your pipeline and click their "trigger" button when you're ready to export.

## Raw Video Sink

Exports your processed video to uncompressed RGB, YUV, or Y4M format. These files are huge but lossless - perfect for archival or if you want to compress with your own tools later.

### Parameters

- **Output Path**
  - Where to save your decoded video file. Choose `.rgb` for RGB format, `.yuv` for YUV, or `.y4m` for YUV with headers (recommended for compatibility with other tools).
  - File Extensions: `.rgb`, `.yuv`, `.y4m`
  - Required: No

- **Decoder Type**
  - Which chroma decoder to use. "Auto" picks the best one automatically. Try different decoders if colors don't look right.
  - PAL options: auto (recommended), pal2d, transform2d (best quality), transform3d, mono (black & white)
  - NTSC options: auto (recommended), ntsc1d, ntsc2d (balanced), ntsc3d (best quality), ntsc3dnoadapt, mono (black & white)
  - Required: No

- **Output Format**
  - Choose your output format. Y4M is recommended - it includes headers that other tools understand. RGB is good for compatibility, YUV for smaller files.
  - Options: rgb (RGB48 - universal compatibility), yuv (YUV444P16 - smaller), y4m (YUV with headers - best choice)
  - Required: No

- **Chroma Gain**
  - Color saturation control. 1.0 = normal. Higher = more saturated colors. Lower = less saturated (toward black and white). Use this to fix washed-out or oversaturated colors.
  - Range: 0.0 (no color) to 10.0 (extreme)
  - Default: `1.0` (normal)
  - Required: No

- **Chroma Phase**
  - Rotates the color phase. Use this if colors are wrong (like green faces or purple grass). Usually 0 is correct, but some discs need adjustment. Try small adjustments like +/- 10 degrees if colors look off.
  - Range: -180° to 180°
  - Default: `0.0°`
  - Required: No

- **Luma Noise Reduction**
  - Reduces brightness noise/grain. 0 = off. Higher values = smoother but might lose fine detail. Try 1-3 for noisy sources.
  - Range: 0.0 (off) to 10.0 (maximum)
  - Default: `0.0` (off)
  - Required: No

- **Chroma Noise Reduction**
  - Reduces color noise (NTSC only). 0 = off. Higher values = smoother colors but might blur fine color detail. Try 1-3 for noisy sources.
  - Range: 0.0 (off) to 10.0 (maximum)
  - Default: `0.0` (off)
  - Required: No

- **Output Padding**
  - Pads output dimensions to multiples of this value. 8 ensures compatibility with most video encoders. Change only if you have specific requirements.
  - Range: 1-32 pixels
  - Default: `8`
  - Required: No

- **NTSC Phase Compensation** (NTSC only)
  - Adjusts color phase line-by-line for better NTSC decoding. Usually improves quality slightly. Leave ON unless it causes problems.
  - Default: `false` (OFF)
  - Required: No

- **Simple PAL** (PAL only)
  - Faster but lower quality PAL decoding. Turn ON for quick previews, OFF for final output. Most users should leave this OFF.
  - Default: `false` (OFF - high quality)
  - Required: No

## FFmpeg Video Sink

Exports your video to compressed formats with support for ~40 different codecs and containers. Much smaller files than Raw Video Sink with optional audio and closed captions. Perfect for final delivery, archival, professional editing, or web streaming.

**Requires FFmpeg libraries to be installed.**

### Quick Start: Use the Config Tool!

Click the **Config Tool** button to access the preset dialog - it's much easier than setting parameters manually! The dialog provides:

- **Organized Categories**: Lossless/Archive, Professional/ProRes, Uncompressed, Broadcast, Universal (H.264), Modern (H.265/AV1), Hardware Accelerated
- **Preset Profiles**: Based on the legacy tbc-video-export tool with detailed descriptions
- **Hardware Detection**: Automatically finds NVIDIA NVENC, Intel QuickSync, AMD AMF, Apple VideoToolbox encoders
- **Guided Configuration**: Each preset explains when to use it and what settings it applies

**Popular Presets:**
- **FFV1 Lossless (MKV)** - Perfect for archival, mathematically lossless, large files
- **ProRes 422 HQ** - Professional editing workflows (Final Cut Pro, DaVinci Resolve, Premiere)
- **H.264 High Quality** - Universal playback on all devices, excellent quality/size balance
- **H.265/HEVC** - 50% better compression than H.264, requires modern players
- **AV1** - Modern codec for web delivery, best compression
- **Hardware Accelerated** - Use your GPU for much faster encoding

### Supported Formats

**Lossless/Archive:**
- `mkv-ffv1` - FFV1 lossless compression
- `mp4-h264_lossless`, `mp4-hevc_lossless`, `mp4-av1_lossless` - Lossless variants

**Professional/ProRes:**
- `mov-prores` - ProRes 422 HQ (standard)
- `mov-prores_4444`, `mov-prores_4444xq` - ProRes with alpha/highest quality
- `mov-prores_videotoolbox` - Apple hardware accelerated

**Uncompressed:**
- `mov-v210` - 10-bit 4:2:2 uncompressed (massive files, zero loss)
- `mov-v410` - 10-bit 4:4:4 uncompressed (even larger)

**Broadcast:**
- `mxf-mpeg2video` - D10/IMX/XDCAM for broadcast delivery

**Universal (H.264):**
- `mp4-h264` - Standard H.264 in MP4
- `mov-h264` - H.264 in QuickTime MOV
- Hardware: `mp4-h264_vaapi`, `mp4-h264_nvenc`, `mp4-h264_qsv`, `mp4-h264_amf`, `mp4-h264_videotoolbox`

**Modern (H.265/HEVC):**
- `mp4-hevc`, `mov-hevc` - Better compression than H.264
- Hardware: `mp4-hevc_vaapi`, `mp4-hevc_nvenc`, `mp4-hevc_qsv`, `mp4-hevc_amf`, `mp4-hevc_videotoolbox`

**AV1:**
- `mp4-av1` - Modern royalty-free codec, best compression

### Parameters

Includes all parameters from Raw Video Sink, plus these encoding options:

- **Output Path**
  - Where to save your video file.
  - File Extensions: `.mp4`, `.mkv`, `.mov`, `.mxf`
  - Required: No

- **Decoder Type**
  - Same as Raw Video Sink - which chroma decoder to use.
  - Required: No

- **Output Format**
  - Choose your container and codec. **USE THE CONFIG TOOL** instead of selecting manually! The preset dialog makes this much easier.
  - See "Supported Formats" above for the full list of ~40 options.
  - Required: No

- **Encoder Preset**
  - Speed vs quality tradeoff. "Fast" = quick encoding, slightly larger files. "Slow" or "Veryslow" = slower encoding, smaller files, better quality. "Medium" is a good balance.
  - Options: fast, medium (recommended), slow, veryslow
  - Required: No

- **Encoder CRF**
  - Quality level: lower = better quality but bigger file. 18 = visually lossless (recommended for archival). 23 = high quality. 28 = smaller file, some visible quality loss. Set to 0 to use bitrate instead.
  - Range: 0-51 (0 = auto from preset)
  - Default: `18` (visually lossless)
  - Required: No

- **Encoder Bitrate**
  - Target bitrate in bits/sec. 0 = use CRF mode (recommended for most users). Only set this if you have specific delivery requirements that demand a fixed bitrate.
  - Range: 0-500000000 (0 = use CRF)
  - Default: `0` (CRF mode)
  - Required: No

- **Embed Audio**
  - Include analogue audio tracks in the output file (if audio is available in your source). Audio codec is automatically selected based on video codec: AAC for H.264/H.265/AV1, FLAC for FFV1, PCM for ProRes/V210/V410/D10.
  - Default: `false` (no audio)
  - Required: No

- **Embed Closed Captions**
  - Convert EIA-608 closed captions to subtitle track (MP4/MOV only). Captions are converted to mov_text format that video players can display.
  - Default: `false` (no captions)
  - Required: No

Plus all the color/quality parameters from Raw Video Sink (Chroma Gain, Chroma Phase, Luma NR, Chroma NR, etc.)

### Audio Codecs (Auto-Selected)

The appropriate audio codec is automatically chosen based on your video format:
- **AAC** (320 Kbps, 48kHz) - H.264, H.265, AV1
- **FLAC** (lossless) - FFV1
- **PCM S24LE** (uncompressed 24-bit) - ProRes, V210, V410, D10

### Hardware Acceleration

**Supported Hardware Encoders:**
- **NVIDIA NVENC** - Fast H.264/H.265 encoding on NVIDIA GPUs
- **Intel QuickSync** - Fast encoding on Intel CPUs with integrated graphics
- **AMD AMF** - Fast encoding on AMD GPUs
- **Apple VideoToolbox** - Hardware acceleration on macOS (M1/M2/M3 and recent Intel Macs)
- **VA-API** - Linux hardware acceleration (Intel/AMD)

Use the Config Tool dialog to automatically detect and configure hardware encoders!

**Requires FFmpeg libraries to be installed.**

### Parameters

Includes all parameters from Raw Video Sink, plus these encoding options:

- **Output Format**
  - Choose your container and codec. MP4 with H.264 for maximum compatibility (plays everywhere). MKV with FFV1 for lossless archival (huge but perfect quality).
  - Options: mp4-h264 (universal playback), mkv-ffv1 (lossless archival)
  - Required: No

- **Encoder Preset**
  - Speed vs quality tradeoff. "Fast" = quick encoding, slightly larger files. "Slow" or "Veryslow" = slower encoding, smaller files, better quality. "Medium" is a good balance.
  - Options: fast, medium (recommended), slow, veryslow
  - Required: No

- **Encoder CRF**
  - Quality level: lower = better quality but bigger file. 18 = visually lossless (recommended for archival). 23 = high quality. 28 = smaller file, some visible quality loss. Set to 0 to use bitrate instead.
  - Range: 0-51 (lower = better)
  - Default: `18` (excellent quality)
  - Required: No

- **Encoder Bitrate**
  - Target bitrate in bits per second. 0 means use CRF instead (recommended). If you set this, CRF is ignored. Example: 10000000 = 10 Mbps.
  - Range: 0-100000000
  - Default: `0` (use CRF)
  - Required: No

- **Embed Analogue Audio**
  - Include audio in the video file (if you loaded a .pcm audio file in your source). Makes a complete video+audio file. Turn this ON if you want audio in your output.
  - Default: `false` (OFF - video only)
  - Required: No

- **Embed Closed Captions**
  - Include any closed captions as text subtitles in the MP4 file. Only works with MP4 format. Turn ON if your LaserDisc has captions and you want to preserve them.
  - Default: `false` (OFF - no captions)
  - Required: No

## ld-decode Sink

Saves your processed video back to TBC format. Use this if you've improved your capture (by stacking or dropout correction) and want to save the improved TBC for use with other ld-decode tools.

**When to use:** After stacking or heavy processing, to create an improved TBC file that you can use with legacy ld-decode tools.

### Parameters

- **TBC Output Path**
  - Where to save the TBC file. The metadata will automatically be saved to a `.tbc.db` file in the same location.
  - File Extension: `.tbc`
  - Required: No

## Analogue Audio Sink

Exports the analogue audio to a standard WAV file (if your source included a .pcm audio file). Creates a stereo WAV file at 44.1kHz that you can play in any audio player or import into video editing software.

### Parameters

- **Output WAV File**
  - Where to save the audio file as a standard WAV.
  - File Extension: `.wav`
  - Required: Yes

## Closed Caption Sink

Extracts and exports any closed captions from your LaserDisc. Can save as SCC format (for professional captioning tools) or plain text (human-readable).

**Note:** Only works if your LaserDisc actually has embedded closed captions.

### Parameters

- **Output File**
  - Where to save the caption file.
  - Required: Yes

- **Export Format**
  - SCC: Industry standard format for professional tools and subtitle editors
  - Plain Text: Easy to read format showing what's being said and when
  - Options: Scenarist SCC (professional), Plain Text (human-readable)
  - Default: `Scenarist SCC`
  - Required: Yes

## EFM Data Sink

Exports digital audio data (EFM) from LaserDiscs that have digital soundtracks. This is the raw digital data that can be decoded into CD-quality audio.

**Advanced users only:** Most people should use the analogue audio instead. This is for archiving the raw digital data stream.

### Parameters

- **Output EFM File**
  - Where to save the raw EFM data (binary format, will need special tools to decode).
  - File Extension: `.efm`
  - Required: Yes