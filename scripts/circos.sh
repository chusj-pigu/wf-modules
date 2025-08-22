#!/bin/bash

# Usage: ./circos.sh <output_prefix> <input_vcf> <input_cnv> <input_cnv_ratio>

set -euo pipefail

if [[ $# -lt 4 ]]; then
    echo "Usage: $0 <output_prefix> <input_vcf> <input_cnv> <input_cnv_ratio>"
    exit 1
fi

output="$1"
vcf="$2"
cnv="$3"
ratio="$4"
shift 3

cat > "${output}.conf" <<EOF
{
	"general": {
		"layout": "circular",
		"reference": "hg38"
	},
	"output": {
		"file": "${output}_circos.png",
		"dpi": 400,
        "width": 180
	},
	"regions": [
            {"chr": "1","color": "#98671F"},
            {"chr": "2","color": "#65661B"},
            {"chr": "3","color": "#969833"},
            {"chr": "4","color": "#CE151D"},
            {"chr": "5","color": "#FF1A25"},
            {"chr": "6","color": "#FF0BC8"},
            {"chr": "7","color": "#FFCBCC"},
            {"chr": "8","color": "#FF9931"},
            {"chr": "9","color": "#FFCC3A"},
            {"chr": "10","color": "#FCFF44"},
            {"chr": "11","color": "#C4FF40"},
            {"chr": "12","color": "#00FF3B"},
            {"chr": "13","color": "#2F7F1E"},
            {"chr": "14","color": "#2800C6"},
            {"chr": "15","color": "#6A96FA"},
            {"chr": "16","color": "#98CAFC"},
            {"chr": "17","color": "#00FEFD"},
            {"chr": "18","color": "#C9FFFE"},
            {"chr": "19","color": "#9D00C6"},
            {"chr": "20","color": "#D232FA"},
            {"chr": "21","color": "#956DB5"},
            {"chr": "22","color": "#5D5D5D"},
            {"chr": "X","color": "#989898"},
            {"chr": "Y","color": "#CBCBCB"}
        ],
        "highlights": [],
        "tracks": [
                {
                        "type": "sv",
                        "file": "${vcf}",
                        "height": 15,
                        "margin_above": 1.5,
                        "bounding_box": true,
                        "fontscale": 1,
                        "label": "",
                        "label_rotate": false,
                        "lw": "0.5",
                        "color_del": "#4a69bd",
                        "color_dup": "#e55039",
                        "color_t2t": "#8e44ad",
                        "color_h2h": "#8e44ad",
                        "color_trans": "#27ae60"
                },
                {
                        "type": "copynumber",
                        "height": 30,
                        "margin_above": 0,
                        "bounding_box": true,
                        "fontscale": 1,
                        "label": "",
                        "label_rotate": false,
                        "freec_ratios": "${ratio}",
                        "freec_CNAs": "${cnv}",
                        "purple_cn": "",
                        "genes": "",
                        "min_cn": "",
                        "max_cn": 3.9,
                        "grid": true,
                        "grid_major": false,
                        "grid_minor": false,
                        "grid_cn": true,
                        "color_normal": "#000000",
                        "color_loss": "#4a69bd",
                        "color_gain": "#e55039",
                        "color_cnloh": "#f6b93b"
                },
                {
                        "type": "chr_axis",
                        "height": 10,
                        "margin_above": 0,
                        "bounding_box": false,
                        "fontscale": 1,
                        "label": "",
                        "label_rotate": false,
                        "style": "default",
                        "unit": "kb",
                        "ticklabels_pos": "below",
                        "ticks_interval": "auto"
                }
        ]
}
EOF

figeno make ${output}.conf
