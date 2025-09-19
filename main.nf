process SAMTOOLS_QSFILTER {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/samtools:latest'
    label "process_small"                    // nf-core labels
    label "process_medium_low_cpu"          // Label for mpgi drac cpu alloc
    label "process_medium_low_memory"       // Label for mpgi drac memory alloc
    label "process_low_time"                // Label for mpgi drac time alloc

    tag "$meta.id"

    input:
    tuple val(meta),
        path(ubam)

    output:
    tuple val(meta),
        path("*_pass.bam"),
        emit: ubam_pass
    tuple val(meta),
        path("*_fail.bam"),
        emit: ubam_fail
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: '--no-PG'
    def minqs = params.minqs
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    samtools \\
        view \\
        ${args} \\
        -@ ${threads} \\
        -e '[qs] >=${minqs}' \\
        -b ${ubam} \\
        --output ${prefix}_pass.bam \\
        --unoutput ${prefix}_fail.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')

    END_VERSIONS
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
    tuple val(meta),
        path(ubam)

    output:
    tuple val(meta),
        path("*.fq.gz"),
        emit: fq
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
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')

    END_VERSIONS
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
    tuple val(meta),
        path(in_sam)

    output:
    tuple val(meta),
        path("*.bam"),
        emit: bamfile
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
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')

    END_VERSIONS
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
    tuple val(meta),
        path(in_bam)

    output:
    tuple val(meta),
        path("*.sorted.bam"),
        emit: sortedbam
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args
        if (task.ext.args) {
            args = task.ext.args
        } else if (meta.id.toString().contains('oarfish')) {      // Sort by read ID required by oarfish
            args = '-n'
        } else {
            args = ''
        }
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
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')
    END_VERSIONS
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
    tuple val(meta),
        path(in_bam)

    output:
    tuple val(meta),
        path("*.indexed.bam"),
        path("*.bai"),
        emit: bamfile_index
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    cp ${in_bam} ${prefix}.indexed.bam
    samtools \\
        index \\
        -@ ${threads} \\
        ${args} \\
        ${prefix}.indexed.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')
    END_VERSIONS
    """
}

process SAMTOOLS_FAIDX {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/samtools:latest'

    label "process_low"                     // nf-core labels
    label "process_low_cpu"              // Label for mpgi drac memory alloc
    label "process_low_memory"           // Label for mpgi drac memory alloc
    label "process_low_time"            // Label for mpgi drac time alloc

    tag "$meta.id"

    input:
    tuple val(meta),
        path(in_fa)

    output:
    tuple val(meta),
        path('*.fai'), emit: fasta_index
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    // def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    if (in_fa.name.endsWith('.gz')) {
    """
    pigz \\
        -d \\
        -p ${threads} \\
        -c ${in_fa} > ${in_fa.name - '.gz'}
    samtools \\
        faidx \\
        -@ ${threads} \\
        ${args} \\
        ${in_fa.name - '.gz'}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')
    END_VERSIONS
    """
    } else {
    """
    samtools \\
        faidx \\
        -@ ${threads} \\
        ${args} \\
        ${in_fa}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')
    END_VERSIONS
    """
    }

}

process SAMTOOLS_SPLIT_BY_BED {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/samtools:latest'

    label "process_low"                     // nf-core labels
    label "process_medium_cpu"         // Label for mpgi drac memory alloc
    label "process_medium_mid_memory"    // Label for mpgi drac memory alloc
    label "process_medium_mid_time"      // Label for mpgi drac time alloc

    tag "$meta.id"

    input:
    tuple val(meta), path(bam), path(bai), path(bed)

    output:
    tuple val(meta),
        path("*_panel.bam"),
        emit: panel
    tuple val(meta),
        path("*_bg.bam"),
        emit: bg
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    samtools \\
        view \\
        ${args} \\
        -@ ${threads} \\
        -L ${bed} \\
        -o ${prefix}_panel.bam \\
        -U ${prefix}_bg.bam \\
        ${bam}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')

    END_VERSIONS
    """
}

process SAMTOOLS_MERGE {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/samtools:latest'
    label "process_medium"          // nf-core labels
    label "process_medium_cpu"              // Label for mpgi drac memory alloc
    label "process_medium_memory"           // Label for mpgi drac memory alloc
    label "process_medium_time"                // Label for mpgi drac time alloc

    tag "$meta.id"

    input:
    tuple val(meta),
        path(in_bam)

    output:
    tuple val(meta),
        path("*.bam"),
        emit: bamfile
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: '--no-PG'
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    samtools \\
        merge \\
        -@ ${threads} \\
        ${args} \\
        ${in_bam} \\
        -o ${prefix}_merged.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')

    END_VERSIONS
    """
}
