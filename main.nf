process MODKIT_PILEUP {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/bamdep:latest'

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
    bamdep \
        -i a.bam \
        -o a.png \
        -s 'subtitle'

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bamdep: \$( bamdep --version  | sed 's/^.*mod_kit //; s/Using.*\$//')
    END_VERSIONS
    """
}
