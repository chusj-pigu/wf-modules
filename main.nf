process OARFISH_QUANTIFY_FQ {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/oarfish:latest'
    // TODO : SET LEVEL OF RESSOURCES
    tag "$meta"
    label 'process_medium'
    label 'process_medium_high_cpu'
    label 'process_low_memory'
    label 'process_low_time'

    publishDir "${params.out_dir}", mode: 'copy'

    input:
    tuple val(meta),
        path(reads),
        path(ref)

    output:
    tuple val(meta),
        path("*"),
        emit: quant
    path "versions.yml",
        emit: versions

    script:
    def args = task.ext?.args ?: ''
    def prefix = task.ext?.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    oarfish \\
        -j ${threads} \\
        ${args} \\
        --reads ${reads} \\
        --reference ${ref} \\
        --seq-tech ont-cdna \\
        -o ${prefix} \\
        --filter-group no-filters \\
        --model-coverage

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        oarfish: \$(echo \$(oarfish --version 2>&1) | sed 's/^.*oarfish //; s/Using.*\$//')
    END_VERSIONS
    """
}

process OARFISH_QUANTIFY_BAM {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/oarfish:latest'
    // TODO : SET LEVEL OF RESSOURCES
    tag "$meta"
    label 'process_medium'
    label 'process_medium_high_cpu'
    label 'process_low_memory'
    label 'process_low_time'

    publishDir "${params.out_dir}", mode: 'copy'

    input:
    tuple val(meta),
        path(bam)

    output:
    tuple val(meta),
        path("*"),
        emit: quant
    path "versions.yml",
        emit: versions

    script:
    def args = task.ext?.args ?: ''
    def prefix = task.ext?.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    oarfish \\
        -j ${threads} \\
        $args \\
        -a ${bam} \\
        -o ${prefix} \\
        --filter-group no-filters \\
        --model-coverage

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        oarfish: \$(echo \$(oarfish --version 2>&1) | sed 's/^.*oarfish //; s/Using.*\$//')
    END_VERSIONS
    """
}
