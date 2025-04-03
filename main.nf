process WHATSHAP_PHASE {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/whatshap:latest"

    label 'process_medium'                    // nf-core labels
    label "process_single_cpu"                 // Label for mpgi drac cpu alloc
    label "process_medium_mid_memory"         // Label for mpgi drac memory alloc
    label "process_mid_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        path(vcf),
        path(ref)

    output:
    tuple val(meta),
        path("*phased.vcf.gz"),
        path("*phased.vcf.gz.tbi"),
        emit: vcf_phased
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    //def threads = task.cpus
    """
    whatshap \\
        phase \\
        --output ${prefix}_phased.vcf.gz \\
        --reference ${ref} \\
        ${args} \\
        --ignore-read-groups \\
        ${vcf} \\
        ${bam}
    tabix \\
        -f -p vcf \\
        ${prefix}_phased.vcf.gz

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        WhatsHap: \$(whatshap --version)
    END_VERSIONS
    """
}

process WHATSHAP_HAPLOTAG {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/whatshap:latest"

    label 'process_medium'                    // nf-core labels
    label "process_medium_low_cpu"                 // Label for mpgi drac cpu alloc
    label "process_medium_mid_memory"         // Label for mpgi drac memory alloc
    label "process_mid_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        path(phased_vcf),
        path(phased_vcf_tbx),
        path(ref)

    output:
    tuple val(meta),
        path("*haplotagged.bam"),
        emit: bam_hap
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    whatshap \\
        haplotag \\
        -o ${prefix}_haplotagged.bam \\
        --output-threads ${threads} \\
        --reference ${ref} \\
        ${args} \\
        --ignore-read-groups \\
        ${phased_vcf} \\
        ${bam}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        WhatsHap: \$(whatshap --version)
    END_VERSIONS
    """
}

process WHATSHAP_STATS {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/whatshap:latest"

    label 'process_medium'                    // nf-core labels
    label "process_single_cpu"                 // Label for mpgi drac cpu alloc
    label "process_medium_mid_memory"         // Label for mpgi drac memory alloc
    label "process_mid_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(phased_vcf),
        path(phased_vcf_tbx)

    output:
    tuple val(meta),
        path("*haploblocks.gtf"),
        emit: haploblocks
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    //def threads = task.cpus
    """
    whatshap \\
        stats \\
        ${args} \\
        --gtf=${prefix}.haploblocks.gtf \\
        ${phased_vcf}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        WhatsHap: \$(whatshap --version)
    END_VERSIONS
    """
}
