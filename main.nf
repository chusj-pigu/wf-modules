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
