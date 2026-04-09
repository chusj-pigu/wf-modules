process SQANTIRUST {
    container 'ghcr.io/chusj-pigu/sqantirust:sha256-75dfd3d433fa8e01d60bdfd9faa92b4854510ef8fcffa08a35874f71fda649f3.sig'
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
        path("*.tsv"),
        emit: table
    path "versions.yml",
        emit: versions

    script:
    //def args = task.ext.args ?: ''
    def prefix = task.ext?.prefix ?: "${meta.id}"
    //def threads = task.cpus
    """
    sqantirust \\
        --ref-gtf ${ref_gtf} \\
        --query ${gff} > ${prefix}.tsv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        sqantirust: 0.1.0
    END_VERSIONS
    """
}