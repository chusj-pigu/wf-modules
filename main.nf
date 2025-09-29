process TIDEHUNTER_FASTQ {

    tag "$meta.id"

    label 'process_high'                    // nf-core labels
    label "process_medium_high_cpu"       // Label for mpgi drac cpu alloc
    label "process_medium_memory"         // Label for mpgi drac memory alloc
    label "process_low_time" // Label for mpgi drac time alloc

    container "ghcr.io/chusj-pigu/tidehunter:latest" // TO DO: SET CONTAINER TO FIXED VERSION

    input:
    tuple val(meta),
        path(reads)

    output:
    tuple val(meta),
        path("*.fq"),
        emit: fq
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = 2 * task.cpus
    """
    TideHunter \\
        -t ${threads} \\
        -f 3 \\
        ${args} \\
        -o ${prefix}_cons.fq \\
        ${reads}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        TideHunter: \$(TideHunter --version)
    END_VERSIONS
    """
}

process TIDEHUNTER_TAB {

    tag "$meta.id"

    label 'process_high'                    // nf-core labels
    label "process_medium_high_cpu"       // Label for mpgi drac cpu alloc
    label "process_medium_memory"         // Label for mpgi drac memory alloc
    label "process_low_time" // Label for mpgi drac time alloc

    container "ghcr.io/chusj-pigu/tidehunter:latest" // TO DO: SET CONTAINER TO FIXED VERSION

    input:
    tuple val(meta),
        path(reads)

    output:
    tuple val(meta),
        path("*.tsv"),
        emit: tsv
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = 2 * task.cpus
    """
    TideHunter \\
        -t ${threads} \\
        -f 2 \\
        ${args} \\
        -o ${prefix}_cons.tsv \\
        ${reads}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        TideHunter: \$(TideHunter --version)
    END_VERSIONS
    """
}
