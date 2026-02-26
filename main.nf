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