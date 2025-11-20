#!/bin/bash

# Usage:
#   ./multifuse.sh --type fusion fusion_list.txt input.bam input.vcf [--jobs N]
#   ./multifuse.sh --type other_sv region_list.txt input.bam input.vcf

set -eo pipefail

# --- Default values ---
jobs="--jobs 20"
type=""

# --- Parse parameters ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        --type)
            type="$2"
            shift 2
            ;;
        --jobs)
            jobs="--jobs $2"
            shift 2
            ;;
        -*)
            echo "Unknown option: $1"
            exit 1
            ;;
        *)
            # Positional arguments
            if [[ -z "${listfile:-}" ]]; then
                listfile="$1"
            elif [[ -z "${bam:-}" ]]; then
                bam="$1"
            elif [[ -z "${vcf:-}" ]]; then
                vcf="$1"
            else
                echo "Unexpected argument: $1"
                exit 1
            fi
            shift
            ;;
    esac
done

if [[ -z "$type" || -z "${listfile:-}" || -z "${bam:-}" || -z "${vcf:-}" ]]; then
    echo "Usage: $0 --type {fusion|other_sv} <listfile.txt> <input.bam> <input.vcf> [--jobs N]"
    exit 1
fi

# --- Select generator script ---
SCRIPT_DIR="$(dirname "$0")"
case "$type" in
    fusion)    GENERATOR_SCRIPT="/opt/scripts/fusion.sh" ;;
    other_sv) GENERATOR_SCRIPT="/opt/scripts/other_sv.sh" ;;
    ts_gene_cov) GENERATOR_SCRIPT="/opt/scripts/ts_gene_cov.sh" ;;
    gene_cov) GENERATOR_SCRIPT="/opt/scripts/gene_cov.sh" ;;
    *) echo "Error: unknown type '$type' (must be fusion, other_sv, ts_gene_cov, or gene_cov)"; exit 1 ;;
esac

if [[ ! -x "$GENERATOR_SCRIPT" ]]; then
    echo "Error: $GENERATOR_SCRIPT not found or not executable"
    exit 1
fi

# --- Build commands for GNU parallel ---
cmd_file=$(mktemp)

while read -r line; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    read -r name region1 region2 <<< "$line"

    # Extra regions
    extra_regions=()
    for r in $line; do
        [[ "$r" == "$name" ]] && continue
        extra_regions+=("$r")
    done

    quoted_regions=$(printf " '%s'" "${extra_regions[@]}")
    echo "→ $GENERATOR_SCRIPT \"$name\" \"$bam\" \"$vcf\"${quoted_regions}"  
    
    echo "\"$GENERATOR_SCRIPT\" \"$name\" \"$bam\" \"$vcf\" $quoted_regions" >> "$cmd_file"
done < "$listfile"

echo "Launching parallel jobs with $jobs..."
parallel --eta $jobs < "$cmd_file"

rm -f "$cmd_file"
echo "All jobs complete."
