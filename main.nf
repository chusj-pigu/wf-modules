process MODKIT_PILEUP {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/modkit:latest'

    tag "$meta.id"
    label 'process_cpu_med'
    label 'process_memory_med'
    label 'process_time_med'
    errorStrategy { task.attempt <= 3 ? 'retry' : 'terminate' }
    
    input:
    tuple val(meta), path(in_bam), path(bam_index)

    output:
    tuple val(meta), path("*.bed"), emit: bedmethyl
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: '--with-header'
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    modkit \\
        pileup \\
        -t ${threads} \\
        ${args} \\
        ${in_bam} \\
        ${prefix}.bed 

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        modkit: \$( modkit --version )
    END_VERSIONS
    """
}

process MODKIT_SUMMARY {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/modkit:latest'

    tag "$meta.id"
    label 'process_cpu_med'
    label 'process_memory_med'
    label 'process_time_med'
    errorStrategy { task.attempt <= 3 ? 'retry' : 'terminate' }
    
    input:
    tuple val(meta), path(in_bam), path(bam_index)

    output:
    tuple val(meta), path("*.txt"), emit: modkit_summary
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus

    """
    modkit \\
        summary \\
        ${in_bam} \\
        --threads ${threads} \\
        ${args} \\
        --tsv > ${prefix}_modkit_summary.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        modkit: \$( modkit --version )
    END_VERSIONS
    """
}

process MODKIT_DMR_PAIR {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/modkit:latest'

    tag "$meta.id"
    label 'process_cpu_med'
    label 'process_memory_med'
    label 'process_time_med'
    errorStrategy { task.attempt <= 3 ? 'retry' : 'terminate' }
    
    input:
    tuple val(meta),
        path(ctl_pileup),
        path(ctl_index),
        val(exp_id),
        path(exp_pileup),
        path(exp_index)
    path(ref)

    output:
    tuple val(meta), path("*.txt"), emit: modkit_dmr
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    
    pigz -d ${ref}

    modkit dmr pair \
        -a ${ctl_pileup} \
        -b ${exp_pileup} \
        ${args} \
        -o ${prefix}_dmr_results.txt \
        --ref ${ref.baseName} \
        --base A \
        --threads ${threads} \
        --log-filepath ${prefix}-dmr.log

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        modkit: \$( modkit --version )
    END_VERSIONS
    """
}