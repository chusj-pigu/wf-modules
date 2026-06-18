process SEVERUS_TUMOR_PHASED {
    container "ghcr.io/chusj-pigu/severus:latest" // TO DO: SET CONTAINER TO FIXED VERSION

    tag "$meta.id"
    label 'process_medium'                    // nf-core labels
    label "process_medium_low_cpu"              // Label for mpgi drac cpu alloc
    label "process_medium_memory"         // Label for mpgi drac memory alloc
    label "process_low_time"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        path(snp_vcf),
        val(genome)

    output:
    tuple val(meta),
        path("somatic_SVs/severus_somatic.vcf"),
        emit: vcf
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def threads = task.cpus
    def vntr = genome == 'hg38' ? '--vntr-bed /opt/app/Severus/vntrs/human_GRCh38_no_alt_analysis_set.trf.bed' :
        (genome == 'hs1' ? '--vntr-bed /opt/app/Severus/vntrs/chm13.bed' : '')
    def pon  = genome == 'hg38' ? '--PON /opt/app/Severus/pon/PoN_1000G_hg38.tsv.gz' :
        (genome == 'hs1' ? '--PON /opt/app/Severus/pon/PoN_1000G_chm13.tsv.gz' : '')
    """
    severus \\
        ${args} \\
        --target-bam ${bam} \\
        --out-dir '.' \\
        -t ${threads} \\
        --phasing-vcf ${snp_vcf} \\
        ${vntr} ${pon}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        Severus: \$(severus -v)
    END_VERSIONS
    """
}

process SEVERUS_TUMOR_UNPHASED {
    container "ghcr.io/chusj-pigu/severus:latest" // TO DO: SET CONTAINER TO FIXED VERSION

    tag "$meta.id"
    label 'process_medium'                    // nf-core labels
    label "process_medium_low_cpu"              // Label for mpgi drac cpu alloc
    label "process_medium_memory"         // Label for mpgi drac memory alloc
    label "process_low_time"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        val(genome)

    output:
    tuple val(meta),
        path("somatic_SVs/severus_somatic.vcf"),
        emit: vcf
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def threads = task.cpus
    def vntr = genome == 'hg38' ? '--vntr-bed /opt/app/Severus/vntrs/human_GRCh38_no_alt_analysis_set.trf.bed' :
        (genome == 'hs1' ? '--vntr-bed /opt/app/Severus/vntrs/chm13.bed' : '')
    def pon  = genome == 'hg38' ? '--PON /opt/app/Severus/pon/PoN_1000G_hg38.tsv.gz' :
        (genome == 'hs1' ? '--PON /opt/app/Severus/pon/PoN_1000G_chm13.tsv.gz' : '')
    """
    severus \\
        ${args} \\
        --target-bam ${bam} \\
        --out-dir '.' \\
        -t ${threads} \\
        ${vntr} ${pon}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        Severus: \$(severus -v)
    END_VERSIONS
    """
}
