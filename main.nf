process MINIMAP2_ALIGN {
    tag "$meta.id"
    label 'process_high'                    // nf-core labels
    label "process_medium_high_cpu"       // Label for mpgi drac cpu alloc
    label "process_medium_memory"         // Label for mpgi drac memory alloc
    label params.mapping_small ? "process_medium_low_time" : "process_medium_time" // Label for mpgi drac time alloc

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
