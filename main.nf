process RUSTQC_RNA {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/rustqc:latest'
    // TODO : SET LEVEL OF RESSOURCES
    tag "$meta.id"
    label 'process_medium'
    label 'process_medium_high_cpu'
    label 'process_medium_mid_memory'
    label 'process_medium_low_time'

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        path(gtf)

    output:
    tuple val(meta),
        path("${meta.id}/featurecounts/${meta.id}.biotype_counts_rrna_mqc.tsv"),
        emit: rrna_perc
    tuple val(meta),
        path("${meta.id}/featurecounts/${meta.id}.biotype_counts.tsv"),
        emit: biotype_counts
    tuple val(meta),
        path("${meta.id}/preseq/${meta.id}.lc_extrap.txt"),
        emit: complexity_curve
    tuple val(meta),
        path("${meta.id}/qualimap/rnaseq_qc_results.txt"),
        emit: qualimap
    tuple val(meta),
        path("${meta.id}/rseqc/junction_annotation/${meta.id}.junction_annotation.txt"),
        emit: junctions
    tuple val(meta),
        path("${meta.id}/rseqc/tin/${meta.id}.summary.txt"),
        emit: tin
    tuple val(meta),
        path("${meta.id}/qualimap/images_qualimapReport/Transcript coverage histogram.svg"),
        emit: cov_hist_plot
    tuple val(meta),
        path("${meta.id}/qualimap/*"),
        emit: qualimap_dir
    path "versions.yml",
        emit: versions

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    rustqc rna ${bam} \\
        --gtf ${gtf} \\
        --sample-name ${prefix} \\
        -t ${threads} \\
        ${args} \\
        -o ${prefix}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        rustqc: \$(echo \$(rustqc -V 2>&1) | sed 's/^.*rustqc //; s/Using.*\$//')
    END_VERSIONS
    """
}
