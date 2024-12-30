process MODKIT_PILEUP {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/bwbioinfo/modkit:latest'

    tag "$meta.id"
    label 'process_cpu_med'
    label 'process_memory_med'
    label 'process_time_med'
    errorStrategy { task.attempt <= 3 ? 'retry' : 'terminate' }

    publishDir "output", mode: 'copy'

    input:
    tuple val(meta), path(in_bam), path(bam_index)

    output:
    tuple val(meta), path("*.bed"), emit: bedmethyl
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: '--with-header'
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    modkit \\
        pileup \\
        -t ${threads} \\
        ${args} \\
        ${in_bam} \\
        ${prefix}.bed

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        modkit: \$( modkit --version )
    END_VERSIONS
    """
}