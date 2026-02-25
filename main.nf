nextflow.enable.dsl=2

process GFF_TO_GTF {
    // TODO : UNCOMMENT WHEN GENEMANCER CONTAINER IS AVAILABLE
    // container 'ghcr.io/chusj-pigu/genemancer:latest'

    tag { gff3.baseName }
    label 'process_low'
    label 'process_medium_low_cpu'
    label 'process_medium_mid_memory'
    label 'process_low_time'

    input:
    path gff3

    output:
    path "${gff3.simpleName}.gtf"

    script:
    """
    genemancer gff-to-gtf \
      -i ${gff3} \
      -o ${gff3.simpleName}.gtf
    """
}

process MERGE_BAM {
    // TODO : UNCOMMENT WHEN GENEMANCER CONTAINER IS AVAILABLE
    // container 'ghcr.io/chusj-pigu/genemancer:latest'

    tag "merge"
    label 'process_low'
    label 'process_medium_low_cpu'
    label 'process_medium_mid_memory'
    label 'process_low_time'

    input:
    path bams

    output:
    path "merged.bam"
    path "merged.bam.*", optional: true

    script:
    def inputArgs = bams.collect { "-i ${it}" }.join(' ')
    """
    genemancer merge-bam \
      ${inputArgs} \
      -o merged.bam \
      --index
    """
}

process SPLIT_BAM {
    // TODO : UNCOMMENT WHEN GENEMANCER CONTAINER IS AVAILABLE
    // container 'ghcr.io/chusj-pigu/genemancer:latest'

    tag { bam.baseName }
    label 'process_low'
    label 'process_medium_low_cpu'
    label 'process_medium_mid_memory'
    label 'process_low_time'

    cpus 4

    input:
    path bam
    path bed

    output:
    path "split_bam_out"

    script:
    def extraArgs = task.ext.args ?: ""
    """
    genemancer -t ${task.cpus} split-bam \
      --input ${bam} \
      --bed ${bed} \
      --out-dir split_bam_out \
      ${extraArgs}
    """
}

process CALL_TARGETS {
    // TODO : UNCOMMENT WHEN GENEMANCER CONTAINER IS AVAILABLE
    // container 'ghcr.io/chusj-pigu/genemancer:latest'

    tag "call-targets"
    label 'process_low'
    label 'process_medium_low_cpu'
    label 'process_medium_mid_memory'
    label 'process_low_time'

    input:
    path bam
    path reference
    path targets
    path rg_map, optional: true

    output:
    path "calls.vcf.gz"
    path "calls.vcf.gz.*", optional: true

    script:
    def rgArg = rg_map ? "--rg-map ${rg_map}" : ""
    """
    genemancer call-targets \
      -i ${bam} \
      -r ${reference} \
      -T ${targets} \
      -o calls.vcf.gz \
      ${rgArg}
    """
}

process CALL_TARGETS_GPU {
    // TODO : UNCOMMENT WHEN GENEMANCER CONTAINER IS AVAILABLE
    // container 'ghcr.io/chusj-pigu/genemancer:latest'

    tag "call-targets-gpu"
    label 'process_low'
    label 'process_medium_low_cpu'
    label 'process_medium_mid_memory'
    label 'process_low_time'

    input:
    path bam
    path reference
    path targets
    path rg_map, optional: true

    output:
    path "calls.vcf.gz"
    path "calls.vcf.gz.*", optional: true

    script:
    def rgArg = rg_map ? "--rg-map ${rg_map}" : ""
    """
    genemancer call-targets-gpu \
      -i ${bam} \
      -r ${reference} \
      -T ${targets} \
      -o calls.vcf.gz \
      ${rgArg} \
      --gpu-backend auto
    """
}

process NANOCOV {
    // TODO : UNCOMMENT WHEN NANOCOV CONTAINER IS AVAILABLE
    // container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'

    tag { bam.baseName }
    label 'process_low'
    label 'process_medium_low_cpu'
    label 'process_medium_mid_memory'
    label 'process_low_time'

    cpus 4

    input:
    path bam

    output:
    path "nanocov_out"

    script:
    def extraArgs = task.ext.args ?: ""
    """
    nanocov \
      --input ${bam} \
      --threads ${task.cpus} \
      --output-dir nanocov_out \
      ${extraArgs}
    """
}

process NANOCOV_BATCH {
    // TODO : UNCOMMENT WHEN NANOCOV CONTAINER IS AVAILABLE
    // container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'

    tag "nanocov-batch"
    label 'process_low'
    label 'process_medium_low_cpu'
    label 'process_medium_mid_memory'
    label 'process_low_time'

    cpus 4

    input:
    path batch_tsv

    output:
    path "nanocov_out"

    script:
    def extraArgs = task.ext.args ?: ""
    """
    nanocov \
      --batch-tsv ${batch_tsv} \
      --threads ${task.cpus} \
      --output-dir nanocov_out \
      ${extraArgs}
    """
}
