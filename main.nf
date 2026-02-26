process SQANTI3_QC {
    tag "$meta.id"
    label 'process_low'                    // nf-core labels
    label "process_low_cpu"       // Label for mpgi drac cpu alloc
    label "process_low_memory"         // Label for mpgi drac memory alloc
    label "process_low_time"

    container "ghcr.io/chusj-pigu/sqanti3:63f2175e0ebff2c8a17fda1417f6cc21d06cf328"

    input:
    tuple val(meta),
        path(fasta),
        path(ref_fa),
        path(ref_gtf)

    output:
    tuple val(meta),
        path("*_sqanti3/*junctions.txt"),
        emit: junctions
    tuple val(meta),
        path("*_sqanti3/*classification.txt"),
        emit: classification
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: '--force_id_ignore --skipORF'
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    /opt/app/sqanti3/sqanti3_qc.py \\
        ${args} \\
        -t ${task.cpus} \\
        --aligner_choice minimap2 \\
        -o ${prefix} \\
        -d ${prefix}_sqanti3 \\
        --report skip \\
        --fasta \\
        --isoforms ${fasta} \\
        --refGTF ${ref_gtf} \\
        --refFasta ${ref_fa}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        sqanti3: 5.5.4
    END_VERSIONS
    """
}
