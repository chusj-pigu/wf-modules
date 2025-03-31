process CRAMINO_STATS {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/cramino:latest'

    tag "$meta.id"
    label 'process_low_cpus'
    label 'process_low_memory'
    label 'process_low_time'

    input:
    tuple val(meta),
        path(bam),
        path(bai)

    output:
    tuple val(meta),
        path("*.txt"),
        emit: stats
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    cramino \\
        -t ${threads} \\
        ${args} \\
        ${bam} > ${prefix}_cramino_stats.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        cramino: \$(echo \$(cramino --version 2>&1) | sed 's/^.*cramino //; s/Using.*\$//')
    END_VERSIONS
    """
}
