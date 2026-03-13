nextflow.enable.dsl=2

def QSV_CONTAINER = 'ghcr.io/chusj-pigu/qsv:a43cec04792d678c68285545c952a93f4857a751'

/*
 * qsv DSL2 process templates grouped by common data-wrangling functions.
 * These wrappers expose a stable I/O contract while allowing command flags
 * to be injected via `task.ext.args`.
 */

process QSV_INPUT {
    container QSV_CONTAINER
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
    export QSV_SKIP_FORMAT_CHECK=1
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
    container QSV_CONTAINER
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
    export QSV_SKIP_FORMAT_CHECK=1
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
    container QSV_CONTAINER
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
    export QSV_SKIP_FORMAT_CHECK=1
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
    container QSV_CONTAINER
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
    export QSV_SKIP_FORMAT_CHECK=1
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
    container QSV_CONTAINER
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
    export QSV_SKIP_FORMAT_CHECK=1
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
    container QSV_CONTAINER
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
    export QSV_SKIP_FORMAT_CHECK=1
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
    container QSV_CONTAINER
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
    export QSV_SKIP_FORMAT_CHECK=1
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
    container QSV_CONTAINER
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
    export QSV_SKIP_FORMAT_CHECK=1
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
    container QSV_CONTAINER
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
    export QSV_SKIP_FORMAT_CHECK=1
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
    container QSV_CONTAINER
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
    export QSV_SKIP_FORMAT_CHECK=1
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
    container QSV_CONTAINER
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
    export QSV_SKIP_FORMAT_CHECK=1
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
    container QSV_CONTAINER
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
    export QSV_SKIP_FORMAT_CHECK=1
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
    container QSV_CONTAINER
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
    export QSV_SKIP_FORMAT_CHECK=1
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
    container QSV_CONTAINER
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
    export QSV_SKIP_FORMAT_CHECK=1
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
    container QSV_CONTAINER
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
    export QSV_SKIP_FORMAT_CHECK=1
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
    container QSV_CONTAINER
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
    export QSV_SKIP_FORMAT_CHECK=1
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
    container QSV_CONTAINER
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
    export QSV_SKIP_FORMAT_CHECK=1
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
    container QSV_CONTAINER
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
    export QSV_SKIP_FORMAT_CHECK=1
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
    container QSV_CONTAINER
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
    #!/usr/bin/env sh
    export QSV_SKIP_FORMAT_CHECK=1
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
    container QSV_CONTAINER
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
    export QSV_SKIP_FORMAT_CHECK=1
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

process QSV_SQLP {
    container QSV_CONTAINER
    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta), path(inputs, stageAs: 'sqlp_input?.csv'), path(sql)

    output:
    tuple val(meta), path("${meta.id}.sqlp.csv"), emit: csv
    tuple val(meta), path("${meta.id}.sqlp.command.txt"), emit: command
    path "versions.yml", emit: versions

    script:
    args = task.ext.args ?: ''
    sqlp_inputs = (inputs instanceof List ? inputs : [inputs]).collect { csv_file -> "\"${csv_file}\"" }.join(' ')
    """
    #!/usr/bin/env sh
    export QSV_SKIP_FORMAT_CHECK=1
    qsv sqlp ${args} ${sqlp_inputs} "${sql}" > "${meta.id}.sqlp.csv"

    cat <<-'END_COMMAND' > "${meta.id}.sqlp.command.txt"
    qsv sqlp ${args} ${sqlp_inputs} "${sql}" > "${meta.id}.sqlp.csv"
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qsv: "\$(qsv --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}

process QSV_SLIM_FEATURES {
    container QSV_CONTAINER
    label 'process_low'

    input:
    path(features_bed)

    output:
    path("*.slim.bed"), emit: slim_bed
    path("*.slim_features.command.txt"), emit: command
    path "versions.yml", emit: versions

    script:
    def prefix = features_bed.simpleName
    """
    export QSV_SKIP_FORMAT_CHECK=1
    case "${features_bed}" in
        *.gz|*.bgz|*.bgzf)
            zcat "${features_bed}" > "${prefix}.input.tsv"
            ;;
        *)
            cat "${features_bed}" > "${prefix}.input.tsv"
            ;;
    esac

    TAB="\$(printf '\\t')"
    qsv select --no-headers -d "\${TAB}" 1,2,3,4 "${prefix}.input.tsv" | qsv fmt -t T > "${prefix}.slim.bed"

    cat <<-'END_COMMAND' > "${prefix}.slim_features.command.txt"
    TAB="\$(printf '\t')"
    qsv select --no-headers -d "\${TAB}" 1,2,3,4 "${prefix}.input.tsv" | qsv fmt -t T > "${prefix}.slim.bed"
    END_COMMAND

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qsv: "\$(qsv --version 2>&1 | head -n 1)"
    END_VERSIONS
    """
}

process QSV_COMBINE_TABLES {
    container QSV_CONTAINER
    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta),
        path(gene_mods, stageAs: 'gene_mods_in.csv'),
        path(comparison, stageAs: 'comparison_in.csv'),
        path(gene_mods_summary, stageAs: 'gene_mods_summary_in.tsv')
    path(genes_tsv, stageAs: 'genes_tsv_in.tsv')
    path(sql_script)

    output:
    tuple val(meta), path("${meta.id}-final-summary.csv"), emit: csv
    path "versions.yml", emit: versions

    script:
    """
    export QSV_SKIP_FORMAT_CHECK=1
    # Ensure non-empty CSVs with expected headers so qsv sqlp can always parse inputs.
    if [ ! -s "${comparison}" ]; then
        printf '%s\n' 'Gene,Chromosome,Strand,Intronic,Non-Intronic' > comparison.csv
    else
        cp "${comparison}" comparison.csv
    fi

    if [ ! -s "${gene_mods}" ]; then
        printf '%s\n' 'Gene,chrom,Total A,Gene Start,Gene Stop,Min Read Length,Max Read Length,Mean Read Length,Low >=0.25,High >=0.75,Med >=0.50,V Low / Unmodified <0.25' > gene_mods.csv
    else
        cp "${gene_mods}" gene_mods.csv
    fi

    # Normalize per-feature TSV header and delimiter for SQL joins.
    qsv fmt -d '\t' "${gene_mods_summary}" > gene_mods_summary.csv
    qsv rename "chrom,start,end,name,strand,count_a,count_valid_a,percent_a" gene_mods_summary.csv > per_feature.csv

    qsv sqlp --streaming --low-memory \
        per_feature.csv gene_mods.csv comparison.csv \
        "${sql_script}" \
        > "${meta.id}-final-summary.csv"

    QSV_VERSION=\$(qsv --version 2>&1 | head -n 1 | sed 's/"/\\"/g')
    printf '"%s":\n    qsv: "%s"\n' "${task.process}" "\${QSV_VERSION}" > versions.yml
    """
}
