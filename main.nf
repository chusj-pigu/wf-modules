process CLAIRS_TO_CALL {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/clairsto:latest"

    label 'process_high'                    // nf-core labels
    label "process_medium_high_cpu"       // Label for mpgi drac cpu alloc
    label "process_medium_memory"         // Label for mpgi drac memory alloc
    label "process_medium_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        path(ref),
        path(ref_idx),
        val(chr),
        val(model)

    output:
    tuple val(meta),
        path("${meta.id}/*.vcf.gz"),
        emit: vcf
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    run_clairs_to \\
        ${args} \\
        --threads ${task.cpus} \\
        -s ${prefix} \\
        --tumor_bam_fn ${bam} \\
        --ref_fn ${ref} \\
        --platform ${model} \\
        -c ${chr} \\
        --whatshap /opt/micromamba/envs/clairs-to/bin/whatshap \\
        -o ${prefix}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        ClairS-to: "0.3.1"
    END_VERSIONS
    """
}
