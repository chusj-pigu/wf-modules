process CHOPPER_LENGTH {
    tag "$meta.id"
    label 'process_low'

    container "ghcr.io/chusj-pigu/chopper:latest" // TO DO: SET CONTAINER TO FIXED VERSION

    input:
    tuple val(meta), path(reads)
    val max_len
    val qual

    output:
    tuple val(meta), path("*.{fastq.gz,fq.gz}"), emit: reads
    path "versions.yml"                , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def output_ext = reads.baseName.endsWith('fastq') ? "fastq.gz" : "fq.gz"
    """
    chopper \\
        --threads ${task.cpus} \\
        -q ${qual} \\
        --maxlength ${max_len} \\
        ${args} \\
        -i ${reads} \\
        | pigz -p ${task.cpus} > ${prefix}_filt.${output_ext}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        chopper: \$(chopper -V | cut -d ' ' -f2 | sed 's/v//')
    END_VERSIONS
    """
}
