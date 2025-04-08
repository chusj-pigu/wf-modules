process SNPEFF_ANNOTATE {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/snpeff:latest"

    label 'process_low'                    // nf-core labels
    label "process_single_cpu"       // Label for mpgi drac cpu alloc
    label "process_medium_mid_memory"         // Label for mpgi drac memory alloc
    label "process_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(vcf),
        val(database)

    output:
    tuple val(meta),
        path("*.vcf"),
        emit: vcf
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def memory = task.memory.giga
    //def threads = task.cpus
    """
    java -jar -Xmx${memory}g \\
        /opt/app/snpEff/snpEff.jar \\
        ann \\
        ${args} \\
        ${database} \\
        ${vcf} > ${prefix}.vcf

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        SnpEff: "5.2f"
    END_VERSIONS
    """
}

process SNPSIFT_ANNOTATE {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/snpeff:latest"

    label 'process_low'                    // nf-core labels
    label "process_single_cpu"              // Label for mpgi drac cpu alloc
    label "process_low_memory"         // Label for mpgi drac memory alloc
    label "process_very_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(vcf),
        path(database),
        path(database_tbi)

    output:
    tuple val(meta),
        path("*.vcf"),
        emit: vcf
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def memory = task.memory.giga
    //def threads = task.cpus
    """
    java -jar -Xmx${memory}g \\
        /opt/app/snpEff/SnpSift.jar \\
        ann \\
        ${args} \\
        ${database} \\
        ${vcf} > ${prefix}_clinvar.vcf

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        SnpSift: "5.2f"
    END_VERSIONS
    """
}
