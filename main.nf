process GXF_TO_BED {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/gxf2bed:latest'

    label 'process_medium'

    input:
    path(gxf)
    val(feature)

    output:
    path("*.bed.gz"),
        emit: bed
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def threads = task.cpus
    """
    gxf2bed \
        --input ${gxf} \
        --output ${gxf.simpleName}.bed.gz \
        --feature ${feature} \
        --threads ${threads} \
        ${args}


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        gxf2bed: echo \$(gxf2bed --version 2>&1 | tail -n1 | sed 's/^.*gxf2bed //; s/Using.*\$//')
    END_VERSIONS
    """
}
