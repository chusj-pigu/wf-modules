process QDNASEQ_CALL {

    //TODO: SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/qdnaseq:latest'
    label 'local'
    label 'process_low'
    label 'process_single_cpu'
    label 'process_medium_mid_memory'
    label 'process_low_time'

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        val(ref_id)

    output:
    tuple val(meta),
        path("*calls.vcf"),
        emit: call_vcf
    tuple val(meta),
        path("*calls.bed"),
        emit: calls_bed
    tuple val(meta),
        path("*segs.vcf"),
        emit: segs_vcf
    tuple val(meta),
        path("*segs.bed"),
        emit: segs_bed
    tuple val(meta),
        path("*segs.seg"),
        emit: segs_seg
    tuple val(meta),
        path("*cov.png"),
        emit: cov_png
    tuple val(meta),
        path("*noise_plot.png"),
        emit: noise_png
    tuple val(meta),
        path("*isobar_plot.png"),
        emit: isobar_png
    path "versions.yml",
        emit: versions

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    def binsize = params.qdnaseq_binsize
    """
    call_qdnaseq.R \\
        -b ${bam} \\
        -r ${ref_id} \\
        --binsize ${binsize} \\
        --prefix ${prefix}_cnv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        R: "\$(echo 'cat(sub(\"R version ([0-9.]+) \\\\(.*\\\\)\", \"\\\\1\", R.version.string)' | R --vanilla --slave)"
        QDNAseq: "\$(echo 'cat(as.character(packageVersion(\"QDNAseq\")))' | R --vanilla --slave)"
    END_VERSIONS
    """
}
