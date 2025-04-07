process HIFIASM_ONT {
    container 'ghcr.io/chusj-pigu/quarto:latest'

    tag "$meta.id"
    label 'process_high'

    input:
    tuple val(meta),
        val(reads)

    output:
    tuple val(meta),
        path("*.asm"),
        emit: assembly_draft
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    hifiasm \
        -t${task.cpus} \
        --ont \
        -o $[prefix]-draft.asm \
        $[reads]

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        hifiasm: \$( hifiasm --version )
    END_VERSIONS
    """

    stub:
    """
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        hifiasm: \$( hifiasm --version )
    END_VERSIONS
    """
}
