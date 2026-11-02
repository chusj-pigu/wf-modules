process DELLY_CNV {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/delly:4c07465cd477798fc6fe0b06d941dbe8acdba7bb'

    tag "$meta.id"
    label 'process_low'
    label 'process_medium_low_cpu'
    label 'process_medium_mid_memory'
    label 'process_low_time'

    input:
    tuple val(meta),
        path(bam),
        path(bai)
    tuple val(meta2), path(fasta)

    output:
    tuple val(meta),
        path("*.cov.gz"),
        emit: cov
    tuple val(meta),
        path("*.bcf"),
        emit: bcf
    tuple val(meta),
        path("*.stats.gz"),
        emit: stats
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def map = meta2.id == "hg38" ?
        "/opt/data/Homo_sapiens.GRCh38.dna.primary_assembly.fa.r101.s501.blacklist.gz" :
        (meta2.id == "hg19" ? "/opt/data/Homo_sapiens.GRCh37.dna.primary_assembly.fa.r101.s501.blacklist.gz" :
        "/opt/data/T2T-CHM13v1.1.fa.r101.s501.gz")
    def window = params.delly_bin_size
    """
    delly cnv \\
        ${args} \\
        -g ${fasta} \\
        -i ${window} \\
        -w ${window} \\
        -m ${map} \\
        -c ${prefix}_delly_out.cov.gz \\
        -o ${prefix}_delly.out.bcf  \\
        -s ${prefix}_delly.stats.gz \\
        ${bam}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        Delly: \$( delly -v 2>&1 | grep "Delly version" | awk '{print \$NF}' )
        Boost: \$( delly -v 2>&1 | grep "Boost" | awk '{print \$NF}' )
        HTSlib: \$( delly -v 2>&1 | grep "HTSlib" | awk '{print \$NF}' )
    END_VERSIONS
    """
}
