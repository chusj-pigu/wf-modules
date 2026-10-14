process DEEPSOMATIC_TUMORONLY {
    // TODO SET CONTAINER TO FIXED VERSION

    container "google/deepsomatic:1.10.0"

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
    tuple val(meta2), path(fasta)
    tuple val(meta3), path(fai)

    output:
    tuple val(meta), path("${prefix}.vcf.gz")      ,  emit: vcf
    tuple val(meta), path("${prefix}.vcf.gz.tbi")  ,  emit: vcf_tbi
    tuple val(meta), path("${prefix}.g.vcf.gz")    ,  emit: gvcf
    tuple val(meta), path("${prefix}.g.vcf.gz.tbi"),  emit: gvcf_tbi
    tuple val("${task.process}"), val("deepsomatic"), val("1.10.0"), emit: versions_deepsomatic, topic: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    // Exit if running this module with -profile conda / -profile mamba
    if (workflow.profile.tokenize(',').intersect(['conda', 'mamba']).size() >= 1) {
        error "DEEPSOMATIC module does not support Conda. Please use Docker / Singularity / Podman instead."
    }
    def args = task.ext.args ?: '--model_type=ONT_TUMOR_ONLY'
    prefix = task.ext.prefix ?: "${meta.id}"
    def regions = bed ? "--regions=${bed}" : ""
    """
    run_deepsomatic \\
        --ref=${fasta} \\
        --reads_tumor=${bam} \\
        --output_vcf=${prefix}.vcf.gz \\
        --output_gvcf=${prefix}.g.vcf.gz \\
        --sample_name_tumor="${prefix}" \\
        ${args} \\
        ${regions} \\
        --intermediate_results_dir=tmp \\
        --num_shards=${task.cpus}
    """

    stub:
    // Exit if running this module with -profile conda / -profile mamba
    if (workflow.profile.tokenize(',').intersect(['conda', 'mamba']).size() >= 1) {
        error "DEEPSOMATIC module does not support Conda. Please use Docker / Singularity / Podman instead."
    }
    prefix = task.ext.prefix ?: "${meta.id}"
    """
    echo "" | gzip > ${prefix}.vcf.gz
    touch ${prefix}.vcf.gz.tbi
    echo "" | gzip > ${prefix}.g.vcf.gz
    touch ${prefix}.g.vcf.gz.tbi
    """
}
