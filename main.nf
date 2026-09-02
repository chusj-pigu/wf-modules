process NASVAR_PIPELINE {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/nasvar:latest"

    label 'process_medium'                    // nf-core labels
    label "process_medium_cpu"                 // Label for mpgi drac cpu alloc
    label "process_medium_mid_memory"         // Label for mpgi drac memory alloc
    label "process_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        val(ref_type),
        path(ref_fasta),
        path(ref_fai),
        path(repeats_bed),
        path(enriched_bed),
        path(maf_sites),
        path(targets_bed),
        path(genes_gff3),
        path(pipeline_config),
        path(reference_json)

    output:
    tuple val(meta),
        path("*.vcf.gz"),
        emit: vcf
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    nasvar pipeline \\
        ${bam} \\
        ${repeats_bed} \\
        ${enriched_bed} \\
        ${maf_sites} \\
        ${targets_bed} \\
        ${ref_fasta} \\
        ${genes_gff3} \\
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

process NASVAR_COVERAGE {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/nasvar:latest"

    label 'medium'
    label 'process_low'
    label 'process_medium_low_cpu'
    label 'process_medium_low_memory'
    label 'process_low_time'

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        val(genome)

    output:
    tuple val(meta),
        path("*.coverage.tsv"),
        emit: cov
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def build = genome == 'hs1' ? 'chm13' : 'hg38'
    def ref_conf = genome == 'hs1' ? 'T2T-CHM13v2.0_reference.json' : 'GRCh38_reference.json'
    """
    gzip -dc /app/nasvar/files/repeats_${build}.bed.gz > repeats_${build}.bed
    nasvar coverage \\
        --bam ${bam} \\
        --reference /app/nasvar/config/${ref_conf} \\
        --repeats repeats_${build}.bed \\
        --out-prefix ${prefix}
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        nasvar: \$(echo \$(nasvar --version 2>&1) | awk '{print \$NF}' )
    END_VERSIONS
    """
}

process NASVAR_KARYOTYPE {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/nasvar:latest"

    label 'medium'
    label 'process_low'
    label 'process_medium_low_cpu'
    label 'process_medium_low_memory'
    label 'process_very_low_time'

    tag "$meta.id"

    input:
    tuple val(meta),
        path(cov),
        val(genome),
        path(maf),
        path(maf_sites)

    output:
    tuple val(meta),
        path("*.result.json"),
        emit: karyo_json
    tuple val(meta),
        path("*.gc_vs_coverage.gc_corrected.svg"),
        emit: cov_gc_corrected_svg
    tuple val(meta),
        path("*.gc_vs_coverage.svg"),
        emit: cov_svg
    tuple val(meta),
        path("*.karyotype.gc_corrected.svg"),
        emit: karyo_gc_corrected_svg
    tuple val(meta),
        path("*.karyotype.svg"),
        emit: karyo_svg
    tuple val(meta),
        path("*karyotype_baf.gc_corrected.svg"),
        emit: karyo_baf

    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def ref_conf = genome == 'hs1' ? 'T2T-CHM13v2.0_reference.json' : 'GRCh38_reference.json'
    def conf = genome == 'hs1' ? 'peds_leukemia_config.json' : 'peds_leukemia_config.GRCh38.json'
    """
    nasvar karyotype \\
        --coverage ${cov} \\
        --out-prefix ${prefix} \\
        --config /app/nasvar/config/${conf} \\
        --reference /app/nasvar/config/${ref_conf} \\
        --maf ${maf} \\
        --sites ${maf_sites} \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        nasvar: \$(echo \$(nasvar --version 2>&1) | awk '{print \$NF}' )
    END_VERSIONS
    """
}

process NASVAR_MAF {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/nasvar:latest"

    label 'medium'
    label 'process_low'
    label 'process_medium_low_cpu'
    label 'process_medium_low_memory'
    label 'process_very_low_time'

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        path(bed),
        path(maf),
        val(genome)

    output:
    tuple val(meta),
        path("*.maf"),
        emit: maf

    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def ref_conf = genome == 'hs1' ? 'T2T-CHM13v2.0_reference.json' : 'GRCh38_reference.json'
    """
    nasvar maf \\
        --reference /app/nasvar/config/${ref_conf} \\
        --bam ${bam} \\
        --out-prefix ${prefix} \\
        --enriched ${bed} \\
        --sites ${maf} \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        nasvar: \$(echo \$(nasvar --version 2>&1) | awk '{print \$NF}' )
    END_VERSIONS
    """
}

process BEDTOOLS_INTERSECT_MAF {

    container "ghcr.io/chusj-pigu/nasvar:a37ea268c92ded8b7ef5d02663fb65092fd656b3"

    label 'medium'
    label 'process_low'
    label 'process_medium_low_cpu'
    label 'process_medium_low_memory'
    label 'process_very_low_time'

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bed),
        val(chr_names),
        val(genome)

    output:
    tuple val(meta),
        path("*maf_sites.tsv"),
        emit: maf_sites
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args   = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"

    // T2T (hs1/chm13) enrichment BEDs use NCBI RefSeq accessions (NC_0609xx.1) and need
    // translating to chr* names before intersecting. hg38 BEDs are assumed to already
    // use chr* naming, so no conversion is needed there.
    def bed_stream = chr_names ? "${bed}" :
        """<(awk 'BEGIN {
            for (i=1; i<=22; i++) acc[sprintf("NC_%06d.1", 60924+i)] = "chr" i
            acc["NC_060947.1"] = "chrX"
            acc["NC_060948.1"] = "chrY"
        } \$1 in acc { print acc[\$1] "\\t" \$2 "\\t" \$3 }' ${bed})"""
    def build = genome == 'hs1' ? 'chm13' : 'hg38'
    """
    gzip -dc /app/nasvar/files/maf_sites_all_${build}.tsv.gz > maf_sites_all_${build}.tsv
    bedtools intersect \\
        $args \\
        -a <(awk '{ print \$1 "\\t" (\$2-1) "\\t" \$2 "\\t" \$3 "\\t" \$4 }' maf_sites_all_${build}.tsv) \\
        -b ${bed_stream} \\
        | awk '{ print \$1 "\\t" \$3 "\\t" \$4 "\\t" \$5 }' \\
        > ${prefix}.maf_sites.tsv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bedtools: \$( bedtools --version | sed 's/bedtools v//' )
    END_VERSIONS
    """
}
