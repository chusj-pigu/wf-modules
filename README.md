# wf-modules (`mpgi-rusttools` branch)

Reusable Nextflow DSL2 module processes for Rust-based genomics tools.

## Available Processes

- `GFF_TO_GTF`: Convert GFF3 annotations to GTF via `genemancer gff-to-gtf`.
- `MERGE_BAM`: Merge multiple sorted BAMs and write an index via `genemancer merge-bam --index`.
- `SPLIT_BAM`: Split a BAM into BED-defined regional BAM outputs via `genemancer split-bam`.
- `CALL_TARGETS`: Call SNVs on target regions via `genemancer call-targets`.
- `CALL_TARGETS_GPU`: GPU-enabled `call-targets` path with automatic backend selection.
- `NANOCOV`: Single-sample coverage metrics and plots from one BAM via `nanocov --input`.
- `NANOCOV_BATCH`: Batch coverage processing via `nanocov --batch-tsv`.

## Container Tooling

Current Docker build installs:

- `genemancer` `0.2.2`
- `nanocov` `0.1.0`

Dockerfile: [`docker/Dockerfile`](docker/Dockerfile)
Pipeline modules: [`main.nf`](main.nf)

## CI/CD
