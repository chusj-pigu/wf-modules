process BCFTOOLS_CONCAT {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/bcftools:latest"

    label 'process_low'                    // nf-core labels
    label "process_low_cpu"       // Label for mpgi drac cpu alloc
    label "process_medium_mid_memory"         // Label for mpgi drac memory alloc
    label "process_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(indel),
        path(snv)

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
    bcftools concat \\
        ${args} \\
        --threads ${threads} \\
        ${indel} \\
        ${snv} > ${prefix}.vcf

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bcftools: \$( echo \$(bcftools --version 2>&1) | sed 's/^.*bcftools //; s/Using.*\$//' )
    END_VERSIONS
    """
}

process BGZIP_VCF {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/bcftools:latest"

    label 'process_low'                    // nf-core labels
    label "process_low_cpu"       // Label for mpgi drac cpu alloc
    label "process_low_memory"         // Label for mpgi drac memory alloc
    label "process_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(vcf)

    output:
    tuple val(meta),
        path("*.vcf.gz"),
        emit: vcf_gz
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    bgzip \\
        -c
        ${args} \\
        -@ ${threads} \\
        ${vcf} \\
        -o ${prefix}.vcf.gz

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bcftools: \$( echo \$(bcftools --version 2>&1) | sed 's/^.*bcftools //; s/Using.*\$//' )
    END_VERSIONS
    """
}
