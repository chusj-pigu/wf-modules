process NASVAR_PIPELINE {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/sniffles:latest"

    label 'process_medium'                    // nf-core labels
    label "process_mid_cpu"                 // Label for mpgi drac cpu alloc
    label "process_medium_mid_memory"         // Label for mpgi drac memory alloc
    label "process_mid_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        val(ref_type),
        path(ref_fasta),
        path(ref_fai),
        path(repeats_bed),
        path(enriched_bed),
        path(maf_sites),
        path(targets_bed),
        path(genes_gff3),
        path(pipeline_config),
        path(reference_json)

    output:
    tuple val(meta),
        path("output/*.vcf.gz"),
        emit: vcf
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    mkdir -p output

    nasvar pipeline \\
        ${bam} \\
        ${repeats_bed} \\
        ${enriched_bed} \\
        ${maf_sites} \\
        ${targets_bed} \\
        ${ref_fasta} \\
        ${genes_gff3} \\
        output/${prefix} \\
        --config ${pipeline_config} \\
        --reference ${reference_json} \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        nasvar: \$(echo \$(nasvar --version 2>&1) | awk '{print \$NF}' )
    END_VERSIONS
    """
}

process NASVAR_COVERAGE {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/nasvar:latest"

    label 'medium'
    label 'process_low'
    label 'process_low_medium_cpu'
    label 'process_low_medium_memory'
    label 'process_low_time'

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        path(json),
        path(repeats_bed)

    output:
    tuple val(meta),
        path("output/*.coverage.tsv"),
        emit: cov
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    mkdir -p output

    nasvar coverage \\
        --reference ${json} \\
        --bam ${bam} \\
        --repeats ${repeats_bed} \\
        --out-prefix output/${prefix} \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        nasvar: \$(echo \$(nasvar --version 2>&1) | awk '{print \$NF}' )
    END_VERSIONS
    """
}

process NASVAR_KARYOTYPE {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/nasvar:latest"

    label 'medium'
    label 'process_low'
    label 'process_low_medium_cpu'
    label 'process_low_medium_memory'
    label 'process_low_time'

    tag "$meta.id"

    input:
    tuple val(meta),
        path(cov),
        path(config),
        path(ref_json)

    output:
    tuple val(meta),
        path("output/*.result.json"),
        emit: karyo_json
    tuple val(meta),
        path("output/*.gc_vs_coverage.gc_corrected.svg"),
        emit: cov_gc_corrected_svg
    tuple val(meta),
        path("output/*.gc_vs_coverage.svg"),
        emit: cov_svg
    tuple val(meta),
        path("output/*.karyotype.gc_corrected.svg"),
        emit: karyo_gc_corrected_svg
    tuple val(meta),
        path("output/*.karyotype.svg"),
        emit: karyo_svg
    
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    mkdir -p output

    nasvar karyotype \\
        --coverage ${cov} \\
        --out-prefix output/${prefix} \\
        --config ${config} \\
        --reference ${ref_json} \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        nasvar: \$(echo \$(nasvar --version 2>&1) | awk '{print \$NF}' )
    END_VERSIONS
    """
}