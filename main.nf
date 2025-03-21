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
    path "versions.yml",
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
    path "versions.yml",
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
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    Rscript \
        /opt/scripts/R/get_introns.R \
        ${input} \
        introns-summary.csv


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        R: \$(R --version | head -n 1 | awk '{print ""$3}')
        GenomicFeatures: \$(R -q -e 'cat(as.character(packageVersion("GenomicFeatures")),"\n")' | tail -n 3 | head -n 1)
    END_VERSIONS
    """
}
