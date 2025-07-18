#!/bin/bash

# Usage: ./generate_all_configs.sh fusion_list.txt /path/to/bam.bam /path/to/vcf.vcf

set -euo pipefail

if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <fusion_list.txt> <input.bam> <input.vcf>"
    exit 1
fi

fusion_list="$1"
bam="$2"
vcf="$3"

# Path to the JSON generator script
SCRIPT_DIR="$(dirname "$0")"
GENERATOR_SCRIPT="/opt/scripts/fusion2.sh"

if [[ ! -x "$GENERATOR_SCRIPT" ]]; then
    echo "Error: $GENERATOR_SCRIPT not found or not executable"
    exit 1
fi

while read -r line; do
    # Skip empty or comment lines
    [[ -z "$line" || "$line" == \#* ]] && continue

    # Split line into words
    read -r name region1 region2 <<< "$line"

    # Optional: support more than 2 regions
    extra_regions=()
    for r in $line; do
        [[ "$r" == "$name" ]] && continue
        extra_regions+=("$r")
    done

    output="${name}"

    echo "Generating figure for ${name}..."
    "$GENERATOR_SCRIPT" "$output" "$bam" "$vcf" "${extra_regions[@]}"
done < "$fusion_list"
