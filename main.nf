process BONEFISH_ALIGN {
    container "ghcr.io/chusj-pigu/bonefish:edb937c986245337116dab9bcb670d273e170cd7" // TO DO: SET CONTAINER TO FIXED VERSION

    tag "$meta.id"
    label 'process_medium'                    // nf-core labels
    label "process_medium_cpu"              // Label for mpgi drac cpu alloc
    label "process_medium_memory"         // Label for mpgi drac memory alloc
    label "process_low_time"

    input:
    tuple val(meta),
        path(ubam),
    tuple val(meta2),
        path(ref)

    output:
    tuple val(meta),
        path("*.bam"),
        emit: bam
    tuple val(meta),
        path("*.bai"),
        emit: bai
    tuple val("${task.process}"), val("bonefish"), eval("bonefish --version"), topic: versions, emit: versions_bonefish

    script:
    def args = task.ext.args ?: ''
    def threads = task.cpus
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    bonefish \\
        -t ${threads} \\
        ${args} \\
        -o ${prefix}.bam \\
        ${ref} \\
        ${ubam}

    """
}
