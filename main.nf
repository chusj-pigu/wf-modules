process SAMTOOLS_QSFILTER {

    label "process_small"                    // nf-core labels
    label "process_medium_low_cpu"          // Label for mpgi drac cpu alloc
    label "process_medium_low_memory"       // Label for mpgi drac memory alloc
    label "process_low_time"                // Label for mpgi drac time alloc

    conda "${moduleDir}/environment.yml"
    container "${workflow.containerEngine in ['singularity', 'apptainer'] && !task.ext.singularity_pull_docker_container
        ? 'https://community-cr-prod.seqera.io/docker/registry/v2/blobs/sha256/e9/e994bf4eb3731150511a14f5706b7bdfd64df1b6d40898fff334286c027e0859/data'
        : 'community.wave.seqera.io/library/htslib_samtools:1.24--d697cfb9dce007cd'}"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(ubam)

    output:
    tuple val(meta),
        path("*_pass.bam"),
        emit: ubam_pass
    tuple val(meta),
        path("*_fail.bam"),
        emit: ubam_fail
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: '--no-PG'
    def model_str = (params.basecall_model ?: params.basecall_model_path ?: '').toString()
    def minqs = model_str.contains('sup') ? 10 :
             model_str.contains('hac') ? 9 :
             8
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    samtools \\
        view \\
        ${args} \\
        -@ ${threads} \\
        -e '[qs] >=${minqs}' \\
        -b ${ubam} \\
        --output ${prefix}_pass.bam \\
        --unoutput ${prefix}_fail.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')

    END_VERSIONS
    """
}

process SAMTOOLS_TOFASTQ {

    label "process_medium"              // nf-core labels
    label "process_medium_low_cpu"          // Label for mpgi drac memory alloc
    label "process_low_memory"              // Label for mpgi drac memory alloc
    label "process_medium_low_time"         // Label for mpgi drac time alloc

    conda "${moduleDir}/environment.yml"
    container "${workflow.containerEngine in ['singularity', 'apptainer'] && !task.ext.singularity_pull_docker_container
        ? 'https://community-cr-prod.seqera.io/docker/registry/v2/blobs/sha256/e9/e994bf4eb3731150511a14f5706b7bdfd64df1b6d40898fff334286c027e0859/data'
        : 'community.wave.seqera.io/library/htslib_samtools:1.24--d697cfb9dce007cd'}"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(ubam)

    output:
    tuple val(meta),
        path("*.fq"),
        emit: fq
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    samtools fastq \\
        ${args} \\
        -@ ${threads} \\
        ${ubam} > ${prefix}.fq

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')

    END_VERSIONS
    """
}

process SAMTOOLS_COUNT_READS {

    label "process_medium"          // nf-core labels
    label "process_medium_cpu"              // Label for mpgi drac memory alloc
    label "process_low_memory"           // Label for mpgi drac memory alloc
    label "process_low_time"                // Label for mpgi drac time alloc

    conda "${moduleDir}/environment.yml"
    container "${workflow.containerEngine in ['singularity', 'apptainer'] && !task.ext.singularity_pull_docker_container
        ? 'https://community-cr-prod.seqera.io/docker/registry/v2/blobs/sha256/e9/e994bf4eb3731150511a14f5706b7bdfd64df1b6d40898fff334286c027e0859/data'
        : 'community.wave.seqera.io/library/htslib_samtools:1.24--d697cfb9dce007cd'}"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(in_bam)

    output:
    tuple val(meta),
        path("*.txt"),
        emit: txt
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    samtools \\
        view \\
        -@ ${threads} \\
        -c \\
        ${args} \\
        ${in_bam} \\
        -o ${prefix}_count.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')

    END_VERSIONS
    """
}
