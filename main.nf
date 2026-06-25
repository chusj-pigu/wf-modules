process STELLERATOR {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/stellerator:latest"

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
        val(gene),
        val(partner)

    output:
    tuple val(meta),
        path("*.fq.gz"),
        emit: reads
    tuple val(meta),
        path("*.tsv"),
        emit: table
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args    = task.ext.args ?: ''
    def prefix  = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    def gtf     = refid == "hs1" ? "hs1.ncbiRefSeq.gtf" : "${refid}.refGene.gtf"
    """
    stellerator \\
        --bam ${bam}  \\
        --annotation /opt/data/${gtf} \\
        --gene ${gene} \\
	    --partner-gene ${partner} \\
        --output-tsv ${prefix}-stellerator-${gene}-${partner}.tsv \\
        --output-fasta ${prefix}-stellerator-${gene}-${partner}.fq.gz \\
        --threads ${threads} --verbose

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        Stellerator : Pre-release
    END_VERSIONS
    """
}
