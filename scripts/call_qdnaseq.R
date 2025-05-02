#!/usr/bin/env Rscript

# Script to call CNVs (Copy Number Variants) using QDNAseq
# Inspired by epi2me-labs wf-human-variation
# (https://github.com/epi2me-labs/wf-human-variation)

# Load required libraries quietly
suppressPackageStartupMessages({
  library(optparse) # For command-line argument parsing
  library(QDNAseq) # Main library for CNV analysis
})

# ---- Define command-line options ----
option_list <- list(
  make_option(c("-b", "--bam"),
    type = "character", default = NULL,
    help = paste(
      "Path to the input BAM file.",
      "[required]",
      sep = "\n"
    ),
    metavar = "FILE"
  ),
  make_option(c("--prefix"),
    type = "character", default = NULL,
    help = paste(
      "Prefix for output files.",
      "[required]",
      sep = "\n"
    ),
    metavar = "STRING"
  ),
  make_option(c("--binsize"),
    type = "integer", default = 500,
    help = paste(
      "Bin size in kilobases for CNV detection.",
      "e.g., 500 = 500kb",
      "[default: %default]",
      sep = "\n"
    ),
    metavar = "NUMBER"
  ),
  make_option(c("-r", "--reference"),
    type = "character", default = NULL,
    help = paste(
      "Reference genome to use for bin annotation.",
      "Supported values: hg38 or hg19.",
      "[required]",
      sep = "\n"
    ),
    metavar = "STRING"
  )
)

# Parse command-line arguments
opt <- parse_args(OptionParser(option_list = option_list))

# ---- Load genome-specific bin annotations ----
# These annotations include GC content and mappability scores per bin
if (opt$reference == "hg38" || opt$reference == "GRCh38") {
  library(QDNAseq.hg38)
  bins <- getBinAnnotations(binSize = opt$binsize, genome = "hg38")
} else if (opt$reference == "hg19" || opt$reference == "GRCh37") {
  library(QDNAseq.hg19)
  bins <- getBinAnnotations(binSize = opt$binsize, genome = "hg19")
} else {
  stop("Unsupported reference genome. Please specify 'hg19' or 'hg38'.")
}

# ---- PRIMARY ANALYSIS ----

# Read BAM file and count reads in each bin
read_counts <- binReadCounts(bins, bamfiles = opt$bam)

# Export raw binned read counts to BED format for debugging or visualization
bed_raw <- paste(opt$prefix, "raw_bins.bed", sep = "_")
exportBins(read_counts, file = bed_raw, format = "bed", type = "copynumber")

# Apply filters:
# - residual: filters based on variance from expected coverage
# - blacklist: removes regions with known artifacts
filt_read_counts <- applyFilters(read_counts, residual = TRUE, blacklist = TRUE)

# Estimate and apply correction for GC content and mappability bias
filt_read_counts <- estimateCorrection(filt_read_counts)

# Apply filters again, this time removing bins from nonstandard chromosomes
filt_read_counts <- applyFilters(filt_read_counts, chromosomes = NA)

# Apply bias correction to read counts
copy_number <- correctBins(filt_read_counts)

# Normalize corrected read counts to the median across genome
copy_number <- normalizeBins(copy_number)

# Smooth outlier bins to reduce false positives
copy_number <- smoothOutlierBins(copy_number)

# Export processed bins to BED format
bed_norm <- paste(opt$prefix, "bins.bed", sep = "_")
exportBins(copy_number, file = bed_norm, format = "bed")

# ---- SECONDARY ANALYSIS ----

# Segment the genome into regions of equal copy number using a transformation
cn_seg <- segmentBins(copy_number, transformFun = "sqrt")

# Normalize the segmented bins
cn_seg <- normalizeSegmentedBins(cn_seg)

# Set log2 cutoffs for detecting CNV types
cutoff_del <- 0.5
cutoff_loss <- 1.5 # Loss: between 0.5–1.5
cutoff_gain <- 2.5 # Gain: between 2–10
# Amplification cutoff is set at 10

# Call copy number states based on hard cutoffs
cn_called <- callBins(
  cn_seg,
  method = "cutoff",
  cutoffs = log2(c(
    deletion = cutoff_del,
    loss = cutoff_loss,
    gain = cutoff_gain,
    amplification = 10
  ) / 2)
)

# ---- GENERATE PLOTS ----

# Coverage profile plot
png(paste(opt$prefix, "cov.png", sep = "_"), width = 1800, height = 400)
plot(cn_called)
dev.off()

# Noise diagnostic plot — helps assess signal quality
png(paste(opt$prefix, "noise_plot.png", sep = "_"), width = 1800, height = 400)
noisePlot(filt_read_counts)
dev.off()

# Isobar plot — plots bias correction effects
png(paste(opt$prefix, "isobar_plot.png", sep = "_"), width = 1800, height = 400)
isobarPlot(filt_read_counts)
dev.off()

# ---- EXPORT CNV RESULTS ----

# Export CNV calls (deletions/gains) to multiple formats

# BED format
exportBins(
  cn_called,
  file = paste(
    opt$prefix,
    "calls.bed",
    sep = "_"
  ),
  format = "bed",
  type = "calls"
)

# VCF format — standard format for genomic variant annotations
exportBins(
  cn_called,
  file = paste(
    opt$prefix,
    "calls.vcf",
    sep = "_"
  ),
  format = "vcf",
  type = "calls"
)

# SEG format — used for copy number tools (e.g., IGV)
exportBins(
  cn_called,
  file = paste(
    opt$prefix,
    "segs.seg",
    sep = "_"
  ),
  format = "seg",
  type = "segments"
)

# Also export segmentation results to BED and VCF
exportBins(
  cn_called,
  file = paste(
    opt$prefix,
    "segs.bed",
    sep = "_"
  ),
  format = "bed",
  type = "segments"
)
exportBins(
  cn_called,
  file = paste(
    opt$prefix,
    "segs.vcf",
    sep = "_"
  ),
  format = "vcf",
  type = "segments"
)

# # ---- EXPORT FREEC-COMPATIBLE FILES ----
