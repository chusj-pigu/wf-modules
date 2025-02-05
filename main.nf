process MINIMAP2_ALIGN {
    tag "$meta.id"
    label 'process_high'

    conda (params.enable_conda ? "bioconda::minimap2=2.28" : null)
    container "ghcr.io/chusj-pigu/minimap2:latest" // TO DO: SET CONTAINER TO FIXED VERSION

    input:
    tuple val(meta), path(reads), path(ref)

    output:
    tuple val(meta), path("*.sam"), emit: sam
    path "versions.yml"                , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    minimap2 \\
        -y \\
        -ax \\
        map-ont \\
        ${args} \\
        -t ${task.cpus} \\
        ${ref} \\
        ${reads} > ${prefix}.${ref.simpleName}.sam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        minima2: \$(minimap2 -V | cut -d ' ' -f2 | sed 's/v//')
    END_VERSIONS
    """
}
