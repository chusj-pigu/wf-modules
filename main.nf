process QUANTIFY {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container="ghcr.io/chusj-pigu/oarfish:latest"
    // TODO : SET LEVEL OF RESSOURCES
    tag "$meta"
    label 'process_cpu_med'
    label 'process_memory_med'
    label 'process_time_med'
    errorStrategy { task.attempt <= 3 ? 'retry' : 'terminate' }

    publishDir "${params.out_dir}", mode: 'copy'

    input:
    tuple val(meta), path(reads)
    path ref

    output:
    tuple val(meta), path("${prefix}")

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta}"
    def threads = task.cpus
    """
    oarfish \\
     -j $threads \\
     --reads $reads \\
     --reference $ref \\
     --seq-tech ont-cdna \\
     -o $prefix \\
     --filter-group no-filters \\
     --model-coverage
    """

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        oarfish: \$(echo \$(oarfish --version 2>&1) | sed 's/^.*oarfish //; s/Using.*\$//')    END_VERSIONS
    """

}