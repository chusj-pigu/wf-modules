process DELLY_CNV {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/delly:latest'

    tag "$meta.id"
    label 'process_low'
    label 'process_medium_low_cpu'
    label 'process_medium_mid_memory'
    label 'process_low_time'

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        val(ref_id),
        path(ref)

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
    def map = ref_id in ["hg38", "GRCh38"] ?
        "/opt/data/Homo_sapiens.GRCh38.dna.primary_assembly.fa.r101.s501.blacklist.gz" :
        "/opt/data/Homo_sapiens.GRCh37.dna.primary_assembly.fa.r101.s501.blacklist.gz"
    def window = params.delly_bin_size
    """
    delly cnv \\
        ${args} \\
        -g ${ref} \\
        -i ${window} \\
        -w ${window} \\
        -m ${map} \\
        -c ${prefix}_delly_out.cov.gz \\
        -o ${prefix}_delly.out.bcf  \\
        -s ${prefix}_delly.stats.gz \\
        ${bam}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        delly: \$( echo \$(delly -v) | awk 'NR==1 {print \$3}' )
        Boost: \$( echo \$(delly -v) | awk 'NR==2 {print \$3}' )
        HTSlib: \$( echo \$(delly -v) | awk 'NR==3 {print \$3}' )
    END_VERSIONS
    """
}
