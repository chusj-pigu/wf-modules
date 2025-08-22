process FIGENO_SV_FIGURE {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/figeno:latest'

    tag "$meta.id"
    label 'process_medium_low_cpu'
    label 'process_low_memory'
    label 'process_very_low_time'

    input:
    tuple val(meta),
        path(in_bam),
        path(bam_index),
        val(vcf),
        path(vcf_idx),
        path(region)

    output:
    tuple val(meta),
        path("*.png"),
        emit: figure
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    //def args = task.ext.args ?: ''
    //def prefix = task.ext.prefix ?: "${meta.id}"
    //def threads = task.cpus
    def type = region.baseName.contains('fusions') ? 'fusion' : 'other_sv'
    """
    multifuse.sh \\
        --type ${type} \\
        ${region} \\
        ${in_bam} \\
        ${vcf}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        figeno: cat /opt/version.txt
    END_VERSIONS
    """
}

process FIGENO_CIRCOS {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/figeno:latest'

    tag "$meta.id"
    label 'process_medium_low_cpu'
    label 'process_low_memory'
    label 'process_very_low_time'

    input:
    tuple val(meta),
        path(sv_filt),
        path(vcfidx),
        path(cnv_file),
        path(ratio_file)

    output:
    tuple val(meta),
        path("*.png"),
        emit: figure
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    //def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    //def threads = task.cpus
    """
    circos.sh \\
        ${prefix} \\
        ${sv_filt} \\
        ${cnv_file} \\
        ${ratio_file}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        figeno: cat /opt/version.txt
    END_VERSIONS
    """
}
