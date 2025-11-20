#!/bin/bash

# Usage: ./chr_delly.sh <delly.cov.gz> <delly_segs.bed> <chrN>

set -euo pipefail

if [[ $# -ne 4 ]]; then
    echo "Usage: $0 <prefix> <delly.cov> <delly_segs.bed> <chrN>"
    exit 1
fi

prefix="$1"
cov="$2"
bed="$3"
chr="$4"


# Output file prefix
output="${prefix}_${chr}"

cat > "${output}.conf" <<EOF
{
  "general": {
        "layout": "stacked",
        "reference": "hg38"
  },
  "output": {
        "file": "${output}.png",
        "dpi": 600,
        "width": 1200
  },
  "regions": [
        {"chr": "${chr}"}
  ],
  "tracks": [
    {
        "type": "copynumber",
        "height": 100,
        "margin_above": 0,
        "bounding_box": true,
        "fontscale": 5,
        "label": "",
        "label_rotate": false,
        "delly_cn": "${cov}",
        "delly_CNAs": "${bed}",
        "min_cn": "",
        "max_cn": 3.9,
        "grid": true,
        "marker_size": 5,
        "grid_major": false,
        "grid_minor": false,
        "grid_cn": true,
        "color_normal": "#000000",
        "color_loss": "#4a69bd",
        "color_gain": "#e55039",
        "color_cnloh": "#f6b93b",
        "genes": ""
    },
    {
        "type": "chr_axis",
        "height": 40,
        "margin_above": 0,
        "bounding_box": false,
        "fontscale": 5,
        "label": "",
        "label_rotate": false,
        "style": "default",
        "unit": "Mb",
        "ticklabels_pos": "below",
        "ticks_interval": "20000000"
    }
  ]
}
EOF

figeno make "${output}.conf"
