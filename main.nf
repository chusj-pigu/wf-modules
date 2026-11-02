process NASVAR_PIPELINE {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/nasvar:4f4033bdf40a5503fd555caee4c5d0d340cc1400"

    label 'process_medium'                    // nf-core labels
    label "process_medium_cpu"                 // Label for mpgi drac cpu alloc
    label "process_medium_mid_memory"         // Label for mpgi drac memory alloc
    label "process_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        path(enriched_bed),
        path(targets_bed)
    tuple val(meta2), path(fasta)
    tuple val(meta3), path(fai)

    output:
    tuple val(meta), path("*.result.json"),               emit: json
    tuple val(meta), path("*.report.md"),                 emit: report_md
    tuple val(meta), path("*.report.html"),               emit: report_html
    tuple val(meta), path("*.maf"),                       emit: maf
    tuple val(meta), path("*.coverage.tsv"),              emit: coverage_tsv,             optional: true
    tuple val(meta), path("*.coverage.gc_adjusted.tsv"),  emit: coverage_gc_adjusted_tsv, optional: true
    tuple val(meta), path("*.coverage_100k.bin"),         emit: coverage_bin,             optional: true
    tuple val(meta), path("*.breakpoints.fa"),            emit: breakpoints,              optional: true
    tuple val(meta), path("*.karyotype.svg"),                    emit: karyotype_svg,               optional: true
    tuple val(meta), path("*.karyotype.gc_corrected.svg"),       emit: karyotype_gc_corrected_svg,  optional: true
    tuple val(meta), path("*.karyotype_baf.gc_corrected.svg"),   emit: karyotype_baf_svg,           optional: true
    tuple val(meta), path("*.gc_vs_coverage.svg"),               emit: gc_vs_coverage_svg,          optional: true
    tuple val(meta), path("*.gc_vs_coverage.gc_corrected.svg"),  emit: gc_vs_coverage_gc_corrected_svg, optional: true
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def gff = meta2.id == "hg38" ? "GCF_000001405.40_GRCh38.p14_genomic.gff" :
        "GCF_009914755.1_T2T-CHM13v2.0_genomic.gff"
    def reference_json = meta2.id == "hg38" ? "/app/nasvar/config/GRCh38_reference.json" :
        "/app/nasvar/config/T2T-CHM13v2.0_reference.json"
    def pipeline_config = meta2.id == "hg38" ? "/app/nasvar/config/peds_leukemia_config.GRCh38.json" :
        "/app/nasvar/config/peds_leukemia_config.json"
    """
    gunzip -c /app/nasvar/files/maf_sites_all_${meta2.id}.tsv.gz > maf_sites_all_${meta2.id}.tsv
    gunzip -c /app/nasvar/files/repeats_${meta2.id}.bed.gz       > repeats_${meta2.id}.bed
    gunzip -c /app/nasvar/files/${gff}.gz                        > ${gff}

    nasvar pipeline \\
        ${bam} \\
        repeats_${meta2.id}.bed \\
        ${enriched_bed} \\
        maf_sites_all_${meta2.id}.tsv \\
        ${targets_bed} \\
        ${fasta} \\
        ${gff} \\
        ${prefix} \\
        --config ${pipeline_config} \\
        --reference ${reference_json} \\
        ${args}


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        nasvar: \$(echo \$(nasvar --version 2>&1) | awk '{print \$NF}' )
    END_VERSIONS
    """
}
