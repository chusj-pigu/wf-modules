process SEQKIT_STATS {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/seqkit:latest'

    tag "$meta.id"
    label 'process_cpu_low'
    label 'process_memory_low'
    label 'process_time_low'

    input:
    tuple val(meta),
        path(reads)

    output:
    tuple val(meta),
        path("*.tsv"),
        emit: stats
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: '--all'
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    seqkit stats \\
        --tabular \\
        $args \\
        $reads -o '${prefix}.tsv'

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        seqkit: \$( seqkit version | sed 's/seqkit v//' )
    END_VERSIONS
    """
}

process SEQKIT_INDEX {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/seqkit:latest'

    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta),
        path(fasta)

    output:
    tuple val(meta),
        path("*.fai"),
        emit: fasta_index
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    seqkit \\
        faidx \\
        $args \\
        $fasta

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        seqkit: \$( seqkit | sed '3!d; s/Version: //' )
    END_VERSIONS
    """

    stub:
    """
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        seqkit: \$( seqkit | sed '3!d; s/Version: //' )
    END_VERSIONS
    """
}

process SEQKIT_FQ2FA {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/seqkit:latest'

    tag "$meta.id"
    label 'process_single'

    input:
    tuple val(meta),
        path(fastq)

    output:
    tuple val(meta),
        path("*.fa.gz"),
        emit: fasta
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"

    """
    seqkit \\
        fq2fa \\
        $args \\
        -j $task.cpus \\
        -o ${prefix}.fa.gz \\
        $fastq

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        seqkit: \$( seqkit | sed '3!d; s/Version: //' )
    END_VERSIONS
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    echo "" | gzip > ${prefix}.fa.gz

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        seqkit: \$( seqkit | sed '3!d; s/Version: //' )
    END_VERSIONS
    """
}


process SEQKIT_SEQUENCE_COUNTS {

    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/seqkit:latest'

    label 'process_low'

    input:
    path(bed)
    path(fasta)
    val(base)

    output:
    path("*.tsv"),
        emit: sequence_counts
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: '-C ${base}'
    """
    seqkit subseq \
        --bed ${bed} \
        ${fasta} |
        seqkit fx2tab ${args} > ${bed.simpleName}.tsv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        seqkit: \$( seqkit | sed '3!d; s/Version: //' )
    END_VERSIONS
    """
}
