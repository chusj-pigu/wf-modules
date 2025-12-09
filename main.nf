process BWA_MEM2_INDEX {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/bwa-mem2:latest'
    label "process_medium"              // nf-core labels
    label "process_medium_low_cpu"      // Label for mpgi drac cpu alloc
    label "process_medium_low_memory"   // Label for mpgi drac memory alloc
    label "process_low_time"            // Label for mpgi drac time alloc

    tag "$meta.id"

    input:
    tuple val(meta),
        path(reference)

    output:
    tuple val(meta),
        path("index/*"),
        emit: index
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args   = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    mkdir -p index
    cp ${reference} index/${prefix}.fa
    cd index
    bwa-mem2 \\
        index \\
        ${args} \\
        -p ${prefix} \\
        ${prefix}.fa

    cat <<-END_VERSIONS > ../versions.yml
    "${task.process}":
        bwa-mem2: \$(bwa-mem2 version 2>&1 | head -n1 | sed 's/^.*Version: //')
    END_VERSIONS
    """
}

process BWA_MEM2_MEM {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/bwa-mem2:latest'
    label "process_medium"              // nf-core labels
    label "process_medium_cpu"          // Label for mpgi drac memory alloc
    label "process_medium_memory"       // Label for mpgi drac memory alloc
    label "process_medium_time"         // Label for mpgi drac time alloc

    tag "$meta.id"

    input:
    tuple val(meta),
        path(reads),
        path(reference),
        path(index_files)

    output:
    tuple val(meta),
        path("*.sam"),
        emit: sam
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    def read_args = reads instanceof List ? reads.join(' ') : reads
    """
    bwa-mem2 \\
        mem \\
        ${args} \\
        -t ${threads} \\
        ${reference} \\
        ${read_args} > ${prefix}.sam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bwa-mem2: \$(bwa-mem2 version 2>&1 | head -n1 | sed 's/^.*Version: //')
    END_VERSIONS
    """
}
