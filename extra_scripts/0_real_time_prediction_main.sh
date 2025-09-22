#!/bin/bash

# Default reference
REF="hg19"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --ref)
            REF="$2"
            shift 2
            ;;
        *)
            echo "Unknown argument: $1"
            echo "Usage: $0 [--ref hg19|hg38]"
            exit 1
            ;;
    esac
done

# Run inside calls.sort.bam folder
SCRIPT_DIR=$(dirname "$0")
echo "Script dir: $SCRIPT_DIR"
echo "Reference genome: $REF"

# Decide which processing script to use
if [[ "$REF" == "hg38" ]]; then
    PROCESS_SCRIPT="$SCRIPT_DIR/1_process_live_hg38.sh"
else
    PROCESS_SCRIPT="$SCRIPT_DIR/1_process_live.sh"
fi

# Check for new bam/pdf files every 5 seconds
while true; do
    ls -1 | grep ".bam$\|.pred.pdf$" \
      | sed 's/.pred.pdf$//' \
      | uniq -c \
      | awk '{if($1==1){print $2}}' \
      | xargs -I {} bash "$PROCESS_SCRIPT" {}
    echo "$(date): Waiting for new files"
    sleep 5
done
