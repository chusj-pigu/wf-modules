
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

    output:
    tuple val(meta),
        path("*.txt"),
        emit: mapped_features
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def extra = extra ?: "${extra}"
    """
    bedtools intersect \
        -a ${file2} \
        -b ${file1} \
        -wa \
        -wb \
        ${args} > ${prefix}-${extra}-mapped_features.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bedtools: \$( bedtools --version )
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

    output:
    tuple val(meta),
        path("*.txt"),
        emit: mapped_features
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def extra = extra ?: "${extra}"
    """
    bedtools intersect \
        -a ${file1} \
        -b ${file2} \
        -v \
        ${args} > ${prefix}-${extra}-mapped_features.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bedtools: \$( bedtools --version )
    END_VERSIONS
    """
}
