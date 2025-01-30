process MODKIT_PILEUP {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/modkit:latest'

    tag "$meta.id"
    label 'process_high'
    errorStrategy { task.attempt <= 3 ? 'retry' : 'terminate' }
    
    input:
    tuple val(meta), 
        path(in_bam),
        path(bam_index)

    output:
    tuple val(meta),
        path("*.bed"),
        emit: bedmethyl
    path "versions.yml", 
        emit: versions

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
    label 'process_high'
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
    label 'process_high'
    errorStrategy { task.attempt <= 3 ? 'retry' : 'terminate' }
    
    input:
    tuple val(meta),
        path(ctl_pileup),
        path(ctl_index),
        val(exp_id),
        path(exp_pileup),
        path(exp_index)
    path(ref)
    val(base)

    output:
    tuple val(meta), path("*.txt"), emit: modkit_dmr
    path "*.log"                  , emit: log
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def suffix = task.ext.suffix ?: "${exp_id.id}"
    def threads = task.cpus
    """
    pigz -dkc ${ref} > ${ref.baseName}

    modkit dmr pair \
        -a ${ctl_pileup} \
        -b ${exp_pileup} \
        ${args} \
        -o ${prefix}-${suffix}_dmr_results.txt \
        --ref ${ref.baseName} \
        --base ${base} \
        --threads ${threads} \
        --header \
        --log-filepath ${prefix}-${suffix}-dmr.log

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        modkit: \$( modkit --version )
    END_VERSIONS
    """
}


process MODKIT_EXTRACT_FULL {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/modkit:latest'

    tag "$meta.id"
    label 'process_high'
    errorStrategy { task.attempt <= 3 ? 'retry' : 'terminate' }
    
    input:
    tuple val(meta),
        path(bam),
        path(bam_index)

    output:
    tuple val(meta), path("*.txt"), emit: modkit_read_mods
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    modkit extract full \
        ${bam} \
        ${prefix}-read-modifications.txt \
        -t ${threads} \
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        modkit: \$( modkit --version )
    END_VERSIONS
    """
}