process MPGI_SUMMARIZE_MODS {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/tools:latest'
    containerOptions '--no-home --writable-tmpfs'

    tag "$meta.id"
    label 'process_medium'
    errorStrategy { task.attempt <= 3 ? 'retry' : 'terminate' }

    input:
    tuple val(meta),
        path(mods),
        path(mapped)

    output:
    tuple val(meta),
        path("*.csv"),
        optional: true,
        emit: modifications_summary
    path("versions.yml"),
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    nu --plugins \
        '[/usr/local/cargo/bin/nu_plugin_polars]' \
        /opt/scripts/summarize_modifications.nu \
        ${mods} \
        ${mapped} \
        ${prefix}.csv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        nushell: \$( nu --version )
    END_VERSIONS
    """
}

process MPGI_COUNTFEATURES {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/tools:latest'

    tag "$meta.id"
    label 'process_medium'
    errorStrategy { task.attempt <= 3 ? 'retry' : 'terminate' }

    input:
    tuple val(meta),
        path(input)

    output:
    tuple val(meta),
        path("*.csv"),
        emit: features_summary
    path("versions.yml"),
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    nu --plugins \
        '[/usr/local/cargo/bin/nu_plugin_polars]' \
        /opt/scripts/countfeatures.nu \
        ${input} \
        ${prefix}-features-summary.csv


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        nushell: \$( nu --version )
    END_VERSIONS
    """
}

process MPGI_GETINTRONS {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/tools:latest'

    label 'process_medium'
    errorStrategy { task.attempt <= 3 ? 'retry' : 'terminate' }

    input:
    path(input)

    output:
    path("*.gff"),
        emit: introns
    path("versions.yml"),
        emit: versions
    when:
    task.ext.when == null || task.ext.when

    script:
    """
    Rscript \
        /opt/scripts/R/extract_introns.R \
        ${input}


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        R: \$(R --version | head -n 1 | awk '{print ""\$3}')
        GenomicFeatures: \$(Rscript -e 'cat(as.character(packageVersion("GenomicFeatures")))')
        argparse: \$(Rscript -e 'cat(as.character(packageVersion("argparse")))')
        GenomicRanges: \$(Rscript -e 'cat(as.character(packageVersion("GenomicRanges")))')
        rtracklayer: \$(Rscript -e 'cat(as.character(packageVersion("rtracklayer")))')
    END_VERSIONS
    """
}

process MPGI_COMPARE_INTRONIC {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/tools:latest'

    label 'process_medium'
    errorStrategy { task.attempt <= 3 ? 'retry' : 'terminate' }

    input:
    tuple val(meta),
        path(intronic_reads),
        path(non_intronic_reads)

    output:
    path("*.csv"),
        emit: premrna_comparison
    path("versions.yml"),
        emit: versions
    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    nu --plugins \
        '[/usr/local/cargo/bin/nu_plugin_polars]' \
        /opt/scripts/count_reads.nu \
        ${intronic_reads} \
        ${non_intronic_reads} \
        ${prefix}-premrna-comparison.csv


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        nushell: \$( nu --version )
    END_VERSIONS
    """
}
