process SUBREAD_ALIGN {
    tag "${meta.id}"
    label 'process_medium'

    container "${['singularity','apptainer'].contains(workflow.containerEngine) && !task.ext.singularity_pull_docker_container
        ? 'https://depot.galaxyproject.org/singularity/subread:2.0.6--he4a0461_2'
        : 'biocontainers/subread:2.0.6--he4a0461_2'}"

    input:
    tuple val(meta), path(reads)
    path index_dir

    output:
    tuple val(meta), path("${task.ext.prefix ?: meta.id}.bam"), emit: bam
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def exp_type = 0
    if (meta.strandedness == 'forward') {
        exp_type = 1
    } else if (meta.strandedness == 'reverse') {
        exp_type = 1
    }
    def exp_opt = (args =~ /(^|\\s)-t\\s/) ? '' : "-t ${exp_type}"
    def prefix = task.ext.prefix ?: "${meta.id}"
    def index_prefix_name = task.ext.index_prefix ?: "genome"
    def index_prefix = "${index_dir}/${index_prefix_name}"
    def reads1 = []
    def reads2 = []
    meta.single_end ? [reads].flatten().each { r -> reads1 << r } : reads.eachWithIndex { v, ix -> (ix & 1 ? reads2 : reads1) << v }
    def read_args = meta.single_end ? "-r ${reads1.join(',')}" : "-r ${reads1.join(',')} -R ${reads2.join(',')}"

    """
    subread-align \\
        -i ${index_prefix} \\
        ${read_args} \\
        -T ${task.cpus} \\
        ${exp_opt} \\
        ${args} \\
        -o ${prefix}.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        subread: \$( featureCounts -v 2>&1 | sed 's/featureCounts v//' | head -n 1 | tr -d '\\n' )
    END_VERSIONS
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch ${prefix}.bam
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        subread: "0.0.0"
    END_VERSIONS
    """
}
