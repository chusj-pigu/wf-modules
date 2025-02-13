process SAMTOOLS_TOBAM {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/samtools:latest'
    label "process_medium"
    label "samtools_med"

    tag "$meta.id"

    input:
    tuple val(meta), path(in_sam)

    output:
    tuple val(meta), path("*.bam"), emit: bamfile
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: '-b'
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    samtools \\
        view \\
        -@ ${threads} \\
        ${args} \\
        ${in_sam} > ${prefix}.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')    END_VERSIONS
    """
}

process SAMTOOLS_SORT {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/samtools:latest'

    tag "$meta.id"
    label "process_medium"
    label "samtools_big"


    input:
    tuple val(meta), path(in_bam)

    output:
    tuple val(meta), path("*.sorted.bam"), emit: sortedbam
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    samtools \\
        sort \\
        -@ ${threads} \\
        ${args} \\
        ${in_bam} \\
        -o ${prefix}.sorted.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')    END_VERSIONS
    """
}


process SAMTOOLS_INDEX {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/samtools:latest'

    label "process_low"
    label "samtools_small"
    tag "$meta.id"

    input:
    tuple val(meta), path(in_bam)

    output:
    tuple val(meta), path(in_bam),path("*.bai"), emit: bamfile_index
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    // def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    samtools \\
        index \\
        -@ ${threads} \\
        ${args} \\
        ${in_bam}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')    END_VERSIONS
    """
}
