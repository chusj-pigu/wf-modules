process CREATE_ANNOTATION {

    //TODO: SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/deseq:latest'
    label 'local'
    label 'process_single_cpu'
    label 'process_very_low_memory'

    tag "$meta.id"

    input:
    tuple val(meta),
        path(gtf)

    output:
    tuple val(meta),
        path("*df.csv"),
        emit: anno
    tuple val(meta),
        path("*gene.csv"),
        emit: gene_anno
    path "versions.yml",
        emit: versions

    script:
    """
    create_annotation.R \\
        -g ${gtf}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        R: \$(R --version | head -1)
        rtracklayer: "\$(echo 'cat(as.character(packageVersion(\"AnnotationDbi\")))' | R --vanilla --slave)"
        dplyr: "\$(echo 'cat(as.character(packageVersion(\"dplyr\")))' | R --vanilla --slave)"
        optparse: "\$(echo 'cat(as.character(packageVersion(\"optparse\")))' | R --vanilla --slave)"

    END_VERSIONS
    """
}
