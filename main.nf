process SAMTOOLS_QSFILTER {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/samtools:latest'
    label "process_small"                    // nf-core labels
    label "process_medium_low_cpu"          // Label for mpgi drac cpu alloc
    label "process_medium_low_memory"       // Label for mpgi drac memory alloc
    label "process_low_time"                // Label for mpgi drac time alloc

    tag "$barcode"

    input:
    tuple val(meta), val(barcode), path(ubam)

    output:
    tuple val(meta), val(barcode), path("${barcode}_pass.bam"), emit: ubam_pass
    tuple val(meta), val(barcode), path("${barcode}_fail.bam"), emit: ubam_fail
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: '--no-PG'
    def minqs = params.minqs
    def threads = task.cpus
    """
    samtools \\
        view \\
        ${args} \\
        -@ ${threads} \\
        -e '[qs] >=${minqs}' \\
        -b ${ubam} \\
        --output ${barcode}_pass.bam \\
        --unoutput ${barcode}_fail.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')    END_VERSIONS
    """
}

process SAMTOOLS_TOFASTQ {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/samtools:latest'
    label "process_medium"              // nf-core labels
    label "process_medium_low_cpu"          // Label for mpgi drac memory alloc
    label "process_low_memory"              // Label for mpgi drac memory alloc
    label "process_medium_low_time"         // Label for mpgi drac time alloc

    tag "$meta.id"

    input:
    tuple val(meta), val(barcode), path(ubam)

    output:
    tuple val(meta), path("*.fq.gz"), emit: fq
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    samtools fastq \\
        ${args} \\
        -@ ${threads} \\
        ${ubam} | \\
        pigz -p ${threads} -c > ${prefix}.fq.gz

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')    END_VERSIONS
    """
}

process SAMTOOLS_TOBAM {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/samtools:latest'
    label "process_medium"          // nf-core labels
    label "process_medium_low_cpu"          // Label for mpgi drac memory alloc
    label "process_medium_low_memory"       // Label for mpgi drac memory alloc
    label "process_low_time"                // Label for mpgi drac time alloc

    tag "$meta.id"

    input:
    tuple val(meta), path(in_sam)

    output:
    tuple val(meta), path("*.bam"), emit: bamfile
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: '-b'
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    samtools \\
        view \\
        -@ ${threads} \\
        ${args} \\
        ${in_sam} > ${prefix}.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')    END_VERSIONS
    """
}

process SAMTOOLS_SORT {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/samtools:latest'

    label "process_medium_cpu"              // Label for mpgi drac memory alloc
    label "process_medium_memory"           // Label for mpgi drac memory alloc
    label "process_medium_low_time"         // Label for mpgi drac time alloc

    tag "$meta.id"

    input:
    tuple val(meta), path(in_bam)

    output:
    tuple val(meta), path("*.sorted.bam"), emit: sortedbam
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    samtools \\
        sort \\
        -@ ${threads} \\
        ${args} \\
        ${in_bam} \\
        -o ${prefix}.sorted.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')    END_VERSIONS
    """
}

process SAMTOOLS_SORT_INDEX {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/samtools:latest'

    label "process_medium_cpu"              // Label for mpgi drac memory alloc
    label "process_medium_memory"           // Label for mpgi drac memory alloc
    label "process_medium_low_time"         // Label for mpgi drac time alloc

    tag "$meta.id"

    input:
    tuple val(meta), path(in_bam)

    output:
    tuple val(meta), path("*.sorted.bam"), path("*.sorted.bam.bai"), emit: sortedbamidx
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    samtools \\
        sort \\
        -@ ${threads} \\
        ${args} \\
        ${in_bam} \\
        --write-index \\
        -o ${prefix}.sorted.bam##idx##${prefix}.sorted.bam.bai

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')    END_VERSIONS
    """
}


process SAMTOOLS_INDEX {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/samtools:latest'

    label "process_low"                     // nf-core labels
    label "process_low_cpu"              // Label for mpgi drac memory alloc
    label "process_low_memory"           // Label for mpgi drac memory alloc
    label "process_low_time"            // Label for mpgi drac time alloc

    tag "$meta.id"

    input:
    tuple val(meta), path(in_bam)

    output:
    tuple val(meta), path(in_bam),path("*.bai"), emit: bamfile_index
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    // def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    samtools \\
        index \\
        -@ ${threads} \\
        ${args} \\
        ${in_bam}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')    END_VERSIONS
    """
}
