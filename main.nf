process MARLIN_PILEUP {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/marlin:latest'

    tag "$meta.id"
    label 'process_medium_high_cpu'
    label 'process_medium_mid_memory'
    label 'medium_low_time'

    input:
    tuple val(meta),
        path(in_bam),
        path(bam_index),
        val(refid),
        path(ref)

    output:
    tuple val(meta),
        path("*.pileup"),
        emit: bedmethyl
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: '--combine-mods --only-tabs'
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus * 2
    def ref_type = refid in ["hg38", "GRCh38"] ? "hg38" : "hg19"
    """
    modkit \\
        pileup \\
        --ref ${ref} \\
        --include-bed /opt/MARLIN/MARLIN_realtime/files/marlin_v1.probes_${ref_type}.bed \\
        -t ${threads} \\
        ${args} \\
        ${in_bam} \\
        ${prefix}.bed

    mv ${prefix}.bed ${prefix}.bed.pileup

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        modkit: \$( modkit --version  | sed 's/^.*mod_kit //; s/Using.*\$//')
    END_VERSIONS
    """
}

process MARLIN_MERGE {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/marlin:latest'

    tag "$meta.id"
    label 'process_low_cpu'
    label 'process_medium_mid_memory'
    label 'medium_low_time'

    input:
    tuple val(meta),
        path(bedmethyl),
        val(refid)

    output:
    tuple val(meta),
        path("*.bed"),
        emit: merged_bedmethyl
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: '--vanilla'
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    def ref_type = refid in ["hg38", "GRCh38"] ? "hg38" : "hg19"
    """
    Rscript \\
        ${args} \\
        /opt/MARLIN/MARLIN_realtime/2_process_pileup.R \\
        /opt/MARLIN/MARLIN_realtime/files/marlin_v1.probes_${ref_type}.bed

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        R: \$(R --version | head -n 1 | awk '{print ""\$3}')
        Marlin: v1.0
    END_VERSIONS
    """
}

process MARLIN_PREDICT {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/marlin:latest'

    tag "$meta.id"
    label 'process_low_cpu'
    label 'process_medium_mid_memory'
    label 'medium_low_time'

    input:
    tuple val(meta),
        path(merge_bedmethyl)

    output:
    tuple val(meta),
        path("*.pred.txt"),
        emit: pred
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: '--vanilla'
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    Rscript \\
        ${args} \\
        /opt/MARLIN/MARLIN_realtime/3_marlin_predictions_live.R \\
        ${prefix} \\
        /opt/MARLIN/MARLIN_realtime/files/marlin_v1.features.RData \\
        /opt/MARLIN/MARLIN_realtime/files/marlin_v1.model.hdf5 \\
        /opt/MARLIN/MARLIN_realtime/files/marlin_v1.class_annotations.xlsx

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        R: \$(R --version | head -n 1 | awk '{print ""\$3}')
        Marlin: v1.0
    END_VERSIONS
    """
}

process MARLIN_PLOT {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/marlin:latest'

    tag "$meta.id"
    label 'process_low_cpu'
    label 'process_low_memory'
    label 'process_low_time'

    input:
    tuple val(meta),
        path(pred)

    output:
    tuple val(meta),
        path("*.pred.pdf"),
        emit: pred_pdf
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: '--vanilla'
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    Rscript \\
        ${args} \\
        /opt/MARLIN/MARLIN_realtime/4_plot_live2.R \\
        ${prefix} \\
        /opt/MARLIN/MARLIN_realtime/files/marlin_v1.class_annotations.xlsx

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        R: \$(R --version | head -n 1 | awk '{print ""\$3}')
        Marlin: v1.0
    END_VERSIONS
    """
}
