process TUCAN_CLASSIFY {
    container "ghcr.io/chusj-pigu/tucan:latest"

    tag "$meta.id"
    label "process_medium_low_cpu"              // Label for mpgi drac cpu alloc
    label "process_medium_low_memory"         // Label for mpgi drac memory alloc
    label "process_medium_low_time"

    input:
    tuple val(meta),
        path(bedmethyl)

    output:
    tuple val(meta),
        path("*_tucan_output.csv"),
        emit: csv
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    tucan \\
        -i ${bedmethyl} \\
        -m /tucan/models/model.zip \\
        -c 10000 \\
        -s 100 \\
        --file_type bed \\
        -o ${prefix}_tucan_output.csv
    """
}
