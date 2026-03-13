nextflow.enable.dsl=2

def DORADO_CONTAINER =
    'ghcr.io/chusj-pigu/dorado:851b0a37ecbff6b3b952c811b31dad48ca6bf995'

process DORADO_BASECALL {
    container DORADO_CONTAINER

    // nf-core resource label
    label "process_high"

    // MPGI DRAC resource labels
    label "process_medium_low_cpu"
    label "process_higher_memory"
    label "process_medium_high_time"
    label "process_gpu"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(pod5),
        path(ubam),
        val(model),
        val(model_mh)

    output:
    tuple val(meta),
        path("*.bam"),
        emit: ubam
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def device = params.device != null ? "-x $params.device" : ""
    def modelValue = model.toString()
    def localModel = modelValue.contains('/') || modelValue.startsWith('.')
    def modelFile = (params.basecall_offline || localModel)
        ? file(modelValue)
        : null
    def modelArg = localModel ? modelFile.name : modelValue
    def modelsDirectoryArg = modelFile
        ? "--models-directory ${modelFile.parent}"
        : ""
    def useLocalModels = params.basecall_offline || localModel
    def mod = (useLocalModels && model_mh != 'none')
        ? "--modified-bases-models ${modelFile.parent}/${model_mh}"
        : ((model_mh != 'none' && !params.basecall_offline)
            ? "--modified-bases ${model_mh}"
            : "")
    def multi = params.demux ? "--no-trim" : ""
    def resume = ubam.name != 'NOFILE'
        ? "--resume-from $ubam > ${prefix}_unaligned_final.bam"
        : "> ${prefix}_unaligned.bam"
    """
    dorado basecaller \\
        $args \\
        $device \\
        $modelsDirectoryArg \\
        $modelArg \\
        $pod5 \\
        $mod \\
        $multi \\
        $resume

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        dorado: \$(echo \$(dorado --version 2>&1) | \
            sed 's/^.*dorado //; s/Using.*\$//')
    END_VERSIONS
    """
}

process DORADO_DEMULTIPLEX {
    container DORADO_CONTAINER

    // nf-core resource label
    label "process_high"

    // MPGI DRAC resource labels
    label "process_high_cpu"
    label "process_medium_low_memory"
    label "process_medium_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        val(kit),
        path(bam)

    output:
    tuple val(meta),
        path("${meta.id}"),
        emit: demux
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    dorado \\
        demux \\
        $args \\
        --kit-name ${kit} \\
        --output-dir $prefix \\
        $bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        dorado: \$(echo \$(dorado --version 2>&1) | \
            sed 's/^.*dorado //; s/Using.*\$//')
    END_VERSIONS
    """
}

process DORADO_DOWNLOAD_MODEL {
    container DORADO_CONTAINER

    // nf-core resource label
    label "process_low"

    // MPGI DRAC resource labels
    label "process_single_cpu"
    label "process_very_low_memory"
    label "process_very_low_time"

    tag "${meta.id}:${model_name}"

    input:
    tuple val(meta),
        val(model_name),
        val(models_directory)

    output:
    tuple val(meta),
        path("${model_name}"),
        emit: model
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    alias_path="${models_directory}/${model_name}"

    mkdir -p "${models_directory}"

    if [ ! -e "\${alias_path}" ]; then
        dorado download \\
            $args \\
            --model "${model_name}" \\
            --models-directory "${models_directory}"

        if [ ! -e "\${alias_path}" ]; then
            model_path=\$(find "${models_directory}" -mindepth 1 -maxdepth 1 \
                -type d -printf '%T@ %p\\n' | sort -n | tail -n 1 | \
                cut -d' ' -f2-)

            if [ -z "\${model_path}" ]; then
                echo "No Dorado model was downloaded into ${models_directory}" \
                    >&2
                exit 1
            fi

            ln -sfn "\${model_path}" "\${alias_path}"
        fi
    fi

    ln -sfn "\${alias_path}" "${model_name}"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        dorado: \$(echo \$(dorado --version 2>&1) | \
            sed 's/^.*dorado //; s/Using.*\$//')
    END_VERSIONS
    """
}

process DORADO_TRIM {
    container 'ghcr.io/chusj-pigu/dorado:851b0a37ecbff6b3b952c811b31dad48ca6bf995'
    label "process_high"                    // nf-core label
    label "process_high_cpu"                 // Label for mpgi drac cpu alloc
    label "process_medium_low_memory"        // Label for mpgi drac memory alloc
    label "process_medium_low_time"          // Label for mpgi drac time alloc

    tag "$meta.id"

    input:
    tuple val(meta),
        val(kit),
        path(bam)

    output:
    tuple val(meta),
        path("*.bam"),
        emit: bam
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    dorado \\
        trim \\
        $args \\
        -t ${threads} \\
        -k ${kit} > ${prefix}_trimmed.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        dorado: \$(echo \$(dorado --version 2>&1) | sed 's/^.*dorado //; s/Using.*\$//')
    END_VERSIONS
    """
}
