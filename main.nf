process MINIMAP2_ALIGNDRNA {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/bwbioinfo/minimap2:latest'

    tag "$meta.id"
    label 'process_high'
    errorStrategy { task.attempt <= 3 ? 'retry' : 'terminate' }
    
    input:
    tuple val(meta), path(reads)
    path(reference)

    output:
    tuple val(meta), path("*.sam"), emit: samfile
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: '-ax splice -uf -y -k14'
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    minimap2 \\
        -t ${threads} \\
        ${args} \\
        ${reference} \\
        ${reads} \\
        -o '${prefix}.sam'

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        minimap2: \$( minimap2 --version )
    END_VERSIONS
    """
} 