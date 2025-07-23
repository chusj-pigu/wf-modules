#!/bin/bash

# Usage: ./generate_all_configs_parallel.sh fusion_list.txt input.bam input.vcf [--jobs N]

set -euo pipefail

if [[ $# -lt 3 ]]; then
    echo "Usage: $0 <fusion_list.txt> <input.bam> <input.vcf> [--jobs N]"
    exit 1
fi

fusion_list="$1"
bam="$2"
vcf="$3"
jobs="${4:---jobs 20}"  # Default to 20 jobs

SCRIPT_DIR="$(dirname "$0")"
GENERATOR_SCRIPT="/opt/scripts/fusion.sh"

if [[ ! -x "$GENERATOR_SCRIPT" ]]; then
    echo "Error: $GENERATOR_SCRIPT not found or not executable"
    exit 1
fi

# Create temp command list
cmd_file=$(mktemp)

# Parse fusion list into generator commands
while read -r line; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    read -r name region1 region2 <<< "$line"

    # Prepare extra regions array
    extra_regions=()
    for r in $line; do
        [[ "$r" == "$name" ]] && continue
        extra_regions+=("$r")
    done

    # Compose the command string
    quoted_regions=$(printf " '%s'" "${extra_regions[@]}")
    echo "\"$GENERATOR_SCRIPT\" \"$name\" \"$bam\" \"$vcf\" $quoted_regions" >> "$cmd_file"
done < "$fusion_list"

echo "Launching parallel jobs..."
parallel --eta --jobs "${jobs#--jobs }" < "$cmd_file"

rm -f "$cmd_file"
echo "All jobs complete."
