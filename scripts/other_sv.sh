#!/bin/bash

# Usage: ./other_sv.sh <output_prefix> <input_bam> <input_vcf> chr:start-end [chr:start-end ...]

set -euo pipefail

if [[ $# -lt 4 ]]; then
    echo "Usage: $0 <output_prefix> <input_bam> <input_vcf> <chr:start-end> [chr:start-end ...]"
    exit 1
fi

output="$1"
bam="$2"
vcf="$3"
shift 3

regions=()
for reg in "$@"; do
    # Extract chromosome, start, and end using parameter expansion and pattern matching
    if [[ "$reg" =~ ^([^:]+):([0-9]+)-([0-9]+)$ ]]; then
        chr="${BASH_REMATCH[1]}"
        start="${BASH_REMATCH[2]}"
        end="${BASH_REMATCH[3]}"
        regions+=("{\"chr\": \"${chr}\", \"start\": ${start}, \"end\": ${end}}")
    else
        echo "Invalid region format: $reg (expected chr:start-end)"
        exit 1
    fi
done

region_json=$(IFS=, ; echo "${regions[*]}")

cat > "${output}.conf" <<EOF
{
	"general": {
		"layout": "horizontal",
		"reference": "hg38"
	},
	"output": {
		"file": "${output}.png",
		"dpi": 800,
		"width": 600
	},
	"regions": [
		${region_json}
	],
	"highlights": [],
	"tracks": [
		{
			"type": "coverage",
			"height": 25,
			"margin_above": 1.5,
			"bounding_box": false,
			"fontscale": 1,
			"label": "Coverage",
			"label_rotate": false,
			"file": "${bam}",
			"color": "#888888",
			"n_bins": "5000",
			"scale": "auto",
			"scale_pos": "corner",
			"upside_down": false
		},
		{
			"type": "alignments",
			"height": 50,
			"margin_above": 1.5,
			"bounding_box": false,
			"fontscale": 1,
			"file": "${bam}",
			"label": "All Reads",
			"label_rotate": false,
			"hgap_bp": 30,
			"vgap_frac": 0.3,
			"read_color": "#cccccc",
			"link_splitreads": false,
			"group_by": "none",
			"color_by": "none"
		},
		{
			"type": "sv",
			"height": 15,
			"margin_above": 1.5,
			"bounding_box": true,
			"fontscale": 1,
			"label": "Structural Variants",
			"label_rotate": false,
			"file": "${vcf}",
			"lw": "0.5",
			"color_del": "#4a69bd",
			"color_dup": "#e55039",
			"color_t2t": "#8e44ad",
			"color_h2h": "#8e44ad",
			"color_trans": "#27ae60",
			"min_sv_height": 0.1
		},
		{
			"type": "genes",
			"height": 15,
			"margin_above": 1.5,
			"bounding_box": false,
			"fontscale": 1,
			"label": "",
			"label_rotate": false,
			"style": "default",
			"collapsed": false,
			"only_protein_coding": true,
			"exon_color": "#2980b9",
			"genes": "auto",
			"show_gene_names": true
		},
		{
			"type": "chr_axis",
			"height": 10,
			"margin_above": 1.5,
			"bounding_box": false,
			"fontscale": 1,
			"label": "",
			"label_rotate": false,
			"style": "ideogram",
			"lw_scale": "1.0",
			"ticklabels_pos": "below",
			"unit": "kb",
			"ticks_interval": "auto",
			"ticks_angle": 0,
			"chr_prefix": "chr"
		}
	]
}
EOF

figeno make ${output}.conf
