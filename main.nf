process GXF_TO_BED {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/gxf2bed:latest'

    label 'process_medium'

    input:
    path(gxf)
    val(feature)

    output:
    path("*.bed"),
        emit: bed
    path("*.gxf2bed.command.txt"),
        emit: command
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def threads = task.cpus
    def prefix = gxf.simpleName
    """
    #!/usr/bin/env sh
    gxf2bed \
        --input ${gxf} \
        --output ${prefix}.bed \
        --parent-feature ${feature} \
        --threads ${threads} \
        ${args}

    cat <<-'END_COMMAND' > ${prefix}.gxf2bed.command.txt
    gxf2bed --input ${gxf} --output ${prefix}.bed --parent-feature ${feature} --threads ${threads} ${args}
    END_COMMAND


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        gxf2bed: \$(gxf2bed --version 2>&1 | tail -n1 | sed 's/^.*gxf2bed //; s/Using.*\$//')
    END_VERSIONS
    """
}
