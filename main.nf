process MPGI_SUMMARIZE_MODS {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/tools:latest'

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
    summarize_modifications.nu \\
        ${mods} \\
        ${mapped} \\
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
    countfeatures.nu \\
        ${input} \\
        ${prefix}-features-summary.csv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        nushell: \$( nu --version )
    END_VERSIONS
    """
}