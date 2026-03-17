process SQANTI3_QC {
    tag "$meta.id"
    label 'process_low'                    // nf-core labels
    label "process_medium_cpu"       // Label for mpgi drac cpu alloc
    label "process_higher_memory"         // Label for mpgi drac memory alloc
    label "process_low_time"

    container "ghcr.io/chusj-pigu/sqanti3:7d6264ade1bcaa7f29b3974470f20b91e97dc5fd"

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
    python3 /opt/app/SQANTI3/sqanti3_qc.py \\
        ${args} \\
        -t ${task.cpus} \\
        -o ${prefix} \\
        -d ${prefix}_sqanti3 \\
        --report skip \\
        --isoforms ${fasta} \\
        --refGTF ${ref_gtf} \\
        --refFasta ${ref_fa}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        sqanti3: 5.5.4 (fork https://github.com/charlenelawdes/SQANTI3)
    END_VERSIONS
    """
}
