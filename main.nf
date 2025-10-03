process COUNT_BY_BIOTYPE {

    //TODO: SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/deseq:latest'
    label 'local'
    label 'process_single_cpu'
    label 'process_very_low_memory'

    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(ref),
        path(annotation),
        path(rds)

    output:
    tuple val(meta),
        path("*transcripts.csv"),
        emit: transcripts
    tuple val(meta),
        path("*genes.csv"),
        emit: genes
    tuple val(meta),
        path("*length.csv"),
        emit: full_length
    path "versions.yml",
        emit: versions

    script:
    """
    count_by_biotype.R \\
        -r ${ref} \\
        --bambu ${rds} \\
        -a ${annotation}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        R: \$(R --version | head -1)
        bambu: "\$(echo 'cat(as.character(packageVersion(\"bambu\")))' | R --vanilla --slave)"
        dplyr: "\$(echo 'cat(as.character(packageVersion(\"dplyr\")))' | R --vanilla --slave)"
        readr: "\$(echo 'cat(as.character(packageVersion(\"readr\")))' | R --vanilla --slave)"
        tibble: "\$(echo 'cat(as.character(packageVersion(\"tibble\")))' | R --vanilla --slave)"
        tidyr: "\$(echo 'cat(as.character(packageVersion(\"tidyr\")))' | R --vanilla --slave)"

    END_VERSIONS
    """
}

process CREATE_ANNOTATION {

    //TODO: SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/deseq:latest'
    label 'local'
    label 'process_single_cpu'
    label 'process_very_low_memory'

    tag "$meta.id"

    input:
    tuple val(meta),
        path(gtf),
        val(organism)

    output:
    tuple val(meta),
        path("*.csv"),
        path("*.rds"),
        emit: anno
    path "versions.yml",
        emit: versions

    script:
    """
    create_annotation.R \\
        -g ${gtf} \\
        -o "${organism}"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        R: \$(R --version | head -1)
        AnnotationDbi: "\$(echo 'cat(as.character(packageVersion(\"AnnotationDbi\")))' | R --vanilla --slave)"
        bambu: "\$(echo 'cat(as.character(packageVersion(\"bambu\")))' | R --vanilla --slave)"
        dplyr: "\$(echo 'cat(as.character(packageVersion(\"dplyr\")))' | R --vanilla --slave)"
        optparse: "\$(echo 'cat(as.character(packageVersion(\"optparse\")))' | R --vanilla --slave)"
        RMariaDB: "\$(echo 'cat(as.character(packageVersion(\"RMariaDB\")))' | R --vanilla --slave)"
        txdbmaker: "\$(echo 'cat(as.character(packageVersion(\"txdbmaker\")))' | R --vanilla --slave)"

    END_VERSIONS
    """
}