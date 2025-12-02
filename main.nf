rocess CLASSY_CLASSIFY {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/classy:sha-4a9ff86'
    label "process_low"                    // nf-core label
    label "process_medium_cpu"                 // Label for mpgi drac cpu alloc
    label "process_medium_low_memory"        // Label for mpgi drac memory alloc
    label "process_low_time"          // Label for mpgi drac time alloc

    input:
    tuple val(meta),
        path(bam),
        path(ref)

    output:
    tuple val(meta),
        path("*_class_pies.svg"),
        emit:svg
    tuple val(meta),
        path("*json"),
        emit:json
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def threads = task.cpus
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    classy \\
        -i ${bam} \\
        -o ${prefix}_classification.json \\
        --min-read-length 500 \\
        --model /opt/classy/models/MARLIN/marlin_v1.model.hdf5 \\
        --annotations /opt/classy/models/MARLIN/marlin_v1.class_annotations.xlsx \\
        --resolution per-motif \\
        --motif CpG \\
        --min-mapq 20 \\
        --use-pileup \\
        --pileup-threads ${threads} \\
        --reference ${ref} \\
        --sample ${prefix} \\
        --features /opt/classy/models/MARLIN/marlin_v1.features.RData \\
        --probes /opt/classy/models/MARLIN/marlin_v1.probes_hg38.bed.gz

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: Pre-release
        modkit: \$( modkit --version  | awk '{print \$2}')
        Marlin: v1.0
    END_VERSIONS
    """
}
