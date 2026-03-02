nextflow.enable.dsl=2

/*
 * qsv DSL2 process templates grouped by common data-wrangling functions.
 * These wrappers expose a stable I/O contract while allowing command flags
 * to be injected via `task.ext.args`.
 */

process QSV_INPUT {
    container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'
    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta), path(input_file)

    output:
    tuple val(meta), path("${meta.id}.input.csv"), emit: csv
    tuple val(meta), path("${meta.id}.input.command.txt"), emit: command
    path "versions.yml", emit: versions

    script:
    args = task.ext.args ?: ''
    """
    qsv input ${args} "${input_file}" > "${meta.id}.input.csv"

    cat <<-'END_COMMAND' > "${meta.id}.input.command.txt"
    qsv input ${args} "${input_file}" > "${meta.id}.input.csv"
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qsv: "\$(qsv --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}

process QSV_SELECT {
    container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'
    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta), path(csv)

    output:
    tuple val(meta), path("${meta.id}.select.csv"), emit: csv
    tuple val(meta), path("${meta.id}.select.command.txt"), emit: command
    path "versions.yml", emit: versions

    script:
    args = task.ext.args ?: ''
    """
    qsv select ${args} "${csv}" > "${meta.id}.select.csv"

    cat <<-'END_COMMAND' > "${meta.id}.select.command.txt"
    qsv select ${args} "${csv}" > "${meta.id}.select.csv"
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qsv: "\$(qsv --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}

process QSV_RENAME {
    container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'
    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta), path(csv)

    output:
    tuple val(meta), path("${meta.id}.rename.csv"), emit: csv
    tuple val(meta), path("${meta.id}.rename.command.txt"), emit: command
    path "versions.yml", emit: versions

    script:
    args = task.ext.args ?: ''
    """
    qsv rename ${args} "${csv}" > "${meta.id}.rename.csv"

    cat <<-'END_COMMAND' > "${meta.id}.rename.command.txt"
    qsv rename ${args} "${csv}" > "${meta.id}.rename.csv"
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qsv: "\$(qsv --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}

process QSV_SEARCH {
    container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'
    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta), path(csv)

    output:
    tuple val(meta), path("${meta.id}.search.csv"), emit: csv
    tuple val(meta), path("${meta.id}.search.command.txt"), emit: command
    path "versions.yml", emit: versions

    script:
    args = task.ext.args ?: ''
    """
    qsv search ${args} "${csv}" > "${meta.id}.search.csv"

    cat <<-'END_COMMAND' > "${meta.id}.search.command.txt"
    qsv search ${args} "${csv}" > "${meta.id}.search.csv"
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qsv: "\$(qsv --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}

process QSV_DEDUP {
    container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'
    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta), path(csv)

    output:
    tuple val(meta), path("${meta.id}.dedup.csv"), emit: csv
    tuple val(meta), path("${meta.id}.dedup.command.txt"), emit: command
    path "versions.yml", emit: versions

    script:
    args = task.ext.args ?: ''
    """
    qsv dedup ${args} "${csv}" > "${meta.id}.dedup.csv"

    cat <<-'END_COMMAND' > "${meta.id}.dedup.command.txt"
    qsv dedup ${args} "${csv}" > "${meta.id}.dedup.csv"
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qsv: "\$(qsv --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}

process QSV_SORT {
    container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'
    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta), path(csv)

    output:
    tuple val(meta), path("${meta.id}.sort.csv"), emit: csv
    tuple val(meta), path("${meta.id}.sort.command.txt"), emit: command
    path "versions.yml", emit: versions

    script:
    args = task.ext.args ?: ''
    """
    qsv sort ${args} "${csv}" > "${meta.id}.sort.csv"

    cat <<-'END_COMMAND' > "${meta.id}.sort.command.txt"
    qsv sort ${args} "${csv}" > "${meta.id}.sort.csv"
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qsv: "\$(qsv --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}

process QSV_SLICE {
    container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'
    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta), path(csv)

    output:
    tuple val(meta), path("${meta.id}.slice.csv"), emit: csv
    tuple val(meta), path("${meta.id}.slice.command.txt"), emit: command
    path "versions.yml", emit: versions

    script:
    args = task.ext.args ?: ''
    """
    qsv slice ${args} "${csv}" > "${meta.id}.slice.csv"

    cat <<-'END_COMMAND' > "${meta.id}.slice.command.txt"
    qsv slice ${args} "${csv}" > "${meta.id}.slice.csv"
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qsv: "\$(qsv --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}

process QSV_JOIN {
    container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'
    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta), path(left_csv), path(right_csv)

    output:
    tuple val(meta), path("${meta.id}.join.csv"), emit: csv
    tuple val(meta), path("${meta.id}.join.command.txt"), emit: command
    path "versions.yml", emit: versions

    script:
    args = task.ext.args ?: ''
    """
    qsv join ${args} "${left_csv}" "${right_csv}" > "${meta.id}.join.csv"

    cat <<-'END_COMMAND' > "${meta.id}.join.command.txt"
    qsv join ${args} "${left_csv}" "${right_csv}" > "${meta.id}.join.csv"
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qsv: "\$(qsv --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}

process QSV_CAT {
    container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'
    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta), path(csvs)

    output:
    tuple val(meta), path("${meta.id}.cat.csv"), emit: csv
    tuple val(meta), path("${meta.id}.cat.command.txt"), emit: command
    path "versions.yml", emit: versions

    script:
    args = task.ext.args ?: ''
    cat_inputs = (csvs instanceof List ? csvs : [csvs]).collect { csv_file -> "\"${csv_file}\"" }.join(' ')
    """
    qsv cat ${args} ${cat_inputs} > "${meta.id}.cat.csv"

    cat <<-'END_COMMAND' > "${meta.id}.cat.command.txt"
    qsv cat ${args} ${cat_inputs} > "${meta.id}.cat.csv"
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qsv: "\$(qsv --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}

process QSV_STATS {
    container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'
    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta), path(csv)

    output:
    tuple val(meta), path("${meta.id}.stats.csv"), emit: stats
    tuple val(meta), path("${meta.id}.stats.command.txt"), emit: command
    path "versions.yml", emit: versions

    script:
    args = task.ext.args ?: ''
    """
    qsv stats ${args} "${csv}" > "${meta.id}.stats.csv"

    cat <<-'END_COMMAND' > "${meta.id}.stats.command.txt"
    qsv stats ${args} "${csv}" > "${meta.id}.stats.csv"
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qsv: "\$(qsv --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}

process QSV_FREQUENCY {
    container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'
    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta), path(csv)

    output:
    tuple val(meta), path("${meta.id}.frequency.csv"), emit: frequency
    tuple val(meta), path("${meta.id}.frequency.command.txt"), emit: command
    path "versions.yml", emit: versions

    script:
    args = task.ext.args ?: ''
    """
    qsv frequency ${args} "${csv}" > "${meta.id}.frequency.csv"

    cat <<-'END_COMMAND' > "${meta.id}.frequency.command.txt"
    qsv frequency ${args} "${csv}" > "${meta.id}.frequency.csv"
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qsv: "\$(qsv --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}

process QSV_HEADERS {
    container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'
    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta), path(csv)

    output:
    tuple val(meta), path("${meta.id}.headers.txt"), emit: headers
    tuple val(meta), path("${meta.id}.headers.command.txt"), emit: command
    path "versions.yml", emit: versions

    script:
    args = task.ext.args ?: ''
    """
    qsv headers ${args} "${csv}" > "${meta.id}.headers.txt"

    cat <<-'END_COMMAND' > "${meta.id}.headers.command.txt"
    qsv headers ${args} "${csv}" > "${meta.id}.headers.txt"
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qsv: "\$(qsv --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}

process QSV_COUNT {
    container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'
    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta), path(csv)

    output:
    tuple val(meta), path("${meta.id}.count.txt"), emit: count
    tuple val(meta), path("${meta.id}.count.command.txt"), emit: command
    path "versions.yml", emit: versions

    script:
    args = task.ext.args ?: ''
    """
    qsv count ${args} "${csv}" > "${meta.id}.count.txt"

    cat <<-'END_COMMAND' > "${meta.id}.count.command.txt"
    qsv count ${args} "${csv}" > "${meta.id}.count.txt"
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qsv: "\$(qsv --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}

process QSV_TOJSONL {
    container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'
    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta), path(csv)

    output:
    tuple val(meta), path("${meta.id}.tojsonl.jsonl"), emit: jsonl
    tuple val(meta), path("${meta.id}.tojsonl.command.txt"), emit: command
    path "versions.yml", emit: versions

    script:
    args = task.ext.args ?: ''
    """
    qsv tojsonl ${args} "${csv}" > "${meta.id}.tojsonl.jsonl"

    cat <<-'END_COMMAND' > "${meta.id}.tojsonl.command.txt"
    qsv tojsonl ${args} "${csv}" > "${meta.id}.tojsonl.jsonl"
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qsv: "\$(qsv --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}

process QSV_JSONL {
    container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'
    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta), path(jsonl)

    output:
    tuple val(meta), path("${meta.id}.jsonl.csv"), emit: csv
    tuple val(meta), path("${meta.id}.jsonl.command.txt"), emit: command
    path "versions.yml", emit: versions

    script:
    args = task.ext.args ?: ''
    """
    qsv jsonl ${args} "${jsonl}" > "${meta.id}.jsonl.csv"

    cat <<-'END_COMMAND' > "${meta.id}.jsonl.command.txt"
    qsv jsonl ${args} "${jsonl}" > "${meta.id}.jsonl.csv"
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qsv: "\$(qsv --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}

process QSV_JSON {
    container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'
    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta), path(json)

    output:
    tuple val(meta), path("${meta.id}.json.csv"), emit: csv
    tuple val(meta), path("${meta.id}.json.command.txt"), emit: command
    path "versions.yml", emit: versions

    script:
    args = task.ext.args ?: ''
    """
    qsv json ${args} "${json}" > "${meta.id}.json.csv"

    cat <<-'END_COMMAND' > "${meta.id}.json.command.txt"
    qsv json ${args} "${json}" > "${meta.id}.json.csv"
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qsv: "\$(qsv --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}

process QSV_SCHEMA {
    container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'
    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta), path(csv)

    output:
    tuple val(meta), path("${meta.id}.schema.json"), emit: schema
    tuple val(meta), path("${meta.id}.schema.command.txt"), emit: command
    path "versions.yml", emit: versions

    script:
    args = task.ext.args ?: ''
    """
    qsv schema ${args} "${csv}" > "${meta.id}.schema.json"

    cat <<-'END_COMMAND' > "${meta.id}.schema.command.txt"
    qsv schema ${args} "${csv}" > "${meta.id}.schema.json"
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qsv: "\$(qsv --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}

process QSV_VALIDATE {
    container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'
    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta), path(csv)

    output:
    tuple val(meta), path("${meta.id}.validate.report.txt"), emit: report
    tuple val(meta), path("${meta.id}.validate.command.txt"), emit: command
    path "versions.yml", emit: versions

    script:
    args = task.ext.args ?: ''
    """
    qsv validate ${args} "${csv}" > "${meta.id}.validate.report.txt"

    cat <<-'END_COMMAND' > "${meta.id}.validate.command.txt"
    qsv validate ${args} "${csv}" > "${meta.id}.validate.report.txt"
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qsv: "\$(qsv --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}

process QSV_SPLIT {
    container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'
    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta), path(csv)

    output:
    tuple val(meta), path("${meta.id}.split.out"), emit: split_dir
    tuple val(meta), path("${meta.id}.split.command.txt"), emit: command
    path "versions.yml", emit: versions

    script:
    args = task.ext.args ?: ''
    """
    mkdir -p "${meta.id}.split.out"
    qsv split ${args} --output "${meta.id}.split.out" "${csv}"

    cat <<-'END_COMMAND' > "${meta.id}.split.command.txt"
    qsv split ${args} --output "${meta.id}.split.out" "${csv}"
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qsv: "\$(qsv --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}

process QSV_PARTITION {
    container 'ghcr.io/chusj-pigu/mpgi-rusttools:latest'
    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta), path(csv)

    output:
    tuple val(meta), path("${meta.id}.partition.out"), emit: partition_dir
    tuple val(meta), path("${meta.id}.partition.command.txt"), emit: command
    path "versions.yml", emit: versions

    script:
    args = task.ext.args ?: ''
    """
    mkdir -p "${meta.id}.partition.out"
    qsv partition ${args} --output "${meta.id}.partition.out" "${csv}"

    cat <<-'END_COMMAND' > "${meta.id}.partition.command.txt"
    qsv partition ${args} --output "${meta.id}.partition.out" "${csv}"
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qsv: "\$(qsv --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}
