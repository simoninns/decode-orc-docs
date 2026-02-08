# Concepts

## DAG Chain
Decode Orc takes a new approach compared to the legacy ld-decode-tools. The ld-decode-tools consisted of loosely coupled utilities that passed video field data and metadata between individual executables. Processing order was implicit rather than enforced, and metadata content varied depending on which tools had been run on the video and metadata.

Decode Orc is an orchestrator that manages the processing of video data using a DAG (Directed Acyclic Graph). A DAG is a set of linked nodes with a strictly non-repeating execution path (i.e. it contains no cycles).

Within the chain, video fields are the atomic, navigable units—the smallest individual pieces of data handled by the system. These units are represented using a VFR (Video Field Representation). VFRs are passed between stages as they move through the DAG.

## Stages
In Decode Orc, the DAG is composed of *stages*. Each stage provides a specific function or transformation within the processing pipeline. There are three distinct types of stages:

### Source Stages
Source stages ingest data from outside Decode Orc. For example, the LDPALsink stage ingests TBC video data, SQLite metadata, and additional files produced by ld-decode, such as PCM audio and EFM data.

A **source** represents incoming decoded data. Examples include:

* LaserDisc captures
* Tape-based sources (e.g. VHS)

Sources define *where the data comes from* (ld-decode, vhs-decode, etc.), not how it is processed.

### Video Formats

Each source has an underlying **video format**, such as:

* PAL/PAL-M
* NTSC

The key architectural assumption is that:

* The *video format and framing* remain consistent across sources of the same format
* Differences between source types are primarily expressed by the associated ingress **metadata**

Examples:

* CLV vs CAV LaserDiscs differ mainly in timecode metadata, not video structure
* VHS may provide split luma/chroma TBC files, but the underlying format (PAL/NTSC) is unchanged

This separation allows new source types to be added without redefining the entire processing pipeline.

#### Hints
Hints are collections of information provided by the ingested source that cannot be recreated solely by observing the VFR. Examples include field dimensions or more complex data such as dropouts, which ld-decode derives from RF data prior to demodulation (and therefore cannot be recreated from the TBC video data alone).

Although hints cannot be recreated through observation, they can be extended or overridden. Dropouts are a good example: original dropout hints may be supplemented or refined by later stages.

Because hints originate from ingested data, only source stages can generate them. Hints are carried within the VFR and propagate through the DAG chain.

Since the decoder stage (ld-decode, vhs-decode, etc.) has access to information that is not preserved in the TBC file the decoder provides information that cannot be observed.

Such information is termed "hints" and Decode Orc provides a specific mechanism for propagating such information through the DAG chain.

Examples of hints are dropout, field parity (as half-lines are not represented in TBCs) and PAL field phase.

#### Observers
Observers are processes that operate on the output of a source or transform stage. They generate observations such as black-and-white SNR, burst quality metrics, VBI data, and similar measurements.  Sink stages do not have observers as they do not output VFR.  Observers do not modify data; they *inspect* it.

Each stage provides its own set of observers, as the observable characteristics of a VFR may change as it progresses through the DAG chain. For example, stacking or corrective processing can improve signal quality, leading to improved VBI decoding and higher SNR. Observers allow the state and quality of a VFR to be quantified at any point in the chain.

Observers extract metadata from video signals without modifying them. They observe the signal directly to generate metadata (Note this is *not* ingress metadata from the decoder source).

Note: Certain data like dropout information cannot be observed after-the-fact (since it is generated from data no longer present in the TBC output (such as the original RF sample)). Such data is treated as "hints" through a separate mechanism.

Observers:

* Monitor stage outputs
* Extract metadata from the stage outputs
* Operate statelessly - all context comes from the video field and observation history

Implemented observers include:
* **Biphase observers**: Decode biphase-encoded data from VBI lines
* **VITC observers**: Extract VITC (Vertical Interval Timecode) information
* **Closed caption observers**: Extract closed caption data from line 21
* **Video ID observers**: Decode Video ID information
* **FM code observers**: Extract FM code information
* **White flag observers**: Detect white flag presence in VBI
* **VITS observers**: Extract VITS test signal quality metrics
* **Burst level observers**: Measure color burst amplitude levels

### Transform Stages
Transform stages modify the VFR in some way, either by altering the video data itself or by updating auxiliary information stored within the VFR.  Transform stages can also operate on hints (either by reacting to them or adding additional information to them).

### Sink Stages
Sink stages are responsible for exporting one or more components of the VFR to external formats. Examples include raw RGB video (similar to the ld-decode-tools ld-chroma-decoder), ffmpeg-generated MP4 files, WAV audio, subtitle files, and similar outputs.

## Input and output from a stage
A stage can have a ONE input or a MANY input.  Similarly, the output can also be ONE or MANY.  A ONE input or output contains only one VFR - a MANY input or output can contain one or more VFRs.

For example, a field map transform stage is one-to-one - a VFR comes in, is mapped and is output.  A stacking stage is MANY to ONE - many VFRs come in and are stacked into a single VFR output (and so on).

Each stage has 2 connecting nodes (one each for input and output).  A ONE node is represented by a circle and a MANY node is represented by a 2 concentric circles.

Stages fall into structural categories:
* **Output only**: sources (-decode ingress)
* **Input only**: sinks (egress)
* **One-to-one**: simple transforms
* **One-to-many**: splitters
* **Many-to-one**: mergers
* **Many-to-many**: complex transforms

## Stage output fan-out
If a stage has a ONE output it also supports "fan-out" - fan-out allows you to connect many stages to the output of the stage and each connected stage receieves a copy of the same VFR.  An example would be that you have a source stage and you want to sink it to several different sink stages (such as video, audio and subtitles) - the source can fan-out to multiple sinks.