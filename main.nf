process SNPEFF_ANNOTATE {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/snpeff:latest"

    label 'process_high'                    // nf-core labels
    label "process_medium_high_cpu"       // Label for mpgi drac cpu alloc
    label "process_medium_memory"         // Label for mpgi drac memory alloc
    label "process_medium_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(vcf),
        val(database)

    output:
    tuple val(meta),
        path("*.vcf.gz"),
        emit: vcf
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def memory = task.memory.giga
    def threads = task.cpus
    """
    java -jar -Xmx${memory}g \\
        /opt/app/snpEff/snpEff.jar \\
        ann \\
        ${database} \\
        ${args} \\
        ${vcf} > ${prefix}_snp.vcf | pigz -p $task.cpus

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        SnpEff: \$( java -jar snpEff.jar | head -1 )
    END_VERSIONS
    """
}