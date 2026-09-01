// ============================================================================
// Marlin classifier processes
// ============================================================================

process CLASSY_MARLIN {
    container "${params.classy_container ?: 'ghcr.io/chusj-pigu/classy:sha-6a3f603'}"
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
        path("*pies.svg"),
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
    def genome = refid == "hs1" ? 't2t' : refid
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    classy marlin \\
        -i ${bam} \\
        -o ${prefix}_marlin_classification.json \\
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
        --genome ${genome} \\
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
    touch ${meta.id}_class_pies.svg
    touch ${meta.id}_class_pie.html
    echo '{}' > ${meta.id}_marlin_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

process CLASSY_MARLIN_PILEUP {
    container "${params.classy_container ?: 'ghcr.io/chusj-pigu/classy:sha-6a3f603'}"
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
    tuple val(meta),
        path("*pies.svg"),
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
    def genome = refid == "hs1" ? 't2t' : refid
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    classy marlin \\
        --pileup-input ${pileup} \\
        -o ${prefix}_marlin_classification.json \\
        --sample ${prefix} \\
        --min-read-length 500 \\
        --model /opt/classy/models/MARLIN/marlin_v1.model.hdf5 \\
        --annotations /opt/classy/models/MARLIN/marlin_v1.class_annotations.xlsx \\
        --resolution per-motif \\
        --motif CpG:CG \\
        --genome ${genome} \\
        --features /opt/classy/models/MARLIN/marlin_v1.features.RData \\
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
    touch ${meta.id}_class_pies.svg
    touch ${meta.id}_class_pie.html
    echo '{}' > ${meta.id}_marlin_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

// ============================================================================
// Tucan classifier processes
// ============================================================================

process CLASSY_TUCAN {
    container "${params.classy_container ?: 'ghcr.io/chusj-pigu/classy:sha-6a3f603'}"
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
        path("*pies.svg"),
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
    def genome = refid == "hs1" ? 't2t' : refid
    """
    classy tucan \\
        -i ${bam} \\
        -o ${prefix}_tucan_classification.json \\
        --sample ${prefix} \\
        --reference ${ref} \\
        --use-pileup \\
        --motif "CpG:CG" \\
        --tucan-probes-genome "t2t" \\
        --tucan-alignment-genome ${genome} \\
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
    touch ${meta.id}_class_pies.svg
    touch ${meta.id}_class_pie.html
    echo '{}' > ${meta.id}_tucan_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

process CLASSY_TUCAN_PILEUP {
    container "${params.classy_container ?: 'ghcr.io/chusj-pigu/classy:sha-6a3f603'}"
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
    tuple val(meta),
        path("*pies.svg"),
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
    def genome = refid == "hs1" ? 't2t' : refid
    """
    classy tucan \\
        --pileup-input ${pileup} \\
        -o ${prefix}_tucan_classification.json \\
        --sample ${prefix} \\
        --motif "CpG:CG" \\
        --tucan-probes-genome "t2t" \\
        --tucan-alignment-genome ${genome} \\
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
    touch ${meta.id}_class_pies.svg
    touch ${meta.id}.html
    echo '{}' > ${meta.id}_tucan_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

// ============================================================================
// Sturgeon classifier processes
// ============================================================================

process CLASSY_STURGEON_GENERAL {
    container "${params.classy_container ?: 'ghcr.io/chusj-pigu/classy:sha-6a3f603'}"
    label "classy"
    label "process_low"                    // nf-core label
    label "process_medium_cpu"                 // Label for mpgi drac cpu alloc
    label params.get('cfdna', false) ? "process_higher_memory" : "process_medium_low_memory"    // Label for mpgi drac memory alloc
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
    def genome = refid == "hs1" ? 't2t' : refid
    def probes_genome = genome == "hg19" ? 'hg38' : "${genome}"
    """
    classy sturgeon \\
        -i ${bam} \\
        -o ${prefix}_sturgeon_general_classification.json \\
        --sample ${prefix} \\
        --reference ${ref} \\
        --use-pileup \\
        --motif "CpG:CG" \\
        --sturgeon-probes-genome ${probes_genome} \\
        --sturgeon-alignment-genome ${genome} \\
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
    touch ${meta.id}_class_pies.svg
    touch ${meta.id}_class_pie.html
    echo '{}' > ${meta.id}_sturgeon_general_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

process CLASSY_STURGEON_GENERAL_PILEUP {
    container "${params.classy_container ?: 'ghcr.io/chusj-pigu/classy:sha-6a3f603'}"
    label "classy"
    label "process_low"
    label "process_medium_cpu"
    label params.get('cfdna', false) ? "process_higher_memory" : "process_medium_low_memory"
    label "process_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        val(refid),
        path(pileup)

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
    def genome = refid == "hs1" ? 't2t' : refid
    def probes_genome = genome == "hg19" ? 'hg38' : "${genome}"
    """
    classy sturgeon \\
        --pileup-input ${pileup} \\
        -o ${prefix}_sturgeon_general_classification.json \\
        --sample ${prefix} \\
        --motif "CpG:CG" \\
        --sturgeon-probes-genome ${probes_genome} \\
        --sturgeon-alignment-genome ${genome} \\
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
    touch ${meta.id}_class_pies.svg
    touch ${meta.id}.html
    echo '{}' > ${meta.id}_sturgeon_general_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

process CLASSY_STURGEON_BRAINSTEM {
    container "${params.classy_container ?: 'ghcr.io/chusj-pigu/classy:sha-6a3f603'}"
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
    def genome = refid == "hs1" ? 't2t' : refid
    def probes_genome = genome == "hg19" ? 'hg38' : "${genome}"
    """
    classy sturgeon \\
        -i ${bam} \\
        -o ${prefix}_sturgeon_brainstem_classification.json \\
        --sample ${prefix} \\
        --reference ${ref} \\
        --use-pileup \\
        --motif "CpG:CG" \\
        --sturgeon-probes-genome ${probes_genome} \\
        --sturgeon-alignment-genome ${genome} \\
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
    touch ${meta.id}_class_pies.svg
    touch ${meta.id}.html
    echo '{}' > ${meta.id}_sturgeon_brainstem_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

process CLASSY_STURGEON_BRAINSTEM_PILEUP {
    container "${params.classy_container ?: 'ghcr.io/chusj-pigu/classy:sha-6a3f603'}"
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
    def genome = refid == "hs1" ? 't2t' : refid
    def probes_genome = genome == "hg19" ? 'hg38' : "${genome}"
    """
    classy sturgeon \\
        --pileup-input ${pileup} \\
        -o ${prefix}_sturgeon_brainstem_classification.json \\
        --sample ${prefix} \\
        --motif "CpG:CG" \\
        --sturgeon-probes-genome ${probes_genome} \\
        --sturgeon-alignment-genome ${genome} \\
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
    touch ${meta.id}_class_pies.svg
    touch ${meta.id}.html
    echo '{}' > ${meta.id}_sturgeon_brainstem_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

// ============================================================================
// CrossNN classifier processes
// ============================================================================

process CLASSY_CROSSNN_CAPER {
    container "${params.classy_container ?: 'ghcr.io/chusj-pigu/classy:sha-6a3f603'}"
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
        path("*pies.svg"),
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
    def genome = refid == "hs1" ? 't2t' : refid
    def prefix = task.ext.prefix ?: "${meta.id}"

    """
    classy crossnn \\
        -i ${bam} \\
        -o ${prefix}_crossnn_Capper_et_al_classification.json \\
        --sample ${prefix} \\
        --use-pileup \\
        --motif "CpG:CG" \\
        --reference ${ref} \\
        --crossnn-probes-genome hg19 \\
        --crossnn-alignment-genome ${genome} \\
        --crossnn-model /opt/classy/models/crossNN/runtime/Capper_et_al.safetensors \\
        --crossnn-embedding /opt/classy/models/crossNN/runtime/Capper_et_al_embedding.json \\
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
    touch ${meta.id}_class_pies.svg
    touch ${meta.id}_class_pie.html
    echo '{}' > ${meta.id}_crossnn_Capper_et_al_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

process CLASSY_CROSSNN_CAPER_PILEUP {
    container "${params.classy_container ?: 'ghcr.io/chusj-pigu/classy:sha-6a3f603'}"
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
    tuple val(meta),
        path("*pies.svg"),
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
    def genome = refid == "hs1" ? 't2t' : refid
    def prefix = task.ext.prefix ?: "${meta.id}"

    """
    classy crossnn \\
        --pileup-input ${pileup} \\
        -o ${prefix}_crossnn_Capper_et_al_classification.json \\
        --sample ${prefix} \\
        --motif "CpG:CG" \\
        --crossnn-probes-genome hg19 \\
        --crossnn-alignment-genome ${genome} \\
        --crossnn-model /opt/classy/models/crossNN/runtime/Capper_et_al.safetensors \\
        --crossnn-embedding /opt/classy/models/crossNN/runtime/Capper_et_al_embedding.json \\
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
    touch ${meta.id}_class_pies.svg
    touch ${meta.id}.html
    echo '{}' > ${meta.id}_crossnn_Capper_et_al_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

process CLASSY_CROSSNN_PANCAN {
    container "${params.classy_container ?: 'ghcr.io/chusj-pigu/classy:sha-6a3f603'}"
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
        path("*pies.svg"),
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
    def genome = refid == "hs1" ? 't2t' : refid
    """
    classy crossnn \\
        -i ${bam} \\
        -o ${prefix}_crossnn_pancan_devel_v5i_classification.json \\
        --sample ${prefix} \\
        --use-pileup \\
        --motif "CpG:CG" \\
        --reference ${ref} \\
        --crossnn-probes-genome hg19 \\
        --crossnn-alignment-genome ${genome} \\
        --crossnn-model /opt/classy/models/crossNN/runtime/pancan_devel_v5i.safetensors \\
        --crossnn-embedding /opt/classy/models/crossNN/runtime/pancan_devel_v5i_embedding.json \\
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
    touch ${meta.id}_class_pies.svg
    touch ${meta.id}.html
    echo '{}' > ${meta.id}_crossnn_pancan_devel_v5i_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

process CLASSY_CROSSNN_PANCAN_PILEUP {
    container "${params.classy_container ?: 'ghcr.io/chusj-pigu/classy:sha-6a3f603'}"
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
    tuple val(meta),
        path("*pies.svg"),
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
    def genome = refid == "hs1" ? 't2t' : refid
    """
    classy crossnn \\
        --pileup-input ${pileup} \\
        -o ${prefix}_crossnn_pancan_devel_v5i_classification.json \\
        --sample ${prefix} \\
        --motif "CpG:CG" \\
        --crossnn-probes-genome hg19 \\
        --crossnn-alignment-genome ${genome} \\
        --crossnn-model /opt/classy/models/crossNN/runtime/pancan_devel_v5i.safetensors \\
        --crossnn-embedding /opt/classy/models/crossNN/runtime/pancan_devel_v5i_embedding.json \\
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
    touch ${meta.id}_class_pies.svg
    touch ${meta.id}.html
    echo '{}' > ${meta.id}_crossnn_pancan_devel_v5i_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

// ============================================================================
// Alma classifier processes
// ============================================================================

process CLASSY_ALMA {
    container "${params.classy_container ?: 'ghcr.io/chusj-pigu/classy:sha-6a3f603'}"
    label "classy"
    label "process_low"
    label "process_medium_cpu"
    label "process_medium_low_memory"
    label "process_low_time"

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
    def genome = refid == "hs1" ? 't2t' : refid
    """
    classy alma \\
        -i ${bam} \\
        -o ${prefix}_alma_classification.json \\
        --sample ${prefix} \\
        --reference ${ref} \\
        --use-pileup \\
        --motif "CpG:CG" \\
        --alma-model-root /opt/classy/models/alma \\
        --alma-data-dir /opt/classy/models/alma/probes \\
        --alma-probes-genome hg38 \\
        --alma-alignment-genome ${genome} \\
        --emit-alma-probabilities \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: Pre-release
        modkit: \$( modkit --version  | awk '{print \$2}')
        Alma: bundled
    END_VERSIONS
    """

    stub:
    """
    test -d /opt/classy/models/alma
    test -f /opt/classy/models/alma/probes/cpg_coordinates_hg38.bed.gz
    touch ${meta.id}.svg
    touch ${meta.id}.html
    echo '{}' > ${meta.id}_alma_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

process CLASSY_ALMA_PILEUP {
    container "${params.classy_container ?: 'ghcr.io/chusj-pigu/classy:sha-6a3f603'}"
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
    def genome = refid == "hs1" ? 't2t' : refid
    """
    classy alma \\
        --pileup-input ${pileup} \\
        -o ${prefix}_alma_classification.json \\
        --sample ${prefix} \\
        --motif "CpG:CG" \\
        --alma-model-root /opt/classy/models/alma \\
        --alma-data-dir /opt/classy/models/alma/probes \\
        --alma-probes-genome hg38 \\
        --alma-alignment-genome ${genome} \\
        --emit-alma-probabilities \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: Pre-release
        modkit: \$( modkit --version  | awk '{print \$2}')
        Alma: bundled
    END_VERSIONS
    """

    stub:
    """
    test -d /opt/classy/models/alma
    test -f /opt/classy/models/alma/probes/cpg_coordinates_hg38.bed.gz
    touch ${meta.id}.svg
    touch ${meta.id}.html
    echo '{}' > ${meta.id}_alma_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

// ============================================================================
// Lamprey classifier processes
// ============================================================================

process CLASSY_LAMPREY {
    container "${params.classy_container ?: 'ghcr.io/chusj-pigu/classy:sha-6a3f603'}"
    label "classy"
    label "process_low"
    label "process_medium_cpu"
    label "process_medium_low_memory"
    label "process_low_time"

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
    def genome = refid == "hs1" ? 't2t' : refid
    def probes_genome = genome == "hg19" ? 'hg38' : "${genome}"
    """
    classy lamprey \\
        -i ${bam} \\
        -o ${prefix}_lamprey_classification.json \\
        --sample ${prefix} \\
        --reference ${ref} \\
        --use-pileup \\
        --motif "CpG:CG" \\
        --lamprey-model-root /opt/classy/models/Lamprey \\
        --lamprey-probes-genome ${probes_genome} \\
        --lamprey-alignment-genome ${genome} \\
        --emit-lamprey-probabilities \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: Pre-release
        modkit: \$( modkit --version  | awk '{print \$2}')
        Lamprey: bundled
    END_VERSIONS
    """

    stub:
    """
    test -d /opt/classy/models/Lamprey
    test -f /opt/classy/models/Lamprey/probes/probe_hg38.bed
    touch ${meta.id}.svg
    touch ${meta.id}.html
    echo '{}' > ${meta.id}_lamprey_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

process CLASSY_LAMPREY_PILEUP {
    container "${params.classy_container ?: 'ghcr.io/chusj-pigu/classy:sha-6a3f603'}"
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
    def genome = refid == "hs1" ? 't2t' : refid
    def probes_genome = genome == "hg19" ? 'hg38' : "${genome}"
    """
    classy lamprey \\
        --pileup-input ${pileup} \\
        -o ${prefix}_lamprey_classification.json \\
        --sample ${prefix} \\
        --motif "CpG:CG" \\
        --lamprey-model-root /opt/classy/models/Lamprey \\
        --lamprey-probes-genome ${probes_genome} \\
        --lamprey-alignment-genome ${genome} \\
        --emit-lamprey-probabilities \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: Pre-release
        modkit: \$( modkit --version  | awk '{print \$2}')
        Lamprey: bundled
    END_VERSIONS
    """

    stub:
    """
    test -d /opt/classy/models/Lamprey
    test -f /opt/classy/models/Lamprey/probes/probe_hg38.bed
    touch ${meta.id}.svg
    touch ${meta.id}.html
    echo '{}' > ${meta.id}_lamprey_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

// ============================================================================
// M-PACT classifier processes
// ============================================================================

process CLASSY_MPACT {
    container "${params.classy_container ?: 'ghcr.io/chusj-pigu/classy:sha-6a3f603'}"
    label "classy"
    label "process_low"
    label "process_medium_cpu"
    label "process_medium_low_memory"
    label "process_low_time"

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
    def genome = refid == "hs1" ? 't2t' : refid
    """
    classy mpact \\
        -i ${bam} \\
        -o ${prefix}_mpact_classification.json \\
        --sample ${prefix} \\
        --reference ${ref} \\
        --use-pileup \\
        --motif "CpG:CG" \\
        --mpact-model-root /opt/classy/models/MPACT \\
        --mpact-manifest /opt/classy/models/MPACT/runtime/model.json \\
        --mpact-probes-genome hg38 \\
        --mpact-alignment-genome ${genome} \\
        --mpact-method max \\
        --mpact-cutoff 0.7 \\
        --emit-mpact-probabilities \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: Pre-release
        modkit: \$( modkit --version  | awk '{print \$2}')
        MPACT: bundled
    END_VERSIONS
    """

    stub:
    """
    test -d /opt/classy/models/MPACT
    test -f /opt/classy/models/MPACT/runtime/model.json
    test -f /opt/classy/models/MPACT/probes/probes_hg38.bed
    touch ${meta.id}.svg
    touch ${meta.id}.html
    echo '{}' > ${meta.id}_mpact_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

process CLASSY_MPACT_PILEUP {
    container "${params.classy_container ?: 'ghcr.io/chusj-pigu/classy:sha-6a3f603'}"
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
    def genome = refid == "hs1" ? 't2t' : refid
    """
    classy mpact \\
        --pileup-input ${pileup} \\
        -o ${prefix}_mpact_classification.json \\
        --sample ${prefix} \\
        --motif "CpG:CG" \\
        --mpact-model-root /opt/classy/models/MPACT \\
        --mpact-manifest /opt/classy/models/MPACT/runtime/model.json \\
        --mpact-probes-genome hg38 \\
        --mpact-alignment-genome ${genome} \\
        --mpact-method max \\
        --mpact-cutoff 0.7 \\
        --emit-mpact-probabilities \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: Pre-release
        modkit: \$( modkit --version  | awk '{print \$2}')
        MPACT: bundled
    END_VERSIONS
    """

    stub:
    """
    test -d /opt/classy/models/MPACT
    test -f /opt/classy/models/MPACT/runtime/model.json
    test -f /opt/classy/models/MPACT/probes/probes_hg38.bed
    touch ${meta.id}.svg
    touch ${meta.id}.html
    echo '{}' > ${meta.id}_mpact_classification.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

// ============================================================================
// Combined classifier processes
// ============================================================================

process CLASSY_COMBINED {
    container "${params.classy_container ?: 'ghcr.io/chusj-pigu/classy:sha-6a3f603'}"
    label "classy"
    label "process_low"
    label "process_medium_cpu"
    label "process_medium_mid_memory"
    label "process_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        val(refid),
        path(ref)

    output:
    tuple val(meta),
        path("*combined_blood.svg"),
        emit:svg_blood
    tuple val(meta),
        path("*combined_brain.svg"),
        emit:svg_brain
    tuple val(meta),
        path("*combined_solid.svg"),
        emit:svg_solid
    tuple val(meta),
        path("*combined_classification.json"),
        emit:json_combined
    tuple val(meta),
        path("*combined_task_pies.svg"),
        emit:svg_combined
    tuple val(meta),
        path("*nanomix_pie.svg"),
        emit:svg_nanomix
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def threads = task.cpus
    def prefix = task.ext.prefix ?: "${meta.id}"
    def genome = refid == "hs1" ? 't2t' : refid
    def sturgeon_probes_genome = genome == "hg19" ? 'hg38' : "${genome}"
    def lamprey_probes_genome = genome == "hg19" ? 'hg38' : "${genome}"
    """
    classy combined \\
        -i ${bam} \\
        -o ${prefix}_combined_classification.json \\
        --sample ${prefix} \\
        --reference ${ref} \\
        --use-pileup \\
        --motif "CpG:CG" \\
        --genome ${genome} \\
        --pileup-threads ${threads} \\
        --crossnn-probes-genome hg19 \\
        --crossnn-alignment-genome ${genome} \\
        --tucan-probes-genome "t2t" \\
        --tucan-alignment-genome ${genome} \\
        --sturgeon-probes-genome ${sturgeon_probes_genome} \\
        --sturgeon-alignment-genome ${genome} \\
        --sturgeon-model /opt/classy/models/Sturgeon \\
        --tucan-model /opt/classy/models/tucan/runtime/model.safetensors \\
        --tucan-num-cpgs 10000 \\
        --tucan-num-samplings 1 \\
        --alma-model-root /opt/classy/models/alma \\
        --alma-data-dir /opt/classy/models/alma/probes \\
        --alma-probes-genome hg38 \\
        --alma-alignment-genome ${genome} \\
        --lamprey-model-root /opt/classy/models/Lamprey \\
        --lamprey-probes-genome ${lamprey_probes_genome} \\
        --lamprey-alignment-genome ${genome} \\
        --mpact-model-root /opt/classy/models/MPACT \\
        --mpact-manifest /opt/classy/models/MPACT/runtime/model.json \\
        --mpact-probes-genome hg38 \\
        --mpact-alignment-genome ${genome} \\
        --mpact-method max \\
        --mpact-cutoff 0.7 \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: Pre-release
        modkit: \$( modkit --version  | awk '{print \$2}')
        Combined: bundled
    END_VERSIONS
    """

    stub:
    """
    test -d /opt/classy/models/Sturgeon
    test -f /opt/classy/models/tucan/runtime/model.safetensors
    test -d /opt/classy/models/alma
    test -d /opt/classy/models/Lamprey
    test -d /opt/classy/models/MPACT
    test -f /opt/classy/models/MPACT/runtime/model.json
    echo '{}' > ${meta.id}_combined_classification.json
    echo '{}' > ${meta.id}_combined_classification_lamprey.json
    echo '{}' > ${meta.id}_combined_classification_mpact.json
    touch ${meta.id}_combined_classification_lamprey_lamprey_pie.svg
    touch ${meta.id}_combined_classification_lamprey_lamprey_pie.html
    touch ${meta.id}_combined_classification_mpact_mpact_pie.svg
    touch ${meta.id}_combined_classification_mpact_mpact_pie.html
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}

process CLASSY_COMBINED_PILEUP {
    container "${params.classy_container ?: 'ghcr.io/chusj-pigu/classy:sha-6a3f603'}"
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
    def genome = refid == "hs1" ? 't2t' : refid
    def sturgeon_probes_genome = genome == "hg19" ? 'hg38' : "${genome}"
    def lamprey_probes_genome = genome == "hg19" ? 'hg38' : "${genome}"
    """
    classy combined \\
        --pileup-input ${pileup} \\
        -o ${prefix}_combined_classification.json \\
        --sample ${prefix} \\
        --motif "CpG:CG" \\
        --genome ${genome} \\
        --crossnn-probes-genome hg19 \\
        --crossnn-alignment-genome ${genome} \\
        --tucan-probes-genome "t2t" \\
        --tucan-alignment-genome ${genome} \\
        --sturgeon-probes-genome ${sturgeon_probes_genome} \\
        --sturgeon-alignment-genome ${genome} \\
        --sturgeon-model /opt/classy/models/Sturgeon \\
        --tucan-model /opt/classy/models/tucan/runtime/model.safetensors \\
        --tucan-num-cpgs 10000 \\
        --tucan-num-samplings 1 \\
        --alma-model-root /opt/classy/models/alma \\
        --alma-data-dir /opt/classy/models/alma/probes \\
        --alma-probes-genome hg38 \\
        --alma-alignment-genome ${genome} \\
        --lamprey-model-root /opt/classy/models/Lamprey \\
        --lamprey-probes-genome ${lamprey_probes_genome} \\
        --lamprey-alignment-genome ${genome} \\
        --mpact-model-root /opt/classy/models/MPACT \\
        --mpact-manifest /opt/classy/models/MPACT/runtime/model.json \\
        --mpact-probes-genome hg38 \\
        --mpact-alignment-genome ${genome} \\
        --mpact-method max \\
        --mpact-cutoff 0.7 \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: Pre-release
        modkit: \$( modkit --version  | awk '{print \$2}')
        Combined: bundled
    END_VERSIONS
    """

    stub:
    """
    test -d /opt/classy/models/Sturgeon
    test -f /opt/classy/models/tucan/runtime/model.safetensors
    test -d /opt/classy/models/alma
    test -d /opt/classy/models/Lamprey
    test -d /opt/classy/models/MPACT
    test -f /opt/classy/models/MPACT/runtime/model.json
    echo '{}' > ${meta.id}_combined_classification.json
    echo '{}' > ${meta.id}_combined_classification_lamprey.json
    echo '{}' > ${meta.id}_combined_classification_mpact.json
    touch ${meta.id}_combined_classification_lamprey_lamprey_pie.svg
    touch ${meta.id}_combined_classification_lamprey_lamprey_pie.html
    touch ${meta.id}_combined_classification_mpact_mpact_pie.svg
    touch ${meta.id}_combined_classification_mpact_mpact_pie.html
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        classy: stub
    END_VERSIONS
    """
}
