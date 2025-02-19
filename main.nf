process NANOPLOT_FASTQ {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/nanoplot:latest'

    tag "$meta.id"
    label 'process_medium'
    label 'high_mem_fast'
    label 'Nanoplot'

    input:
    tuple val(meta),
        path(fastq)

    output:
    tuple val(meta),
        path("*.png"),
        optional: true,
        emit: nanoplot
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    NanoPlot \\
        ${args} \\
        -p ${prefix} \\
        --color blue \\
        --N50 \\
        -f png \\
        -cm Blues \\
        --fastq ${fastq}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        NanoPlot: \$( NanoPlot --version )
    END_VERSIONS
    """
}

process NANOPLOT_UBAM {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/nanoplot:latest'

    tag "$meta.id"
    label 'process_medium'
    label 'high_mem_fast'
    label 'Nanoplot'

    input:
    tuple val(meta),
        path(ubam)

    output:
    tuple val(meta),
        path("*.png"),
        optional: true,
        emit: nanoplot
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    NanoPlot \\
        ${args} \\
        -p ${prefix} \\
        --color blue \\
        --N50 \\
        -f png \\
        -cm Blues \\
        --ubam ${ubam}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        NanoPlot: \$( NanoPlot --version )
    END_VERSIONS
    """
}

process NANOPLOT_BAM {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/nanoplot:latest'

    tag "$meta.id"
    label 'process_medium'
    label 'high_mem_fast'
    label 'Nanoplot'

    input:
    tuple val(meta),
        path(bam)

    output:
    tuple val(meta),
        path("*.png"),
        optional: true,
        emit: nanoplot
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    NanoPlot \\
        ${args} \\
        -p ${prefix} \\
        --color blue \\
        --N50 \\
        -f png \\
        -cm Blues \\
        --ubam ${bam}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        NanoPlot: \$( NanoPlot --version )
    END_VERSIONS
    """
}
