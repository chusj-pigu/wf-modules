
process BEDTOOLS_INTERSECT {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/bedtools:latest'

    tag "$meta.id"
    label 'process_medium'

    input:
    tuple val(meta),
        path(file1),
        path (file1_index)
    path(file2)
    val(extra)
    val(output_format)


    output:
    tuple val(meta),
        path("*.${output_format}"),
        emit: mapped_features
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def extra_id = extra ?: "${extra}"
    """
    bedtools intersect \
        -a ${file2} \
        -b ${file1} \
        -wa \
        -wb \
        ${args} > ${prefix}-${extra_id}-mapped_features.${output_format}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bedtools: \$( bedtools --version  | sed 's/bedtools v//' )
    END_VERSIONS
    """
}


process BEDTOOLS_INTERSECT_BAM {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/bedtools:latest'

    tag "$meta.id"
    label 'process_medium'

    input:
    tuple val(meta),
        path(file1),
        path (file1_index)
    path(file2)
    val(extra)
    val(output_format)

    output:
    tuple val(meta),
        path("*.${output_format}"),
        emit: mapped_features
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def extra_id = extra ?: "${extra}"
    """
    bedtools intersect \
        -a ${file1} \
        -b ${file2} \
        ${args} > ${prefix}-${extra_id}-mapped_features.${output_format}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bedtools: \$( bedtools --version  | sed 's/bedtools v//' )
    END_VERSIONS
    """
}

process BEDTOOLS_LEFTOUTER {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/bedtools:latest'

    tag "$meta.id"
    label 'process_medium'

    input:
    tuple val(meta),
        path(file1),
        path (file1_index)
    path(file2)
    val(extra)
    val(output_format)

    output:
    tuple val(meta),
        path("*.${output_format}"),
        emit: mapped_features
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def extra_id = extra ?: "${extra}"
    """
    bedtools intersect \
        -a ${file1} \
        -b ${file2} \
        -v \
        ${args} > ${prefix}-${extra_id}-mapped_features.${output_format}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bedtools: \$( bedtools --version | sed 's/bedtools v//' )
    END_VERSIONS
    """
}


process BEDTOOLS_SUBTRACT {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/bedtools:latest'

    tag "$meta.id"
    label 'process_low'
    label 'process_single_cpu'
    label 'process_very_low_memory'
    label 'process_very_low_time'

    input:
    tuple val(meta),
        path(bed_panel),
        path (bed_chr)


    output:
    tuple val(meta),
        path("*.bed"),
        emit: bed
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    bedtools subtract \\
        ${args} \\
        -a ${bed_chr} \\
        -b ${bed_panel} \\
        > ${prefix}_background.bed

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bedtools: \$( bedtools --version  | sed 's/bedtools v//' )
    END_VERSIONS
    """
}
