
process GTF_TO_BED {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/gxf2bed:latest'

    tag "$meta.id"
    label 'process_cpu_med'
    label 'process_memory_med'
    label 'process_time_med'
    errorStrategy { task.attempt <= 3 ? 'retry' : 'terminate' }
    
    input:
    tuple val(meta),
        path(gxf)

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
        --output ${gxf.baseName(2)}.bed.gz \
        --feature gene_id \
        --threads ${threads} \
        ${args}


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        gxf2bed: \$( gxf2bed --version )
    END_VERSIONS
    """
}