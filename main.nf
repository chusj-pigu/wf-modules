process STELLERATOR {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/stellerator:5723fc7c4383bc34f07a9e7c159f9205ce1f8e08"

    label 'process_low'                    // nf-core labels
    label "process_low_cpu"                 // Label for mpgi drac cpu alloc
    label "process_medium_low_memory"         // Label for mpgi drac memory alloc
    label "process_medium_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        val(refid),
        path(fusion_list)

    output:
    tuple val(meta),
        path("*.vcf"),
        emit: vcf
    tuple val(meta),
        path("*.tsv"),
        emit: tsv
    tuple val(meta),
        path("*.fasta.gz"),
        emit: fasta
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args    = task.ext.args ?: ''
    def prefix  = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    def gtf     = "${refid}.ncbiRefSeq.gtf"
    """
    stellerator \\
        --bam ${bam} \\
        --annotation /opt/data/${gtf} \\
        --loci ${fusion_list} \\
        --output-vcf ${prefix}.vcf \\
        --threads ${threads} --verbose

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        Stellerator : \$(stellerator --version | awk '{print \$2}')
    END_VERSIONS
    """
}
