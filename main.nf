process COUNT_BY_BIOTYPE {

    //TODO: SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/deseq:latest'
    label 'local'
    label 'process_single_cpu'
    label 'process_very_low_memory'

    tag "$meta.id"

    input:
    tuple val(meta),
        path(quant),
        val(organism)

    output:
    tuple val(meta),
        path("*.csv"),
        emit: table
    path "versions.yml",
        emit: versions

    script:
    """
    count_by_biotype.R \\
        -o "${organism}"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        R: \$(R --version | head -1)
        AnnotationDbi: "\$(echo 'cat(as.character(packageVersion(\"AnnotationDbi\")))' | R --vanilla --slave)"
        data.table: "\$(echo 'cat(as.character(packageVersion(\"data.table\")))' | R --vanilla --slave)"
        optparse: "\$(echo 'cat(as.character(packageVersion(\"optparse\")))' | R --vanilla --slave)"
        RMariaDB: "\$(echo 'cat(as.character(packageVersion(\"RMariaDB\")))' | R --vanilla --slave)"
        tidyverse: "\$(echo 'cat(as.character(packageVersion(\"tidyverse\")))' | R --vanilla --slave)"
        txdbmaker: "\$(echo 'cat(as.character(packageVersion(\"txdbmaker\")))' | R --vanilla --slave)"

    END_VERSIONS
    """
}
