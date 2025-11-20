if [[ $# -lt 4 ]]; then
    echo "Usage: $0 <output_prefix> <input_bam> <input_vcf> <chr:start-end> [chr:start-end ...]"
    exit 1
fi

output="$1"
bam="$2"
vcf="$3"
shift 3

colors=( "#95cdcd" "#f4a460" )
regions=()
i=0

for reg in "$@"; do
    if [[ "$reg" =~ ^([^:]+):([0-9]+)-([0-9]+)$ ]]; then
        chr="${BASH_REMATCH[1]}"
        start="${BASH_REMATCH[2]}"
        end="${BASH_REMATCH[3]}"
        color="${colors[$i]}"
        regions+=("{\"chr\": \"${chr}\", \"start\": ${start}, \"end\": ${end}, \"color\": \"${color}\"}")
        ((i++))
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
			"type": "sv",
			"height": 25,
			"margin_above": 1.5,
			"bounding_box": true,
			"fontscale": 2,
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
			"type": "coverage",
			"height": 25,
			"margin_above": 1.5,
			"bounding_box": false,
			"fontscale": 2,
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
			"fontscale": 2,
			"file": "${bam}",
			"label": "Split Reads",
			"label_rotate": false,
			"hgap_bp": 30,
			"vgap_frac": 0.3,
			"read_color": "#a29bfe",
			"link_splitreads": true,
			"splitread_color": "#a29bfe",
			"link_color": "#9b59b6",
			"link_lw": "0.6",
			"only_show_splitreads": true,
			"min_splitreads_breakpoints": 2,
			"group_by": "none",
			"color_by": "none"
		},
		{
			"type": "genes",
			"height": 15,
			"margin_above": 1.5,
			"bounding_box": false,
			"fontscale": 2,
			"label": "",
			"label_rotate": false,
			"style": "default",
			"collapsed": true,
			"only_protein_coding": false,
			"exon_color": "#2980b9",
			"genes": "auto",
			"show_gene_names": true
		},
		{
            "type": "chr_axis",
            "height": 10,
            "margin_above": 1.5,
            "bounding_box": false,
            "fontscale": 2,
            "label": "",
            "label_rotate": false,
            "style": "arrow",
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