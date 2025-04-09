process SNIFFLES_CALL {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/sniffles:latest"

    label 'process_medium'                    // nf-core labels
    label "process_mid_cpu"                 // Label for mpgi drac cpu alloc
    label "process_medium_mid_memory"         // Label for mpgi drac memory alloc
    label "process_mid_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        path(ref),
        path(ref_fai)

    output:
    tuple val(meta),
        path("*.vcf.gz"),
        emit: vcf
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    sniffles \\
        --input ${bam} \\
        --reference ${ref} \\
        ${args} \\
        -t ${threads} \\
        --vcf ${prefix}_sv.vcf.gz

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        SnpEff: "5.2f"
    END_VERSIONS
    """
}
