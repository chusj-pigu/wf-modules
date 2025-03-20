#!/usr/bin/env Rscript

# Load required packages
suppressMessages(library(argparse))
suppressMessages(library(GenomicFeatures))
suppressMessages(library(GenomicRanges))
suppressMessages(library(rtracklayer))

# Set up argument parser
parser <- ArgumentParser(
	description = "Extract introns from a GTF file and export them as GFF3"
	)

parser$add_argument(
	"input_gtf",
	type = "character",
	help = "Path to the input GTF file (e.g., hg38.ncbiRefSeq.gtf.gz)"
	)

# Parse arguments
args <- parser$parse_args()

# Load GTF file and extract introns
message("Loading GTF file: ", args$input_gtf)
txdb <- makeTxDbFromGFF(args$input_gtf)

message("Extracting introns...")
introns <- intronsByTranscript(txdb)

output_gff <- gsub(".gtf.gz", ".introns.gff", args$input_gtf)

# Export to GFF3 format
message("Exporting introns to: ", args$output_gff)
export(introns, args$output_gff, format = "gff3")

message("Done! Introns saved to: ", args$output_gff)
