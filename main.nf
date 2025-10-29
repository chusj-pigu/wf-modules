process CLAIR3_CALL {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/clair3:latest"

    label 'process_high'                    // nf-core labels
    label "process_high_cpu"       // Label for mpgi drac cpu alloc
    label "process_higher_memory"         // Label for mpgi drac memory alloc
    label "process_medium_low_time"
    label "singleton" // This process is a singleton, so it will not run in parallel

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        path(ref),
        path(ref_idx),
        val(model),
        path(bed)

    output:
    tuple val(meta),
        path("${meta.id}/merge_output.vcf.gz"),
        emit: vcf
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def bed_in = params.realtime >= 1 && params.realtime <= 72 ? "--bed_fn=${bed}" : ""
    """
    ## Run Clair3
    run_clair3.sh \\
        ${args} \\
        --threads=${task.cpus} \\
        --sample_name=${prefix} \\
        ${bed_in} \\
        --platform='ont' \\
        --model_path="/opt/models/${model}" \\
        --bam_fn=${bam} \\
        --ref_fn=${ref} \\
        -o ${prefix}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        Clair3:  \$(echo \$(run_clair3.sh --version 2>&1) | awk '{print \$NF}' )
    END_VERSIONS
    """
}
