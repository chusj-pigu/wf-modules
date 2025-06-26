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
        path(vcf1),
        path(vcf1_index),
        path(vcf2),
        path(vcf2_index)

    output:
    tuple val(meta),
        path("*.vcf"),
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
        --threads ${threads} \\
        ${args} \\
        ${vcf1} \\
        ${vcf2} > ${prefix}.vcf

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bcftools: \$( echo \$(bcftools --version 2>&1) | sed 's/^.*bcftools //; s/Using.*\$//' )
    END_VERSIONS
    """
}

process BCFTOOLS_SORT {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/bcftools:latest"

    label 'process_low'                    // nf-core labels
    label "process_low_cpu"       // Label for mpgi drac cpu alloc
    label "process_medium_mid_memory"         // Label for mpgi drac memory alloc
    label "process_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(vcf)

    output:
    tuple val(meta),
        path("*.vcf"),
        emit: vcf
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    bcftools sort \\
        ${args} \\
        ${vcf} > ${prefix}_sorted.vcf

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bcftools: \$( echo \$(bcftools --version 2>&1) | sed 's/^.*bcftools //; s/Using.*\$//' )
    END_VERSIONS
    """
}

process BCFTOOLS_INDEX {
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
        path(vcf),
        path("*.tbi"),
        emit: vcf_tbi
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    //def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    bcftools \\
        index \\
        -tf \\
        ${args} \\
        --threads ${threads} \\
        ${vcf} \\
        -o ${vcf}.tbi

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
    def args = task.ext.args ?: '-Oz'
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    bcftools view \\
        ${args} \\
        --threads ${threads} \\
        ${vcf} \\
        -o ${prefix}.vcf.gz

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bcftools: \$( echo \$(bcftools --version 2>&1) | sed 's/^.*bcftools //; s/Using.*\$//' )
    END_VERSIONS
    """
}

process BCFTOOLS_MPILEUP {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/bcftools:latest"

    label 'process_low'                    // nf-core labels
    label "process_medium_low_cpu"       // Label for mpgi drac cpu alloc
    label "process_medium_low_memory"         // Label for mpgi drac memory alloc
    label "process_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bam_bai),
        path(ref),
        path(ref_fai)

    output:
    tuple val(meta),
        path("*.bcf"),
        emit: bcf
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: '-Oz'
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    bcftools mpileup \\
        ${args} \\
        --threads ${threads} \\
        -f ${ref} \\
        ${bam} \\
        -o ${prefix}.bcf

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bcftools: \$( echo \$(bcftools --version 2>&1) | sed 's/^.*bcftools //; s/Using.*\$//' )
    END_VERSIONS
    """
}


process BCFTOOLS_CALL {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/bcftools:latest"

    label 'process_low'                    // nf-core labels
    label "process_medium_low_cpu"       // Label for mpgi drac cpu alloc
    label "process_medium_low_memory"
    label "process_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bcf)

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
    bcftools call \\
        ${args} \\
        --threads ${threads} \\
        ${bcf} \\
        -o ${prefix}_snp.vcf.gz

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bcftools: \$( echo \$(bcftools --version 2>&1) | sed 's/^.*bcftools //; s/Using.*\$//' )
    END_VERSIONS
    """
}
