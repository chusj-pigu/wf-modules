process CLAIR3_CALL {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/clair3:5c1b224addf317c2cfe5ab5e03f6cdb23da13303"

    label "process_gpu_clair3"
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
        path(bed)
    tuple val(meta2), path(ref)
    tuple val(meta3), path(fai)
    val(model)

    output:
    tuple val(meta),
        path("${meta.id}/merge_output.vcf.gz"),
        emit: vcf
    path "versions.yml",
        emit: versions

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    ## Run Clair3
    run_clair3.sh \\
        ${args} \\
        --threads=${task.cpus} \\
        --sample_name=${prefix} \\
        --bed_fn=${bed} \\
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
