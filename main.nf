process SNIFFLES_CALL {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/sniffles:latest"

    label 'process_medium'                    // nf-core labels
    label "process_mid_cpu"                 // Label for mpgi drac cpu alloc
    label "process_medium_mid_memory"         // Label for mpgi drac memory alloc
    label "process_mid_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        val(ref_type),
        path(ref_fasta),
        path(ref_fai)

    output:
    tuple val(meta),
        path("*.vcf.gz"),
        emit: vcf
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def isPhased = bam.baseName.contains('phased')
    def argsPhased = isPhased ? '--phase' : ''
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    def tr_bed = ref_type in ["hg38", "GRCh38"] \
        ? "--tandem-repeats /opt/app/human_GRCh38_no_alt_analysis_set.trf.bed" \
        : ref_type in ["hg19", "GRCh37"] \
        ? "--tandem-repeats /opt/app/human_hs37d5.trf.bed" \
        : ""
    """
    sniffles \\
        --input ${bam} \\
        --reference ${ref_fasta} \\
        ${tr_bed} \\
        ${args} \\
        ${argsPhased} \\
        -t ${threads} \\
        --vcf ${prefix}_sv.vcf.gz

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        Sniffles2: \$(echo \$(sniffles --version 2>&1) | awk '{print \$NF}' )
    END_VERSIONS
    """
}
