
process BEDTOOLS_INTERSECT_BAM {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/bedtools:latest'

    tag "$meta.id"
    label 'process_cpu_med'
    label 'process_memory_med'
    label 'process_time_med'
    errorStrategy { task.attempt <= 3 ? 'retry' : 'terminate' }
    
    input:
    tuple val(meta),
        path(bam)
    path(ref_features)

    output:
    tuple val(meta), path("*.txt"), emit: mapped_features
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    bedtools intersect \
        -a ${ref_features} \
        -b ${bam} \
        -wa \
        -wb \
        ${args} > ${prefix}-mapped_features.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bedtools: \$( bedtools --version )
    END_VERSIONS
    """
}