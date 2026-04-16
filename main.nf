process SQANTIRUST {
    container 'ghcr.io/chusj-pigu/sqantirust:sha-16aec7e'
    tag "$meta.id"
    label 'process_medium'
    label 'process_medium_high_cpu'
    label 'process_low_memory'
    label 'process_low_time'

    input:
    tuple val(meta),
        path(ref_gtf),
        path(gff)

    output:
    tuple val(meta),
        path("*summary.tsv"),
        emit: summary
    tuple val(meta),
        path("*classification.tsv"),
        emit: classification
    path "versions.yml",
        emit: versions

    script:
    //def args = task.ext.args ?: ''
    def prefix = task.ext?.prefix ?: "${meta.id}"
    //def threads = task.cpus
    """
    sqantirust \\
        --ref-gtf ${ref_gtf} \\
        --query ${gff} \\
        --output ${prefix}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        sqantirust: 0.1.0
    END_VERSIONS
    """
}
