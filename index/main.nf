process SUBREAD_INDEX {
    label 'process_low'

    container "${['singularity','apptainer'].contains(workflow.containerEngine) && !task.ext.singularity_pull_docker_container
        ? 'https://depot.galaxyproject.org/singularity/subread:2.0.6--he4a0461_2'
        : 'biocontainers/subread:2.0.6--he4a0461_2'}"

    input:
    path genome_fasta

    output:
    path "subread_index", emit: index
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.index_prefix ?: "genome"
    """
    mkdir subread_index
    subread-buildindex -o subread_index/${prefix} ${genome_fasta}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        subread: \$( featureCounts -v 2>&1 | sed 's/featureCounts v//' | head -n 1 | tr -d '\\n' )
    END_VERSIONS
    """

    stub:
    """
    mkdir subread_index
    touch subread_index/genome.00.b.tab
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        subread: "0.0.0"
    END_VERSIONS
    """
}
