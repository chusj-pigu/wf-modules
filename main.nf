process CHOPPER_LENGTH {
    tag "$meta.id"
    label 'process_low'

    conda (params.enable_conda ? "bioconda::chopper=0.9.0" : null)
    container "ghcr.io/chusj-pigu/chopper:latest" // TO DO: SET CONTAINER TO FIXED VERSION

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("*.fastq.gz"), emit: reads
    path "versions.yml"                , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    chopper \\
        -q 10 \\
        --maxlength 700 \\
        -i ${reads} \\
        ${args} > ${prefix}.fastq.gz

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        chopper: \$(chopper -V | cut -d ' ' -f2 | sed 's/v//')
    END_VERSIONS
    """
}
