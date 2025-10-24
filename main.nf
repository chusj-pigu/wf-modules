process CONVERT_PDF_PNG {
    container "ghcr.io/chusj-pigu/magick:latest" // TO DO: SET CONTAINER TO FIXED VERSION

    tag "$meta.id"
    label 'process_single'
    label 'local'

    input:
    tuple val(meta),
        path(pdf)

    output:
    tuple val(meta),
        path("*.png"),
        emit: png
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: '-density 300 -define png:compression-filter=Flate'
    def prefix = task.ext.prefix ?: "${pdf}.baseName"
    """
    convert \\
        ${args} \\
        ${pdf} \\
        ${prefix}.png

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        ImageMagick: \$(convert --version | awk '/ImageMagick/ {print \$3}')
    END_VERSIONS
    """
}
