process SEVERUS_TUMOR_SINGLE {
    container "ghcr.io/chusj-pigu/severus:a294582458464a429891218e2be1c8c0db07b199" // TO DO: SET CONTAINER TO FIXED VERSION

    tag "$meta.id"
    label 'process_medium'                    // nf-core labels
    label "process_medium_low_cpu"              // Label for mpgi drac cpu alloc
    label "process_medium_memory"         // Label for mpgi drac memory alloc
    label "process_low_time"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        path(snp_vcf)
    tuple val(meta2), path(fasta)
    tuple val(meta3), path(vntr)
    tuple val(meta4), path(pon)

    output:
    tuple val(meta),
        path("somatic_SVs/severus_somatic.vcf"),
        emit: vcf
    path "versions.yml",
        emit: versions

    script:
    def args = task.ext.args ?: ''
    def threads = task.cpus
    def phased_vcf = snp_vcf ? "--phasing-vcf ${snp_vcf}": ""
    """
    severus \\
        ${args} \\
        --target-bam ${bam} \\
        --out-dir '.' \\
        -t ${threads} \\
        ${phased_vcf} \\
        --vntr-bed ${vntr} \\
        --PON ${pon}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        Severus: \$(severus -v)
    END_VERSIONS
    """
}
