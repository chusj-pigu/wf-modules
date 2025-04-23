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
        path(bam),
        path(bai),
        val(ref_type),
        path(ref_path),
        path(bed)

    output:
    tuple val(meta),
        path("*.txt"),
        emit: calls_txt
    tuple val(meta),
        path("*CNV.png"),
        emit: cnv_png
    tuple val(meta),
        path("*focal.png"),
        emit: focal_png
    path "versions.yml",
        emit: versions

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    def database = ref_type in ["hg38", "GRCh38"] ? "/data/SNPmarker_hg38" : "/data/SNPmarker_hg19"
    def gene_list = bed.name == 'NO_BED' ? '' : "-gl ${bed}"
    """
    SubChrom.sh \\
        -s ${prefix} \\
        -i ${bam} \\
        -d WGS \\
        -r ${ref_path} \\
        -p WGS \\
        ${gene_list} \\
        -md ${database}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        SubChrom: \$(echo \$(SubChrom.sh --help 2>&1) | head -4 | tail -1 | awk '{print \$2}' )
    END_VERSIONS
    """
}
