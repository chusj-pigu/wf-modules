process MODKIT_PILEUP {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/modkit:latest'

    tag "$meta.id"
    label 'process_medium_high_cpu'
    label 'process_low_memory'
    label 'process_low_time'

    input:
    tuple val(meta),
        path(in_bam),
        path(bam_index)

    output:
    tuple val(meta),
        path("*.bed"),
        emit: bedmethyl
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: '--with-header'
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus * 2
    """
    modkit \\
        pileup \\
        -t ${threads} \\
        ${args} \\
        ${in_bam} \\
        ${prefix}.bed

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        modkit: \$( modkit --version  | sed 's/^.*mod_kit //; s/Using.*\$//')
    END_VERSIONS
    """
}

process MODKIT_SUMMARY {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/modkit:latest'

    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta),
        path(in_bam),
        path(bam_index)

    output:
    tuple val(meta), path("*.txt"),
        emit: modkit_summary
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus

    """
    modkit \\
        summary \\
        ${in_bam} \\
        --threads ${threads} \\
        ${args} \\
        --tsv > ${prefix}_modkit_summary.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        modkit: \$( modkit --version | sed 's/^.*mod_kit //; s/Using.*\$//')
    END_VERSIONS
    """
}

process MODKIT_DMR_PAIR {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/modkit:latest'

    tag "$meta.id"
    label 'process_low_medium_memory'
    label 'process_medium_cpu'
    label 'process_low_time'

    input:
    tuple val(meta),
        path(ctl_pileup),
        path(ctl_index),
        val(exp_id),
        path(exp_pileup),
        path(exp_index)
    path(ref)
    val(base)

    output:
    tuple val(meta),
        path("*.txt"),
        val(exp_id),
        emit: modkit_dmr
    path "*.log",
        emit: log
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def suffix = task.ext.suffix ?: "${exp_id.id}"
    def threads = task.cpus * 2
    """
    pigz -dkc ${ref} > ${ref.baseName}

    modkit dmr pair \
        -a ${ctl_pileup} \
        -b ${exp_pileup} \
        ${args} \
        -o ${prefix}-${suffix}_dmr_results.txt \
        --ref ${ref.baseName} \
        --base ${base} \
        --threads ${threads} \
        --header \
        --log-filepath ${prefix}-${suffix}-dmr.log

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        modkit: \$( modkit --version | sed 's/^.*mod_kit //; s/Using.*\$//')
    END_VERSIONS
    """
}


process MODKIT_EXTRACT_FULL {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/modkit:latest'

    tag "$meta.id"
    label 'process_medium_cpu'
    label 'process_medium_high_memory'
    label 'process_low_time'

    input:
    tuple val(meta),
        path(bam),
        path(bam_index)

    output:
    tuple val(meta),
        path("*.txt"),
        emit: modkit_read_mods
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    modkit extract full \
        ${bam} \
        ${prefix}-read-modifications.txt \
        --threads ${threads} \
        --queue-size 5000 \
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        modkit: \$( modkit --version | sed 's/^.*mod_kit //; s/Using.*\$//')
    END_VERSIONS
    """
}



process MODKIT_SUMMARY_PER_FEATURE {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/modkit:latest'

    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta),
        path(bedmethyl),
        path(bedmethyl_index),
        path(slim_features_bed)

    output:
    tuple val(meta), path("*.tsv"),
        emit: modkit_summary
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: '--mod-codes a'
    def prefix = task.ext.prefix ?: "${meta.id}"

    """
    modkit stats \
        ${args} \
        --regions ${slim_features_bed} \
        -o ${prefix}-MODSTATS-PER-FEATURE.tsv \
        ${bedmethyl}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        modkit: \$( modkit --version | sed 's/^.*mod_kit //; s/Using.*\$//')
    END_VERSIONS
    """
}
