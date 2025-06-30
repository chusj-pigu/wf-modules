process SUBCHROM_CALL_WGS {

    //TODO: SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/subchrom:latest'

    label 'medium'
    label 'process_low'
    label 'process_single_cpu'
    label 'process_medium_mid_memory'
    label 'process_low_time'

    tag "$meta.id"

    input:
    tuple val(meta),
        path(vcf),
        val(ref_type),
        path(ref_path)

    output:
    tuple val(meta),
        path("*/results/*CNV.png"),
        emit: cnv_png
    tuple val(meta),
        path("*/results/*focal.png"),
        emit: focal_png
    path "versions.yml",
        emit: versions

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    def marker_db = ref_type in ["hg38", "GRCh38"] ? "hg38" : "hg19"
    def data_type = 'WGS'
    def panel_bin = 'WGS'
    """
    SubChrom.sh \\
        -s ${prefix} \\
        -i ${vcf} \\
        -d ${data_type} \\
        -r ${ref_path} \\
        -p ${panel_bin} \\
        -md ${marker_db}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        SubChrom: \$(echo \$(SubChrom.sh --help 2>&1) | head -4 | tail -1 | awk '{print \$2}' )
    END_VERSIONS
    """
}

process SUBCHROM_CALL_PANEL {

    //TODO: SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/subchrom:latest'

    label 'medium'
    label 'process_low'
    label 'process_single_cpu'
    label 'process_medium_mid_memory'
    label 'process_low_time'

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        path(vcf),
        val(ref_type),
        path(ref_path),
        // panel_bin is a string representing the path to the panel bin file
        val(panel_bin)

    output:
    tuple val(meta),
        path("*/results/*CNV.png"),
        emit: cnv_png
    tuple val(meta),
        path("*/results/*focal.png"),
        emit: focal_png
    path "versions.yml",
        emit: versions

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    def marker_db = ref_type in ["hg38", "GRCh38"] ? "hg38" : "hg19"
    def data_type = 'panel'
    """
    # Create output directory
    mkdir -p "${prefix}.${data_type}.SubChrom"
    
    # Copy VCF to output directory
    cp -P "${vcf}" "${prefix}.${data_type}.SubChrom/${prefix}.${data_type}.gatkHC.vcf.gz"
    
    SubChrom.sh \\
        -s ${prefix} \\
        -i ${bam} \\
        -d ${data_type} \\
        -r ${ref_path} \\
        -p ${panel_bin} \\
        -md ${marker_db}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        SubChrom: \$(echo \$(SubChrom.sh --help 2>&1) | head -4 | tail -1 | awk '{print \$2}' )
    END_VERSIONS
    """
}
