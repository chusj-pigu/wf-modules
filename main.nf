process MOSDEPTH_GENERAL {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/mosdepth:latest'

    label 'process_low'                      // nf-core labels
    label "process_low_cpu"                 // Label for cpu ressources alloc
    label "process_low_memory"              // Label for memory ressources alloc
    label "process_low_time"                // Label for time ressources alloc

    tag "$meta.id"

    input:
    tuple val(meta), path(bam), path(bai)

    output:
    tuple val(meta), path("*.dist.txt"), emit: dist
    tuple val(meta), path("*.summary.txt"), emit: summary
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    mosdepth \\
        -t ${task.cpus} \\
        ${args} \\
        '${prefix}' \\
        ${bam}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        mosdepth: \$( mosdepth -h | head -n 2 | tail -n 1 )
    END_VERSIONS
    """
}

process MOSDEPTH_ADAPTIVE {
   // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/mosdepth:latest'

    label 'process_low'                      // nf-core labels
    label "process_low_cpu"                 // Label for cpu ressources alloc
    label "process_low_memory"              // Label for memory ressources alloc
    label "process_low_time"                // Label for time ressources alloc

    tag "$meta.id"

    input:
    tuple val(meta), path(bam), path(bai), path(bed), val(flag), val(qual)

    output:
    tuple val(meta), path("*.dist.txt"), emit: dist
    tuple val(meta), path("*.summary.txt"), emit: summary
    tuple val(meta), path("*.bed.gz"), emit: bed
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    mosdepth \\
        -t ${task.cpus} \\
        ${args} \\
        -F ${flag}  \\
        -Q ${qual} \\
        -b ${bed} \\
        '${prefix}' \\
        ${bam}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        mosdepth: \$( mosdepth -h | head -n 2 | tail -n 1 )
    END_VERSIONS
    """
}
