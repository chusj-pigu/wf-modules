process BAM2GFF {
    tag "$meta.id"
    label 'process_low'                    // nf-core labels
    label "process_medium_low_cpu"       // Label for mpgi drac cpu alloc
    label "process_low_memory"         // Label for mpgi drac memory alloc
    label "process_low_time"

    container "ghcr.io/chusj-pigu/spliced_bam2gff:63f2175e0ebff2c8a17fda1417f6cc21d06cf328"

    input:
    tuple val(meta),
        path(bam)

    output:
    tuple val(meta),
        path("*.gff"),
        emit: gff
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: '-S'
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    spliced_bam2gff \\
        ${args} \\
        -t ${task.cpus} \\
        -M ${bam} > ${prefix}.gff

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        spliced_bam2gff: \$(spliced_bam2gff -V | awk '{print \$2}')
    END_VERSIONS
    """
}
