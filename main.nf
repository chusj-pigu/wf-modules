process CLASSY_MARLIN {
    container 'ghcr.io/chusj-pigu/classy:sha-22b7712'
    label "process_low"                    // nf-core label
    label "process_medium_cpu"                 // Label for mpgi drac cpu alloc
    label "process_medium_low_memory"        // Label for mpgi drac memory alloc
    label "process_low_time"          // Label for mpgi drac time alloc

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        path(ref)

    output:
    tuple val(meta),
        path("*_class_pies.svg"),
        emit:svg
    tuple val(meta),
        path("*json"),
        emit:json
    tuple val(meta),
        path("*_class_pies.html"),
        emit:html
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def threads = task.cpus
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    classy marlin \\
        -i ${bam} \\
        -o ${prefix}_classification.json \\
        --min-read-length 500 \\
        --model /opt/classy/models/MARLIN/marlin_v1.model.hdf5 \\
        --annotations /opt/classy/models/MARLIN/marlin_v1.class_annotations.xlsx \\
        --resolution per-motif \\
        --motif CpG:CG \\
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

process CLASSY_CROSSNN_CAPER {
    container 'ghcr.io/chusj-pigu/classy:sha-22b7712'
    label "process_low"                    // nf-core label
    label "process_medium_cpu"                 // Label for mpgi drac cpu alloc
    label "process_medium_low_memory"        // Label for mpgi drac memory alloc
    label "process_low_time"          // Label for mpgi drac time alloc

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        path(ref)

    output:
    tuple val(meta),
        path("*_class_pies.svg"),
        emit:svg
    tuple val(meta),
        path("*json"),
        emit:json
    tuple val(meta),
        path("*_class_pies.html"),
        emit:html
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def threads = task.cpus
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    classy crossnn \\
        -i ${bam} \\
        -o ${prefix}_Capper_et_al_classification.json \\
        --sample ${prefix} \\
        --use-pileup \
        --motif "CpG:CG" \
        --reference ${ref} \
        --input-genome hg38 \
        --target-genome hg19 \
        --liftover-chain /opt/classy/models/liftover_chains/hg19ToHg38.over.chain.gz \
        --crossnn-model models/crossNN/runtime/Capper_et_al.safetensors \
        --crossnn-training-set Capper_et_al \
        --emit-crossnn-votes \
        --emit-crossnn-tsne

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: Pre-release
        modkit: \$( modkit --version  | awk '{print \$2}')
        Marlin: v1.0
    END_VERSIONS
    """
}


process CLASSY_CROSSNN_PANCAN {
    container 'ghcr.io/chusj-pigu/classy:sha-22b7712'
    label "process_low"                    // nf-core label
    label "process_medium_cpu"                 // Label for mpgi drac cpu alloc
    label "process_medium_low_memory"        // Label for mpgi drac memory alloc
    label "process_low_time"          // Label for mpgi drac time alloc

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        path(ref)

    output:
    tuple val(meta),
        path("*_class_pies.svg"),
        emit:svg
    tuple val(meta),
        path("*json"),
        emit:json
    tuple val(meta),
        path("*_class_pies.html"),
        emit:html
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def threads = task.cpus
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    classy crossnn \\
        -i ${bam} \\
        -o ${prefix}_pancan_devel_v5i_classification.json \\
        --sample ${prefix} \\
        --use-pileup \
        --motif "CpG:CG" \
        --reference ${ref} \
        --input-genome hg38 \
        --target-genome hg19 \
        --liftover-chain /opt/classy/models/liftover_chains/hg19ToHg38.over.chain.gz \
        --crossnn-model models/crossNN/runtime/pancan_devel_v5i.safetensors \
        --crossnn-training-set pancan_devel_v5i \
        --emit-crossnn-votes \
        --emit-crossnn-tsne

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: Pre-release
        modkit: \$( modkit --version  | awk '{print \$2}')
        Marlin: v1.0
    END_VERSIONS
    """
}
