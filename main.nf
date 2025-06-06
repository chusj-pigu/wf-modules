process CLAIRS_TO_CALL {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/clairsto:latest"

    label 'process_high'                    // nf-core labels
    label "process_high_cpu"       // Label for mpgi drac cpu alloc
    label "process_higher_memory"         // Label for mpgi drac memory alloc
    label "process_medium_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        path(ref),
        path(ref_idx),
        val(model)

    output:
    tuple val(meta),
        path("${meta.id}/snv.vcf.gz"),
        emit: snv
    tuple val(meta),
        path("${meta.id}/indel.vcf.gz"),
        emit: indel
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    ## Prevent clairs-to error due to missing files
    ## Run ClairS-TO
    run_clairs_to \\
        ${args} \\
        --threads ${task.cpus} \\
        -s ${prefix} \\
        --tumor_bam_fn ${bam} \\
        --ref_fn ${ref} \\
        --platform ${model} \\
        -o ${prefix}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        ClairS-TO: "0.3.1"
    END_VERSIONS
    """
}
