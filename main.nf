process BCFTOOLS_CONCAT {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/bcftools:latest"

    label 'process_low'                    // nf-core labels
    label "process_low_cpu"       // Label for mpgi drac cpu alloc
    label "process_medium_mid_memory"         // Label for mpgi drac memory alloc
    label "process_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(vcf1),
        path(vcf1_index),
        path(vcf2),
        path(vcf2_index)

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
    def threads = task.cpus
    """
    bcftools concat \\
        --threads ${threads} \\
        ${args} \\
        ${vcf1} \\
        ${vcf2} > ${prefix}.vcf

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bcftools: "\$(bcftools --version 2>&1 | awk '/bcftools/ {b=\$2} /htslib/ {h=\$3} END {printf \"bcftools %s, htslib %s\", b, h}')"
    END_VERSIONS
    """
}

process BCFTOOLS_SORT {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/bcftools:latest"

    label 'process_low'                    // nf-core labels
    label "process_low_cpu"       // Label for mpgi drac cpu alloc
    label "process_medium_mid_memory"         // Label for mpgi drac memory alloc
    label "process_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(vcf)

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
    """
    bcftools sort \\
        ${args} \\
        ${vcf} > ${prefix}_sorted.vcf

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bcftools: "\$(bcftools --version 2>&1 | awk '/bcftools/ {b=\$2} /htslib/ {h=\$3} END {printf \"bcftools %s, htslib %s\", b, h}')"
    END_VERSIONS
    """
}

process BCFTOOLS_INDEX {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/bcftools:latest"

    label 'process_low'                    // nf-core labels
    label "process_low_cpu"       // Label for mpgi drac cpu alloc
    label "process_low_memory"         // Label for mpgi drac memory alloc
    label "process_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(vcf)

    output:
    tuple val(meta),
        path(vcf),
        path("*.tbi"),
        emit: vcf_tbi
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    //def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    bcftools \\
        index \\
        -tf \\
        ${args} \\
        --threads ${threads} \\
        ${vcf} \\
        -o ${vcf}.tbi

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bcftools: "\$(bcftools --version 2>&1 | awk '/bcftools/ {b=\$2} /htslib/ {h=\$3} END {printf \"bcftools %s, htslib %s\", b, h}')"
    END_VERSIONS
    """
}

process BCFTOOLS_VIEW {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/bcftools:latest"

    label 'process_low'                    // nf-core labels
    label "process_low_cpu"       // Label for mpgi drac cpu alloc
    label "process_low_memory"         // Label for mpgi drac memory alloc
    label "process_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(vcf)

    output:
    tuple val(meta),
        path("*.{vcf,vcf.gz,bcf,bcf.gz}"),
        emit: vcf
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: '-Ov'
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    def extension = args.contains("--output-type b") || args.contains("-Ob")
        ? "bcf.gz"
        : args.contains("--output-type u") || args.contains("-Ou")
            ? "bcf"
            : args.contains("--output-type z") || args.contains("-Oz")
                ? "vcf.gz"
                : args.contains("--output-type v") || args.contains("-Ov")
                    ? "vcf"
                    : "vcf"
    """
    bcftools view \\
        ${args} \\
        --threads ${threads} \\
        ${vcf} \\
        -o ${prefix}.${extension}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bcftools: \$( echo \$(bcftools --version 2>&1) | sed 's/^.*bcftools //; s/Using.*\$//' )
    END_VERSIONS
    """
}

process BCFTOOLS_MPILEUP {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/bcftools:latest"

    label 'process_low'                    // nf-core labels
    label "process_medium_low_cpu"       // Label for mpgi drac cpu alloc
    label "process_medium_low_memory"         // Label for mpgi drac memory alloc
    label "process_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bam_bai),
        path(ref),
        path(ref_fai)

    output:
    tuple val(meta),
        path("*.bcf"),
        emit: bcf
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: '-Oz'
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    bcftools mpileup \\
        ${args} \\
        --threads ${threads} \\
        -f ${ref} \\
        ${bam} \\
        -o ${prefix}.bcf

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bcftools: \$( echo \$(bcftools --version 2>&1) | sed 's/^.*bcftools //; s/Using.*\$//' )
    END_VERSIONS
    """
}


process BCFTOOLS_CALL {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/bcftools:latest"

    label 'process_low'                    // nf-core labels
    label "process_medium_low_cpu"       // Label for mpgi drac cpu alloc
    label "process_medium_low_memory"
    label "process_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bcf)

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
    def threads = task.cpus
    """
    bcftools call \\
        ${args} \\
        --threads ${threads} \\
        ${bcf} \\
        -o ${prefix}_snp.vcf.gz

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bcftools: \$( echo \$(bcftools --version 2>&1) | sed 's/^.*bcftools //; s/Using.*\$//' )
    END_VERSIONS
    """
}

process BCFTOOLS_FILTER {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/bcftools:latest"

    label 'process_low'                    // nf-core labels
    label "process_medium_low_cpu"       // Label for mpgi drac cpu alloc
    label "process_medium_low_memory"
    label "process_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(sv_vcf),
        path(sv_vcf_idx)

    output:
    tuple val(meta),
        path("*.vcf"),
        emit: filt_vcf
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: "-i 'FORMAT/DV > 4'"
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    bcftools view \\
        ${args} \\
        --threads ${threads} \\
        ${sv_vcf} > ${prefix}_filt.vcf

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bcftools: \$( echo \$(bcftools --version 2>&1) | sed 's/^.*bcftools //; s/Using.*\$//' )
    END_VERSIONS
    """
}

process BCFTOOLS_FILTER_ID {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/bcftools:latest"

    label 'process_low'                    // nf-core labels
    label "process_medium_low_cpu"       // Label for mpgi drac cpu alloc
    label "process_medium_low_memory"
    label "process_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(sv_vcf),
        path(sv_vcf_idx),
        path(id_file)

    output:
    tuple val(meta),
        path("*.vcf"),
        emit: filt_vcf
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    bcftools view \\
        -i "ID=@${id_file}" \\
        ${args} \\
        --threads ${threads} \\
        ${sv_vcf} > ${prefix}_filt_hm.vcf

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bcftools: \$( echo \$(bcftools --version 2>&1) | sed 's/^.*bcftools //; s/Using.*\$//' )
    END_VERSIONS
    """
}

process BCFTOOLS_FILTER_REGION {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/bcftools:latest"

    label 'process_low'                    // nf-core labels
    label "process_medium_low_cpu"       // Label for mpgi drac cpu alloc
    label "process_medium_low_memory"
    label "process_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(vcf),
        path(tbi),
        path(bed)

    output:
    tuple val(meta),
        path("*.vcf.gz"),
        emit: filt_vcf
    tuple val(meta),
        path("*.vcf.gz.tbi"),
        emit: index,
        optional:true
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    bcftools filter \\
        --output ${prefix}_filt_hm.vcf.gz \\
        -R ${bed} \\
        ${args} \\
        --threads ${threads} \\
        ${vcf}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bcftools: \$( echo \$(bcftools --version 2>&1) | sed 's/^.*bcftools //; s/Using.*\$//' )
    END_VERSIONS
    """
}

process BCFTOOLS_QUERY {
    // TODO SET CONTAINER TO FIXED VERSION

    container "ghcr.io/chusj-pigu/bcftools:latest"

    label 'process_low'                    // nf-core labels
    label "process_single_cpu"       // Label for mpgi drac cpu alloc
    label "process_low_memory"
    label "process_very_low_time"

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bcf)

    output:
    tuple val(meta),
        path("*red.bed"),
        emit: bed
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: "-f '%CHROM\\t%POS\\t%INFO/END\\t%ID[\\t%RDCN]\\n'"
    def prefix = task.ext.prefix ?: "${meta.id}"
    def threads = task.cpus
    """
    bcftools query \\
        ${args} \\
        ${bcf} > ${prefix}_red.bed

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bcftools: "\$(bcftools --version 2>&1 | awk '/bcftools/ {b=\$2} /htslib/ {h=\$3} END {printf \"bcftools %s, htslib %s\", b, h}')"
    END_VERSIONS
    """
}

process BGZIP_RECOMPRESS {

    container "ghcr.io/chusj-pigu/bcftools:latest"
    label "process_low"                     // nf-core labels
    label "process_low_cpu"              // Label for mpgi drac memory alloc
    label "process_low_memory"           // Label for mpgi drac memory alloc
    label "process_low_time"            // Label for mpgi drac time alloc

    tag "${meta.id}"

    input:
    tuple val(meta),
        path(fasta)

    output:
    tuple val(meta),
        path("*.fa.gz"),
        emit: file
    path "versions.yml",
        emit: versions

    script:
    def prefix = "${fasta.simpleName}"
    def output = "${prefix}_genome.fa.gz"
    def unzip  = fasta.extension.contains('gz') ? "zcat ${fasta} | " : ''
    """
    ${unzip}bgzip -c > ${output}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bgzip: "\$(bgzip --version 2>&1 | head -1 | awk '{print \$NF}')"
    END_VERSIONS
    """
}
