process STURGEON_INPUT_TOBED {
    container "ghcr.io/chusj-pigu/sturgeon:latest" // TO DO: SET CONTAINER TO FIXED VERSION

    tag "$meta.id"
    label 'process_high'                    // nf-core labels
    label "process_medium_cpu"              // Label for mpgi drac cpu alloc
    label "process_higher_memory"         // Label for mpgi drac memory alloc
    label "process_medium_high_time"

    input:
    tuple val(meta),
        path(bedmethyl)

    output:
    tuple val(meta),
        path("sturgeon_bed"),
        emit: dir
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    //def prefix = task.ext.prefix ?: "${meta.id}"
    """
    sturgeon \\
        inputtobed \\
        ${args} \\
        -i ${bedmethyl} \\
        -o sturgeon_bed \\
        -s modkit_pileup

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        sturgeon: \$(sturgeon -v | awk '/version:/ {print \$NF}')
    END_VERSIONS
    """
}

process STURGEON_PREDICT {
    container "ghcr.io/chusj-pigu/sturgeon:latest" // TO DO: SET CONTAINER TO FIXED VERSION

    tag "$meta.id"
    label 'process_high'                    // nf-core labels
    label "process_medium_low_cpu"              // Label for mpgi drac cpu alloc
    label "process_medium_mid_memory"         // Label for mpgi drac memory alloc
    label "process_low_time"

    input:
    tuple val(meta),
        path(calls)

    output:
    tuple val(meta),
        path("sturgeon"),
        emit: dir
    tuple val(meta),
        path("sturgeon/*.pdf"),
        emit: pdf
    tuple val(meta),
        path("sturgeon/*.csv"),
        emit: pred
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    //def prefix = task.ext.prefix ?: "${meta.id}"
    """
    sturgeon \\
        predict \\
        ${args} \\
        -i ${calls} \\
        -o sturgeon \\
        --model-files /sturgeon/sturgeon/include/models/general.zip \\
        --plot-results

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        sturgeon: \$(sturgeon -v | awk '/version:/ {print \$NF}')
    END_VERSIONS
    """
}
