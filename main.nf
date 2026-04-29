def CLASSY_CONTAINER = 'ghcr.io/chusj-pigu/classy:sha-4595409'

def normalizeGenome(genome) {
    switch (genome?.toLowerCase()) {
        case 'hs1':
        case 't2t' || 'chm13':
            return 't2t'
        case 'hg38' || 'grch38':
            return 'hg38'
        case 'hg19' || 'grch37':
            return 'hg19'
        default:
            return genome?.toLowerCase()
    }
}

def chainGenomeLabel(genome) {
    switch (normalizeGenome(genome)) {
        case 'hg19':
            return 'Hg19'
        case 'hg38':
            return 'Hg38'
        case 't2t':
            return 'Hs1'
        default:
            return null
    }
}

def chainGenomeStem(genome) {
    switch (normalizeGenome(genome)) {
        case 'hg19':
            return 'hg19'
        case 'hg38':
            return 'hg38'
        case 't2t':
            return 'hs1'
        default:
            return null
    }
}

def liftoverChainPath(inputGenome, targetGenome) {

    if (inputGenome == targetGenome) {
        return null
    }

    def srcStem = chainGenomeStem(inputGenome)
    def dstLabel = chainGenomeLabel(targetGenome)

    if (!srcStem || !dstLabel) {
        return null
    }

    return "/opt/classy/models/liftover_chains/${srcStem}To${dstLabel}.over.chain.gz"
}

process CLASSY_MARLIN {
    container "${CLASSY_CONTAINER}"
    label "classy"
    label "process_low"                    // nf-core label
    label "process_medium_cpu"                 // Label for mpgi drac cpu alloc
    label "process_medium_low_memory"        // Label for mpgi drac memory alloc
    label "process_low_time"          // Label for mpgi drac time alloc

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        val(refid),
        path(ref)

    output:
    tuple val(meta),
        path("*class_pie.svg"),
        emit:svg
    tuple val(meta),
        path("*json"),
        emit:json
    tuple val(meta),
        path("*class_pie.html"),
        emit:html
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def threads = task.cpus
    def genome = normalizeGenome(refid)
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
        --probes /opt/classy/models/MARLIN/marlin_v1.probes_${genome}.bed.gz

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: Pre-release
        modkit: \$( modkit --version  | awk '{print \$2}')
        Marlin: v1.0
    END_VERSIONS
    """

    stub:
    """
    test -f /opt/classy/models/MARLIN/marlin_v1.model.hdf5
    test -f /opt/classy/models/MARLIN/marlin_v1.class_annotations.xlsx
    test -f /opt/classy/models/MARLIN/marlin_v1.features.RData
    test -f /opt/classy/models/MARLIN/marlin_v1.probes_hg38.bed.gz
    touch ${meta.id}.svg
    touch ${meta.id}.html
    echo '{}' > ${meta.id}_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

process CLASSY_TUCAN {
    container "${CLASSY_CONTAINER}"
    label "classy"
    label "process_low"                    // nf-core label
    label "process_medium_cpu"                 // Label for mpgi drac cpu alloc
    label "process_medium_low_memory"        // Label for mpgi drac memory alloc
    label "process_low_time"          // Label for mpgi drac time alloc

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        val(refid),
        path(ref)

    output:
    tuple val(meta),
        path("*class_pie.svg"),
        emit:svg
    tuple val(meta),
        path("*json"),
        emit:json
    tuple val(meta),
        path("*.html"),
        emit:html
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def genome = normalizeGenome(refid)
    def model_ref = "t2t"
    // def liftover = genome in ["t2t", "chm13"] ? "" :
    //     (genome in ["hg38", "grch38"] ?
    //     "--tucan-input-genome t2t --tucan-target-genome hg38" :
    //     "--tucan-input-genome t2t --tucan-target-genome hg19")
    def liftoverChain = task.ext.liftover_chain ?: liftoverChainPath(model_ref, genome)
    def liftoverArg = liftoverChain ? "--tucan-liftover-chain ${liftoverChain}" : ''
    if (model_ref != genome && !liftoverChain) {
        throw new IllegalArgumentException("No default Tucan liftover chain for ${model_ref} -> ${genome}; set task.ext.liftover_chain")
    }
    """
    classy tucan \\
        -i ${bam} \\
        -o ${prefix}_classification.json \\
        --sample ${prefix} \\
        --reference ${ref} \\
        --use-pileup \\
        --motif "CpG:CG" \\
        --tucan-input-genome ${model_ref} \\
        --tucan-target-genome ${genome} \\
        ${liftoverArg} \\
        --tucan-model /opt/classy/models/tucan/runtime/model.safetensors \\
        --tucan-num-cpgs 10000 \\
        --tucan-num-samplings 1 \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: Pre-release
        modkit: \$( modkit --version  | awk '{print \$2}')
        Tucan: bundled
    END_VERSIONS
    """

    stub:
    """
    test -f /opt/classy/models/tucan/runtime/model.safetensors
    touch ${meta.id}.svg
    touch ${meta.id}.html
    echo '{}' > ${meta.id}_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

process CLASSY_STURGEON_GENERAL {
    container "${CLASSY_CONTAINER}"
    label "classy"
    label "process_low"                    // nf-core label
    label "process_medium_cpu"                 // Label for mpgi drac cpu alloc
    label "process_medium_low_memory"        // Label for mpgi drac memory alloc
    label "process_low_time"          // Label for mpgi drac time alloc

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        val(refid),
        path(ref)

    output:
    tuple val(meta),
        path("*.svg"),
        emit:svg
    tuple val(meta),
        path("*json"),
        emit:json
    tuple val(meta),
        path("*.html"),
        emit:html
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def genome = normalizeGenome(refid)
    def model_ref = "t2t"
    // def liftover = genome in ["t2t", "chm13"] ? "" :
    //     (genome in ["hg38", "grch38"] ?
    //     "--sturgeon-input-genome t2t --sturgeon-target-genome hg38" :
    //     "--sturgeon-input-genome t2t --sturgeon-target-genome hg19")
    def liftoverChain = task.ext.liftover_chain ?: liftoverChainPath(model_ref, genome)
    def liftoverArg = liftoverChain ? "--sturgeon-liftover-chain ${liftoverChain}" : ''
    if (model_ref != genome && !liftoverChain) {
        throw new IllegalArgumentException("No default Sturgeon liftover chain for ${model_ref} -> ${genome}; set task.ext.liftover_chain")
    }
    """
    classy sturgeon \\
        -i ${bam} \\
        -o ${prefix}_classification.json \\
        --sample ${prefix} \\
        --reference ${ref} \\
        --use-pileup \\
        --motif "CpG:CG" \\
        --sturgeon-input-genome ${model_ref} \\
        --sturgeon-target-genome ${genome} \\
        ${liftoverArg} \\
        --sturgeon-model /opt/classy/models/Sturgeon/general \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: Pre-release
        modkit: \$( modkit --version  | awk '{print \$2}')
        Sturgeon: general
    END_VERSIONS
    """

    stub:
    """
    test -d /opt/classy/models/Sturgeon/general || test -f /opt/classy/models/Sturgeon/general
    touch ${meta.id}.svg
    touch ${meta.id}.html
    echo '{}' > ${meta.id}_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

process CLASSY_STURGEON_BRAINSTEM {
    container "${CLASSY_CONTAINER}"
    label "classy"
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
        path("*.svg"),
        emit:svg
    tuple val(meta),
        path("*json"),
        emit:json
    tuple val(meta),
        path("*.html"),
        emit:html
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def genome = normalizeGenome(refid)
    def model_ref = "t2t"
    // def liftover = genome in ["t2t", "chm13"] ? "" :
    //     (genome in ["hg38", "grch38"] ?
    //     "--sturgeon-input-genome t2t --sturgeon-target-genome hg38" :
    //     "--sturgeon-input-genome t2t --sturgeon-target-genome hg19")
    def liftoverChain = task.ext.liftover_chain ?: liftoverChainPath(model_ref, genome)
    def liftoverArg = liftoverChain ? "--sturgeon-liftover-chain ${liftoverChain}" : ''
    if (model_ref != genome && !liftoverChain) {
        throw new IllegalArgumentException("No default Sturgeon liftover chain for ${model_ref} -> ${genome}; set task.ext.liftover_chain")
    }
    """
    classy sturgeon \\
        -i ${bam} \\
        -o ${prefix}_classification.json \\
        --sample ${prefix} \\
        --reference ${ref} \\
        --use-pileup \\
        --motif "CpG:CG" \\
        --sturgeon-input-genome ${model_ref} \\
        --sturgeon-target-genome ${genome} \\
        ${liftoverArg} \\
        --sturgeon-model /opt/classy/models/Sturgeon/brainstem \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: Pre-release
        modkit: \$( modkit --version  | awk '{print \$2}')
        Sturgeon: brainstem
    END_VERSIONS
    """

    stub:
    """
    test -d /opt/classy/models/Sturgeon/brainstem || test -f /opt/classy/models/Sturgeon/brainstem
    touch ${meta.id}.svg
    touch ${meta.id}.html
    echo '{}' > ${meta.id}_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

process CLASSY_CROSSNN_CAPER {
    container "${CLASSY_CONTAINER}"
    label "classy"
    label "process_low"                    // nf-core label
    label "process_medium_cpu"                 // Label for mpgi drac cpu alloc
    label "process_medium_low_memory"        // Label for mpgi drac memory alloc
    label "process_low_time"          // Label for mpgi drac time alloc

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        val(refid),
        path(ref)

    output:
    tuple val(meta),
        path("*class_pie.svg"),
        emit:svg
    tuple val(meta),
        path("*classification.json"),
        emit:json
    tuple val(meta),
        path("*.html"),
        emit:html
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def threads = task.cpus
    def prefix = task.ext.prefix ?: "${meta.id}"
    def genome = normalizeGenome(refid)
    def model_ref = "hg19"
    // def liftover = genome in ["hg19", "grch37"] ? "" :
    //     (genome in ["hg38", "grch38"] ?
    //     "--input-genome hg19 --target-genome hg38" :
    //     "--input-genome hg19 --target-genome t2t")
    def liftoverChain = task.ext.liftover_chain ?: liftoverChainPath(model_ref, genome)
    def liftoverArg = liftoverChain ? "--liftover-chain ${liftoverChain}" : ''
    if (model_ref != genome && !liftoverChain) {
        throw new IllegalArgumentException("No default CrossNN liftover chain for ${model_ref} -> ${genome}; set task.ext.liftover_chain")
    }
    """
    classy crossnn \\
        -i ${bam} \\
        -o ${prefix}_Capper_et_al_classification.json \\
        --sample ${prefix} \\
        --use-pileup \\
        --motif "CpG:CG" \\
        --reference ${ref} \\
        --input-genome ${model_ref} \\
        --target-genome ${genome} \\
        ${liftoverArg} \\
        --crossnn-model /opt/classy/models/crossNN/runtime/Capper_et_al.safetensors \\
        --crossnn-embedding /opt/classy/models/crossNN/runtime/Capper_et_al_embedding.json \\
        --crossnn-probes /opt/classy/models/crossNN/static/450K_hg19.bed \\
        --crossnn-dictionary /opt/classy/models/crossNN/static/Capper_et_al_dictionary.txt \\
        --crossnn-training-set Capper_et_al \\
        --crossnn-cutoff 0.2 \\
        --emit-crossnn-votes \\
        --emit-crossnn-tsne \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: Pre-release
        modkit: \$( modkit --version  | awk '{print \$2}')
        CrossNN: Capper_et_al
    END_VERSIONS
    """

    stub:
    """
    test -f /opt/classy/models/crossNN/runtime/Capper_et_al.safetensors
    test -f /opt/classy/models/crossNN/runtime/Capper_et_al_embedding.json
    test -f /opt/classy/models/crossNN/static/450K_hg19.bed
    test -f /opt/classy/models/crossNN/static/Capper_et_al_dictionary.txt
    touch ${meta.id}.svg
    touch ${meta.id}.html
    echo '{}' > ${meta.id}_Capper_et_al_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}


process CLASSY_CROSSNN_PANCAN {
    container "${CLASSY_CONTAINER}"
    label "classy"
    label "process_low"                    // nf-core label
    label "process_medium_cpu"                 // Label for mpgi drac cpu alloc
    label "process_medium_low_memory"        // Label for mpgi drac memory alloc
    label "process_low_time"          // Label for mpgi drac time alloc

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        val(refid),
        path(ref)

    output:
    tuple val(meta),
        path("*class_pie.svg"),
        emit:svg
    tuple val(meta),
        path("*classification.json"),
        emit:json
    tuple val(meta),
        path("*.html"),
        emit:html
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def threads = task.cpus
    def prefix = task.ext.prefix ?: "${meta.id}"
    def genome = normalizeGenome(refid)
    def model_ref = "hg19"
    def liftoverChain = task.ext.liftover_chain ?: liftoverChainPath(model_ref, genome)
    def liftoverArg = liftoverChain ? "--liftover-chain ${liftoverChain}" : ''
    if (model_ref != genome && !liftoverChain) {
        throw new IllegalArgumentException("No default CrossNN liftover chain for ${model_ref} -> ${genome}; set task.ext.liftover_chain")
    }
    """
    classy crossnn \\
        -i ${bam} \\
        -o ${prefix}_pancan_devel_v5i_classification.json \\
        --sample ${prefix} \\
        --use-pileup \\
        --motif "CpG:CG" \\
        --reference ${ref} \\
        --input-genome ${model_ref} \\
        --target-genome ${genome} \\
        ${liftoverArg} \
        --crossnn-model /opt/classy/models/crossNN/runtime/pancan_devel_v5i.safetensors \\
        --crossnn-embedding /opt/classy/models/crossNN/runtime/pancan_devel_v5i_embedding.json \\
        --crossnn-probes /opt/classy/models/crossNN/static/450K_hg19.bed \\
        --crossnn-dictionary /opt/classy/models/crossNN/static/pancan_devel_v5i_dictionary.txt \\
        --crossnn-training-set pancan_devel_v5i \\
        --crossnn-cutoff 0.15 \\
        --emit-crossnn-votes \\
        --emit-crossnn-tsne \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: Pre-release
        modkit: \$( modkit --version  | awk '{print \$2}')
        CrossNN: pancan_devel_v5i
    END_VERSIONS
    """

    stub:
    """
    test -f /opt/classy/models/crossNN/runtime/pancan_devel_v5i.safetensors
    test -f /opt/classy/models/crossNN/runtime/pancan_devel_v5i_embedding.json
    test -f /opt/classy/models/crossNN/static/450K_hg19.bed
    test -f /opt/classy/models/crossNN/static/pancan_devel_v5i_dictionary.txt
    touch ${meta.id}.svg
    touch ${meta.id}.html
    echo '{}' > ${meta.id}_pancan_devel_v5i_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

process CLASSY_MARLIN_PILEUP {
    container "${CLASSY_CONTAINER}"
    label "classy"
    label "process_low"
    label "process_medium_cpu"
    label "process_medium_low_memory"
    label "process_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        val(refid),
        path(pileup)

    output:
    tuple val(meta), path("*class_pie.svg"), emit: svg
    tuple val(meta), path("*json"), emit: json
    tuple val(meta), path("*.html"), emit: html
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def genome = normalizeGenome(refid)
    """
    classy marlin \\
        --pileup-input ${pileup} \\
        --output ${prefix}_classification.json \\
        --sample ${prefix} \\
        --model /opt/classy/models/MARLIN/marlin_v1.model.hdf5 \\
        --annotations /opt/classy/models/MARLIN/marlin_v1.class_annotations.xlsx \\
        --resolution per-motif \\
        --motif CpG:CG \\
        --features /opt/classy/models/MARLIN/marlin_v1.features.RData \\
        --probes /opt/classy/models/MARLIN/marlin_v1.probes_${genome}.bed.gz \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: Pre-release
        modkit: \$( modkit --version  | awk '{print \$2}')
        Marlin: v1.0
    END_VERSIONS
    """

    stub:
    """
    test -f /opt/classy/models/MARLIN/marlin_v1.model.hdf5
    test -f /opt/classy/models/MARLIN/marlin_v1.class_annotations.xlsx
    test -f /opt/classy/models/MARLIN/marlin_v1.features.RData
    test -f /opt/classy/models/MARLIN/marlin_v1.probes_hg38.bed.gz
    touch ${meta.id}.svg
    touch ${meta.id}.html
    echo '{}' > ${meta.id}_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

process CLASSY_TUCAN_PILEUP {
    container "${CLASSY_CONTAINER}"
    label "classy"
    label "process_low"
    label "process_medium_cpu"
    label "process_medium_low_memory"
    label "process_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        val(refid),
        path(pileup)

    output:
    tuple val(meta), path("*class_pie.svg"), emit: svg
    tuple val(meta), path("*json"), emit: json
    tuple val(meta), path("*.html"), emit: html
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def genome = normalizeGenome(refid)
    def model_ref = "t2t"
    def liftoverChain = task.ext.liftover_chain ?: liftoverChainPath(model_ref, genome)
    def liftoverArg = liftoverChain ? "--tucan-liftover-chain ${liftoverChain}" : ''
    if (model_ref != genome && !liftoverChain) {
        throw new IllegalArgumentException("No default Tucan liftover chain for ${model_ref} -> ${genome}; set task.ext.liftover_chain")
    }
    """
    classy tucan \\
        --pileup-input ${pileup} \\
        --output ${prefix}_classification.json \\
        --sample ${prefix} \\
        --motif "CpG:CG" \\
        --tucan-input-genome ${model_ref} \\
        --tucan-target-genome ${genome} \\
        ${liftoverArg} \\
        --tucan-model /opt/classy/models/tucan/runtime/model.safetensors \\
        --tucan-num-cpgs 10000 \\
        --tucan-num-samplings 1 \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: Pre-release
        modkit: \$( modkit --version  | awk '{print \$2}')
        Tucan: bundled
    END_VERSIONS
    """

    stub:
    """
    test -f /opt/classy/models/tucan/runtime/model.safetensors
    touch ${meta.id}.svg
    touch ${meta.id}.html
    echo '{}' > ${meta.id}_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

process CLASSY_STURGEON_GENERAL_PILEUP {
    container "${CLASSY_CONTAINER}"
    label "classy"
    label "process_low"
    label "process_medium_cpu"
    label "process_medium_low_memory"
    label "process_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        val(refid),
        path(pileup)

    output:
    tuple val(meta), path("*pie.svg"), emit: svg
    tuple val(meta), path("*json"), emit: json
    tuple val(meta), path("*.html"), emit: html
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def genome = normalizeGenome(refid)
    def model_ref = "t2t"
    def liftoverChain = task.ext.liftover_chain ?: liftoverChainPath(model_ref, genome)
    def liftoverArg = liftoverChain ? "--sturgeon-liftover-chain ${liftoverChain}" : ''
    if (model_ref != genome && !liftoverChain) {
        throw new IllegalArgumentException("No default Sturgeon liftover chain for ${model_ref} -> ${genome}; set task.ext.liftover_chain")
    }
    """
    classy sturgeon \\
        --pileup-input ${pileup} \\
        --output ${prefix}_classification.json \\
        --sample ${prefix} \\
        --sturgeon-input-genome ${model_ref} \\
        --sturgeon-target-genome ${genome} \\
        ${liftoverArg} \\
        --motif "CpG:CG" \\
        --sturgeon-model /opt/classy/models/Sturgeon/general \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: Pre-release
        modkit: \$( modkit --version  | awk '{print \$2}')
        Sturgeon: general
    END_VERSIONS
    """

    stub:
    """
    test -d /opt/classy/models/Sturgeon/general || test -f /opt/classy/models/Sturgeon/general
    touch ${meta.id}.svg
    touch ${meta.id}.html
    echo '{}' > ${meta.id}_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

process CLASSY_STURGEON_BRAINSTEM_PILEUP {
    container "${CLASSY_CONTAINER}"
    label "classy"
    label "process_low"
    label "process_medium_cpu"
    label "process_medium_low_memory"
    label "process_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        val(refid),
        path(pileup)

    output:
    tuple val(meta), path("*pie.svg"), emit: svg
    tuple val(meta), path("*classification.json"), emit: json
    tuple val(meta), path("*.html"), emit: html
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def genome = normalizeGenome(refid)
    def model_ref = "t2t"
    def liftoverChain = task.ext.liftover_chain ?: liftoverChain
    def liftoverArg = liftoverChain ? "--sturgeon-liftover-chain ${liftoverChain}" : ''
    if (model_ref != genome && !liftoverChain) {
        throw new IllegalArgumentException("No default Sturgeon liftover chain for ${model_ref} -> ${genome}; set task.ext.liftover_chain")
    }
    """
    classy sturgeon \\
        --pileup-input ${pileup} \\
        --output ${prefix}_classification.json \\
        --sample ${prefix} \\
        --motif "CpG:CG" \\
        --sturgeon-input-genome ${model_ref} \\
        --sturgeon-target-genome ${genome} \\
        ${liftoverArg} \\
        --sturgeon-model /opt/classy/models/Sturgeon/brainstem \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: Pre-release
        modkit: \$( modkit --version  | awk '{print \$2}')
        Sturgeon: brainstem
    END_VERSIONS
    """

    stub:
    """
    test -d /opt/classy/models/Sturgeon/brainstem || test -f /opt/classy/models/Sturgeon/brainstem
    touch ${meta.id}.svg
    touch ${meta.id}.html
    echo '{}' > ${meta.id}_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

process CLASSY_CROSSNN_CAPER_PILEUP {
    container "${CLASSY_CONTAINER}"
    label "classy"
    label "process_low"
    label "process_medium_cpu"
    label "process_medium_low_memory"
    label "process_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        val(refid),
        path(pileup)

    output:
    tuple val(meta), path("*class_pie.svg"), emit: svg
    tuple val(meta), path("*classification.json"), emit: json
    tuple val(meta), path("*.html"), emit: html
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def genome = normalizeGenome(refid)
    def model_ref = "hg19"
    def liftoverChain = task.ext.liftover_chain ?: liftoverChainPath(model_ref, genome)
    def liftoverArg = liftoverChain ? "--liftover-chain ${liftoverChain}" : ''
    if (model_ref != genome && !liftoverChain) {
        throw new IllegalArgumentException("No default CrossNN liftover chain for ${model_ref} -> ${genome}; set task.ext.liftover_chain")
    }
    """
    classy crossnn \\
        --pileup-input ${pileup} \\
        --output ${prefix}_Capper_et_al_classification.json \\
        --sample ${prefix} \\
        --motif "CpG:CG" \\
        --input-genome ${model_ref} \\
        --target-genome ${genome} \\
        ${liftoverArg} \\
        --crossnn-model /opt/classy/models/crossNN/runtime/Capper_et_al.safetensors \\
        --crossnn-embedding /opt/classy/models/crossNN/runtime/Capper_et_al_embedding.json \\
        --crossnn-dictionary /opt/classy/models/crossNN/static/Capper_et_al_dictionary.txt \\
        --crossnn-probes /opt/classy/models/crossNN/static/450K_hg19.bed \\
        --crossnn-training-set Capper_et_al \\
        --crossnn-cutoff 0.2 \\
        --emit-crossnn-votes \\
        --emit-crossnn-tsne \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: Pre-release
        modkit: \$( modkit --version  | awk '{print \$2}')
        CrossNN: Capper_et_al
    END_VERSIONS
    """

    stub:
    """
    test -f /opt/classy/models/crossNN/runtime/Capper_et_al.safetensors
    test -f /opt/classy/models/crossNN/runtime/Capper_et_al_embedding.json
    test -f /opt/classy/models/crossNN/static/Capper_et_al_dictionary.txt
    touch ${meta.id}.svg
    touch ${meta.id}.html
    echo '{}' > ${meta.id}_Capper_et_al_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

process CLASSY_CROSSNN_PANCAN_PILEUP {
    container "${CLASSY_CONTAINER}"
    label "classy"
    label "process_low"
    label "process_medium_cpu"
    label "process_medium_low_memory"
    label "process_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        val(refid),path(pileup)

    output:
    tuple val(meta), path("*class_pie.svg"), emit: svg
    tuple val(meta), path("*classification.json"), emit: json
    tuple val(meta), path("*.html"), emit: html
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def genome = normalizeGenome(refid)
    def model_ref = "hg19"
    def liftoverChain = task.ext.liftover_chain ?: liftoverChainPath(model_ref, genome)
    def liftoverArg = liftoverChain ? "--liftover-chain ${liftoverChain}" : ''
    if (model_ref != genome && !liftoverChain) {
        throw new IllegalArgumentException("No default CrossNN liftover chain for ${model_ref} -> ${genome}; set task.ext.liftover_chain")
    }
    """
    classy crossnn \\
        --pileup-input ${pileup} \\
        --output ${prefix}_pancan_devel_v5i_classification.json \\
        --sample ${prefix} \\
        --motif "CpG:CG" \\
        --input-genome ${model_ref} \\
        --target-genome ${genome} \\
        ${liftoverArg} \\
        --crossnn-model /opt/classy/models/crossNN/runtime/pancan_devel_v5i.safetensors \\
        --crossnn-embedding /opt/classy/models/crossNN/runtime/pancan_devel_v5i_embedding.json \\
        --crossnn-dictionary /opt/classy/models/crossNN/static/pancan_devel_v5i_dictionary.txt \\
        --crossnn-probes /opt/classy/models/crossNN/static/450K_hg19.bed \\
        --crossnn-training-set pancan_devel_v5i \\
        --crossnn-cutoff 0.15 \\
        --emit-crossnn-votes \\
        --emit-crossnn-tsne \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: Pre-release
        modkit: \$( modkit --version  | awk '{print \$2}')
        CrossNN: pancan_devel_v5i
    END_VERSIONS
    """

    stub:
    """
    test -f /opt/classy/models/crossNN/runtime/pancan_devel_v5i.safetensors
    test -f /opt/classy/models/crossNN/runtime/pancan_devel_v5i_embedding.json
    test -f /opt/classy/models/crossNN/static/pancan_devel_v5i_dictionary.txt
    touch ${meta.id}.svg
    touch ${meta.id}.html
    echo '{}' > ${meta.id}_pancan_devel_v5i_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}
