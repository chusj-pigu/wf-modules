process DORADO_BASECALL {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/dorado:latest'
    label "process_high"            // nf-core label
    label "process_medium_cpu"             // Label for mpgi drac cpu alloc
    label "process_high_memory"    // Label for mpgi drac memory alloc
    label "process_high_time"             // Label for mpgi drac time alloc
    label "process_gpu"                   // Label for mpgi drac gpu alloc

    tag "$meta.id"

    input:
    tuple val(meta), path(pod5), path(ubam), val(model)

    output:
    tuple val(meta), path("*.bam"), emit: ubam
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def device = params.device != null ? "-x $params.device" : ""
    def mod = params.m_bases_path ? "--modified-bases-models ${params.m_bases_path}" : (params.m_bases ? "--modified-bases ${params.m_bases}" : "")
    def multi = params.demux != null ? "--no-trim" : ""
    def resume = ubam.name != 'NO_UBAM' ? "--resume-from $ubam > ${prefix}_unaligned_final.bam" : "> ${prefix}_unaligned.bam"
    """
    dorado basecaller \\
        $args \\
        $device \\
        $model \\
        $pod5 \\
        $mod \\
        $multi \\
        $resume

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        dorado: \$(echo \$(dorado --version 2>&1) | sed 's/^.*dorado //; s/Using.*\$//')    END_VERSIONS
    """
}

process DORADO_DEMULTIPLEX {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/dorado:latest'
    label "process_high"                    // nf-core label
    label "process_high_cpu"                 // Label for mpgi drac cpu alloc
    label "process_medium_low_memory"        // Label for mpgi drac memory alloc
    label "process_medium_low_time"          // Label for mpgi drac time alloc

    tag "$meta.id"

    input:
    tuple val(meta), path(bam)

    output:
    tuple val(meta), path("${meta.id}/*.bam"), emit: demux_ubam
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def kit = "--kit-name $params.demux"
    """
    dorado \\
        demux \\
        $args \\
        $kit \\
        --output-dir $prefix \\
        $bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        dorado: \$(echo \$(dorado --version 2>&1) | sed 's/^.*dorado //; s/Using.*\$//')    END_VERSIONS
    """
}
