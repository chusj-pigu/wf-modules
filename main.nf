process NASVAR_PIPELINE {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/nasvar:a37ea268c92ded8b7ef5d02663fb65092fd656b3"

    label 'process_medium'                    // nf-core labels
    label "process_medium_cpu"                 // Label for mpgi drac cpu alloc
    label "process_medium_mid_memory"         // Label for mpgi drac memory alloc
    label "process_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        path(repeats_bed),
        path(targets_bed)
    tuple val(meta2), path(fasta)
    tuple val(meta3), path(fai)

    output:
    tuple val(meta), path("*.breakpoints.fa"), emit: breakpoints
    tuple val(meta), path("*.coverage_100k.bin"), emit: coverage_bin
    tuple val(meta), path("*.coverage.tsv"), emit: coverage_tsv
    tuple val(meta), path("*.gc_corrected.svg"), emit: karyo_baf
    tuple val(meta), path("*.maf"), emit: maf
    tuple val(meta), path("*.nasvar.zip"), emit: zip
    tuple val(meta), path("*.report.html"), emit: report_html
    tuple val(meta), path("*.report.md"), emit: report_md
    tuple val(meta), path("*.result.json"), emit: json
    tuple val(meta), path("*.slice.bam"), emit: slice_bam
    tuple val(meta), path("*.slice.bam.bai"), emit: slice_bai
    tuple val(meta), path("*.slice.fa.gz"), emit: slice_fa
    tuple val(meta), path("*.slice.fa.gz.fai"), emit: slice_fai
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
    gunzip /app/nasvar/files/maf_sites_all_${meta2.id}.tsv.gz
    gunzip /app/nasvar/files/repeats_${meta2.id}.bed.gz
    gunzip /app/nasvar/files/${gff}.gz

    nasvar pipeline \\
        ${bam} \\
        ${repeats_bed} \\
        ${enriched_bed} \\
        /app/nasvar/files/maf_sites_all_${meta2.id}.tsv \\
        ${targets_bed} \\
        ${fasta} \\
        /app/nasvar/files/${gff} \\
        --out-prefix ${prefix} \\
        --config ${pipeline_config} \\
        --reference ${reference_json} \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        nasvar: \$(echo \$(nasvar --version 2>&1) | awk '{print \$NF}' )
    END_VERSIONS
    """
}