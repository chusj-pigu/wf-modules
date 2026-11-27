process NASVAR_PIPELINE {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/nasvar:4078bab45f52a1417c75180ce70918cdd695af99"

    label 'process_medium'                    // nf-core labels
    label "process_medium_cpu"                 // Label for mpgi drac cpu alloc
    label "process_medium_mid_memory"         // Label for mpgi drac memory alloc
    label "process_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        path(enriched_bed, stageAs: 'bed_enriched/*'),
        path(targets_bed, stageAs: 'bed_target/*')
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
    def args   = task.ext.args   ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"

    // Everything genome-specific lives here
    def genomes = [
        hg38: [
            maf      : "maf_sites_all_hg38.tsv",
            repeats  : "hg38_repeats_cen_sat_dups.allN_PAR1_noisyMAF.bed",
            gff      : "GCF_000001405.40_GRCh38.p14_genomic.gff",
            reference: "GRCh38_reference.json",
            config   : "peds_leukemia_config.GRCh38.json",
        ],
        hs1: [
            maf      : "maf_sites_all_hs1.tsv",
            repeats  : "repeats_hs1.bed",
            gff      : "GCF_009914755.1_T2T-CHM13v2.0_genomic.gff",
            reference: "T2T-CHM13v2.0_reference.json",
            config   : "peds_leukemia_config.json",
        ],
    ]
    def g = genomes[meta2.id]

    def files_dir  = "/app/nasvar/files"
    def config_dir = "/app/nasvar/config"
    def to_unzip   = [g.maf, g.repeats, g.gff]
    """
    for f in ${to_unzip.join(' ')}; do
        gunzip -c ${files_dir}/\${f}.gz > \${f}
    done

    nasvar pipeline \\
        ${bam} \\
        ${g.repeats} \\
        ${enriched_bed} \\
        ${g.maf} \\
        ${targets_bed} \\
        ${fasta} \\
        ${g.gff} \\
        ${prefix} \\
        --config ${config_dir}/${g.config} \\
        --reference ${config_dir}/${g.reference} \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        nasvar: \$(echo \$(nasvar --version 2>&1) | awk '{print \$NF}' )
    END_VERSIONS
    """
}
