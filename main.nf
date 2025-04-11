process CHROMPLOTTER {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/rs-chromplotter:latest'

    tag "$meta.id"
    label 'process_cpu_med'
    label 'process_memory_med'
    label 'process_time_med'

    input:
    tuple val(meta),
        path(in_bed),
        val(in_chrom)

    output:
    tuple val(meta),
        path("*.png"),
        val(in_chrom),
        optional: true,
        emit: chromplot
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    // TODO: Set threads when pipeline is stable
    // def threads = task.cpus
    """
    chromplotter \\
    chromplot \\
    ${args} \\
    --bedfile ${in_bed} \\
    --chrom ${in_chrom} \\
    --output ${prefix}_${in_chrom}.png

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        chromplotter: \$( chromplotter --version  | sed 's/^.*chromplotter //; s/Using.*\$//')
    END_VERSIONS
    """
}
