#!/bin/bash

set -euo pipefail

# --- Default values ---
jobs="--jobs 20"

# --- Parse parameters ---
while [[ $# -gt 0 ]]; do
    case "$1" in
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
            if [[ -z "${prefix:-}" ]]; then
                prefix="$1"
            elif [[ -z "${cov:-}" ]]; then
                cov="$1"
            elif [[ -z "${bed:-}" ]]; then
                bed="$1"
            else
                echo "Unexpected argument: $1"
                exit 1
            fi
            shift
            ;;
    esac
done

# --- Check required parameters ---
if [[ -z "${prefix:-}" || -z "${cov:-}" || -z "${bed:-}" ]]; then
    echo "Usage: $0 <prefix> <delly.cov.gz> <segs.bed> [--jobs N]"
    exit 1
fi

GENERATOR_SCRIPT="/opt/scripts/chr_delly.sh"

if [[ ! -x "$GENERATOR_SCRIPT" ]]; then
    echo "Error: $GENERATOR_SCRIPT not found or not executable"
    exit 1
fi

# --- Chromosome list ---
chromosomes=( $(seq 1 22) X )

cmd_file=$(mktemp)

# --- Build commands ---
for chr in "${chromosomes[@]}"; do
    region="chr${chr}"
    echo "\"$GENERATOR_SCRIPT\" \"$prefix\" \"$cov\" \"$bed\" \"$region\"" >> "$cmd_file"
done

echo "Launching parallel jobs with $jobs..."
parallel --eta $jobs < "$cmd_file"

rm -f "$cmd_file"
echo "All jobs complete."
