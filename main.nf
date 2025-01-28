process GXF_TO_BED {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/gxf2bed:latest'

    label 'process_medium'
    errorStrategy { task.attempt <= 3 ? 'retry' : 'terminate' }
    
    input:
    path(gxf)
    val(feature)

    output:
    tuple path("*.bed.gz"), emit: bed
    path "versions.yml"           , emit: versions

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
        gxf2bed: \$( gxf2bed --version )
    END_VERSIONS
    """
}