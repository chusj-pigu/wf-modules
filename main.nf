process ONTIME_RANGE_FILTER {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/ontime:latest'
    label "process_small"                   // nf-core labels
    label "process_medium_low_cpu"          // Label for mpgi drac cpu alloc
    label "process_medium_low_memory"       // Label for mpgi drac memory alloc
    label "process_low_time"                // Label for mpgi drac time alloc

    input:
    tuple val(meta),
        path(bam),
        val(from),
        val(to)

    output:
    tuple val(meta),
        path(bam),
        emit: bam
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def threads = task.cpus
    def prefix = "${meta.id}"
    """
    ontime \
        --from ${from}h \
        --to ${to}h \
        in.bam \
        -o ${meta.id}-time-${from}h-${to}.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        ontime: \$(echo \$(ontime --version 2>&1) | sed 's/^.*ontime //; s/Using.*\$//')
        END_VERSIONS
    """
}