nextflow.enable.dsl=2

process GFF_TO_GTF {
    container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'

    tag "$meta.id"
    label 'process_low'
    label 'process_medium_low_cpu'
    label 'process_medium_mid_memory'
    label 'process_low_time'

    input:
    tuple val(meta),
        path(gff3)

    output:
    tuple val(meta),
        path("${gff3.simpleName}.gtf"),
        emit: gtf
    tuple val(meta),
        path("*.command.txt"),
        emit: command
    path "versions.yml", emit: versions

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    genemancer gff-to-gtf \
      -i ${gff3} \
      -o ${gff3.simpleName}.gtf

    cat <<-'END_COMMAND' > ${prefix}.command.txt
    genemancer gff-to-gtf \
      -i ${gff3} \
      -o ${gff3.simpleName}.gtf
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        genemancer: "\$(genemancer --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}

process MERGE_BAM {
    container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'

    tag "$meta.id"
    label 'process_low'
    label 'process_medium_low_cpu'
    label 'process_medium_mid_memory'
    label 'process_low_time'

    input:
    tuple val(meta),
        path(bams)

    output:
    tuple val(meta),
        path("merged.bam"),
        emit: bam
    tuple val(meta),
        path("merged.bam.*"),
        emit: index,
        optional: true
    tuple val(meta),
        path("*.command.txt"),
        emit: command
    path "versions.yml", emit: versions

    script:
    def inputArgs = bams.collect { "-i ${it}" }.join(' ')
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    genemancer merge-bam \
      ${inputArgs} \
      -o merged.bam \
      --index

    cat <<-'END_COMMAND' > ${prefix}.command.txt
    genemancer merge-bam \
      ${inputArgs} \
      -o merged.bam \
      --index
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        genemancer: "\$(genemancer --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}

process SPLIT_BAM {
    container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'

    tag "$meta.id"
    label 'process_low'
    label 'process_medium_low_cpu'
    label 'process_medium_mid_memory'
    label 'process_low_time'

    cpus 4

    input:
    tuple val(meta),
        path(bamlist),
        path(bed)

    output:
    tuple val(meta),
        path("*_split_bam_out"),
        emit: outdir
    tuple val(meta),
        path("*.command.txt"),
        emit: command
    path "versions.yml", emit: versions

    script:
    def extraArgs = task.ext.args ?: ""
    def prefix = task.ext.prefix ?: "${meta.id}"
    def writeIndicesArg = extraArgs.contains('--write-indices') ? '' : '--write-indices'
    """
    input_args=""
    while IFS= read -r bam; do
      [ -z "\$bam" ] && continue
      [[ "\$bam" =~ ^# ]] && continue
      resolved_bam="\$bam"
      if [[ "\$resolved_bam" != /* ]]; then
        resolved_bam="${projectDir}/\$resolved_bam"
      fi
      if [ ! -f "\$resolved_bam" ]; then
        echo "ERROR: Missing BAM: \$bam (resolved to: \$resolved_bam)" >&2
        exit 1
      fi
      input_args="\${input_args}-i \${resolved_bam} "
    done < ${bamlist}
    if [ -z "\${input_args}" ]; then
      echo "ERROR: BAM list is empty: ${bamlist}" >&2
      exit 1
    fi

    genemancer -t ${task.cpus} split-bam \
      \${input_args} \
      --bed ${bed} \
      --out-dir ${prefix}_split_bam_out \
      ${writeIndicesArg} \
      ${extraArgs}

    cat <<-'END_COMMAND' > ${prefix}.command.txt
    input_args=""
    while IFS= read -r bam; do
      [ -z "\$bam" ] && continue
      [[ "\$bam" =~ ^# ]] && continue
      resolved_bam="\$bam"
      if [[ "\$resolved_bam" != /* ]]; then
        resolved_bam="${projectDir}/\$resolved_bam"
      fi
      input_args="\${input_args}-i \${resolved_bam} "
    done < ${bamlist}
    genemancer -t ${task.cpus} split-bam \
      \${input_args} \
      --bed ${bed} \
      --out-dir ${prefix}_split_bam_out \
      ${writeIndicesArg} \
      ${extraArgs}
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        genemancer: "\$(genemancer --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}

process CALL_TARGETS {
    container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'

    tag "$meta.id"
    label 'process_low'
    label 'process_medium_low_cpu'
    label 'process_medium_mid_memory'
    label 'process_low_time'

    input:
    tuple val(meta),
        path(bamlist),
        path(reference),
        path(targets),
        path(rg_map)

    output:
    tuple val(meta),
        path("calls.vcf.gz"),
        emit: vcf
    tuple val(meta),
        path("calls.vcf.gz.{tbi,csi}"),
        emit: index
    tuple val(meta),
        path("*.command.txt"),
        emit: command
    path "versions.yml", emit: versions

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    def extraArgs = task.ext.args ?: ""
    def indexTypeArg = extraArgs.contains('--index-type') ? '' : '--index-type tbi'
    """
    input_args=""
    while IFS= read -r bam; do
      [ -z "\$bam" ] && continue
      [[ "\$bam" =~ ^# ]] && continue
      resolved_bam="\$bam"
      if [[ "\$resolved_bam" != /* ]]; then
        resolved_bam="${projectDir}/\$resolved_bam"
      fi
      if [ ! -f "\$resolved_bam" ]; then
        echo "ERROR: Missing BAM: \$bam (resolved to: \$resolved_bam)" >&2
        exit 1
      fi
      input_args="\${input_args}-i \${resolved_bam} "
    done < ${bamlist}
    if [ -z "\${input_args}" ]; then
      echo "ERROR: BAM list is empty: ${bamlist}" >&2
      exit 1
    fi

    genemancer call-targets \
      \${input_args} \
      -r ${reference} \
      -T ${targets} \
      --rg-map ${rg_map} \
      ${indexTypeArg} \
      -o calls.vcf.gz \
      ${extraArgs}

    cat <<-'END_COMMAND' > ${prefix}.command.txt
    input_args=""
    while IFS= read -r bam; do
      [ -z "\$bam" ] && continue
      [[ "\$bam" =~ ^# ]] && continue
      resolved_bam="\$bam"
      if [[ "\$resolved_bam" != /* ]]; then
        resolved_bam="${projectDir}/\$resolved_bam"
      fi
      input_args="\${input_args}-i \${resolved_bam} "
    done < ${bamlist}
    genemancer call-targets \
      \${input_args} \
      -r ${reference} \
      -T ${targets} \
      --rg-map ${rg_map} \
      ${indexTypeArg} \
      -o calls.vcf.gz \
      ${extraArgs}
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        genemancer: "\$(genemancer --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}

process CALL_TARGETS_GPU {
    container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'

    tag "$meta.id"
    label 'process_low'
    label 'process_medium_low_cpu'
    label 'process_medium_mid_memory'
    label 'process_low_time'

    input:
    tuple val(meta),
        path(bamlist),
        path(reference),
        path(targets),
        path(rg_map)

    output:
    tuple val(meta),
        path("calls.vcf.gz"),
        emit: vcf
    tuple val(meta),
        path("calls.vcf.gz.{tbi,csi}"),
        emit: index
    tuple val(meta),
        path("*.command.txt"),
        emit: command
    path "versions.yml", emit: versions

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    def extraArgs = task.ext.args ?: ""
    def indexTypeArg = extraArgs.contains('--index-type') ? '' : '--index-type tbi'
    """
    input_args=""
    while IFS= read -r bam; do
      [ -z "\$bam" ] && continue
      [[ "\$bam" =~ ^# ]] && continue
      resolved_bam="\$bam"
      if [[ "\$resolved_bam" != /* ]]; then
        resolved_bam="${projectDir}/\$resolved_bam"
      fi
      if [ ! -f "\$resolved_bam" ]; then
        echo "ERROR: Missing BAM: \$bam (resolved to: \$resolved_bam)" >&2
        exit 1
      fi
      input_args="\${input_args}-i \${resolved_bam} "
    done < ${bamlist}
    if [ -z "\${input_args}" ]; then
      echo "ERROR: BAM list is empty: ${bamlist}" >&2
      exit 1
    fi

    genemancer call-targets-gpu \
      \${input_args} \
      -r ${reference} \
      -T ${targets} \
      --rg-map ${rg_map} \
      ${indexTypeArg} \
      -o calls.vcf.gz \
      --gpu-backend auto \
      ${extraArgs}

    cat <<-'END_COMMAND' > ${prefix}.command.txt
    input_args=""
    while IFS= read -r bam; do
      [ -z "\$bam" ] && continue
      [[ "\$bam" =~ ^# ]] && continue
      resolved_bam="\$bam"
      if [[ "\$resolved_bam" != /* ]]; then
        resolved_bam="${projectDir}/\$resolved_bam"
      fi
      input_args="\${input_args}-i \${resolved_bam} "
    done < ${bamlist}
    genemancer call-targets-gpu \
      \${input_args} \
      -r ${reference} \
      -T ${targets} \
      --rg-map ${rg_map} \
      ${indexTypeArg} \
      -o calls.vcf.gz \
      --gpu-backend auto \
      ${extraArgs}
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        genemancer: "\$(genemancer --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}

process NANOCOV {
    container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'

    tag "$meta.id"
    label 'process_low'
    label 'process_medium_low_cpu'
    label 'process_medium_mid_memory'
    label 'process_low_time'

    cpus 4

    input:
    tuple val(meta),
        path(bam)

    output:
    tuple val(meta),
        path("nanocov_out"),
        emit: outdir
    tuple val(meta),
        path("*.command.txt"),
        emit: command
    path "versions.yml", emit: versions

    script:
    def extraArgs = task.ext.args ?: ""
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    nanocov \
      --input ${bam} \
      --threads ${task.cpus} \
      --output-dir nanocov_out \
      ${extraArgs}

    cat <<-'END_COMMAND' > ${prefix}.command.txt
    nanocov \
      --input ${bam} \
      --threads ${task.cpus} \
      --output-dir nanocov_out \
      ${extraArgs}
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        nanocov: "\$(nanocov --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}

process NANOCOV_BATCH {
    container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'

    tag "$meta.id"
    label 'process_low'
    label 'process_medium_low_cpu'
    label 'process_medium_mid_memory'
    label 'process_low_time'

    cpus 4

    input:
    tuple val(meta),
        path(batch_tsv)

    output:
    tuple val(meta),
        path("nanocov_out"),
        emit: outdir
    tuple val(meta),
        path("*.command.txt"),
        emit: command
    path "versions.yml", emit: versions

    script:
    def extraArgs = task.ext.args ?: ""
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    nanocov \
      --batch-tsv ${batch_tsv} \
      --threads ${task.cpus} \
      --output-dir nanocov_out \
      ${extraArgs}

    cat <<-'END_COMMAND' > ${prefix}.command.txt
    nanocov \
      --batch-tsv ${batch_tsv} \
      --threads ${task.cpus} \
      --output-dir nanocov_out \
      ${extraArgs}
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        nanocov: "\$(nanocov --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}
