process QUARTO_REPORT {
    container 'ghcr.io/chusj-pigu/quarto:latest'

    tag "$meta.id"
    label 'process_low'
    label 'process_single_cpu'
    label 'process_low_memory'
    label 'process_very_low_time'

    input:
    tuple val(meta),
        val(section),
        path(report_inputs),
        val(report_section),
        val(report_title),
        val(report_description),
        path(report_template)

    output:
    tuple val(meta),
        path("*_report_output"),
        emit: report
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: '--to html --log-level debug'
    def prefix = task.ext.prefix ?: "${meta.id}"
    def report_section_split = report_section.collect { it }.join(" ")
    """
    mkdir ${prefix}_report_output

    for file in ${report_inputs}; do
        cp -r \${file}/* ${prefix}_report_output/
    done

    cat ${report_template} >> ${prefix}_report_output/${prefix}.qmd
    echo "${report_section_split}"
    for section in ${report_section_split}; do
        echo "section: \${section}"
        echo "{{< include \${section} >}}" >> ${prefix}_report_output/${prefix}.qmd
    done

    cd ${prefix}_report_output

    quarto render ${prefix}.qmd --no-cache ${args} \
    -P report_title:"${report_title}" \
    -P report_description:"${report_description}" \
    --output ${prefix}.html

    cd ..

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        quarto: \$( quarto --version )
    END_VERSIONS
    """

    stub:
    """
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        quarto: \$( quarto --version )
    END_VERSIONS
    """
}

process QUARTO_TABLE {
    container 'ghcr.io/chusj-pigu/quarto:latest'

    tag "$meta.id"
    label 'process_low'
    label 'process_single_cpu'
    label 'process_very_low_memory'
    label 'process_very_low_time'

    input:
    tuple val(meta),
        path(table_data),
        val(caption),
        val(col_names),
        val(section),
        val(process)

    output:
    tuple val(meta),
        val(section),
        path("*_inputs"),
        emit: quarto_table
    path "versions.yml",
        emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"

    """
    mkdir ${prefix}_${section}_${process}_inputs
    cp ${table_data} ${prefix}_${section}_${process}_inputs/${table_data}

    cat <<-END_REPORT > ${prefix}_${section}_${process}_inputs/${prefix}-${section}-${process}.qmd
    \\`\\`\\`{r}
    #| label: ${prefix}-${section}-${process}
    #| tbl-cap: ${caption}
    #| echo: false
    #| tbl-cap-location: bottom
    library(vroom)
    library(knitr)
    library(kableExtra)
    data <- vroom("${table_data}", col_names = ${col_names}, show_col_types = FALSE)
    data |>
    head(1000) |>
    kable()
    \\`\\`\\`

    END_REPORT

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        quarto: \$( quarto --version )
    END_VERSIONS
    """
}

process QUARTO_TABLE_COLNAMES {
    container 'ghcr.io/chusj-pigu/quarto:latest'

    tag "$meta.id"
    label 'process_low'
    label 'process_single_cpu'
    label 'process_very_low_memory'
    label 'process_very_low_time'

    input:
    tuple val(meta),
        path(table_data),
        val(caption),
        val(col_names),
        val(section),
        val(process)

    output:
    tuple val(meta),
        val(section),
        path("*_inputs"),
        emit: quarto_table
    path "versions.yml",
        emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"

    """
    mkdir ${prefix}_${section}_${process}_inputs
    cp ${table_data} ${prefix}_${section}_${process}_inputs/${table_data}

    cat <<-END_REPORT > ${prefix}_${section}_${process}_inputs/${prefix}-${section}-${process}.qmd
    \\`\\`\\`{r}
    #| label: ${prefix}-${section}-${process}
    #| tbl-cap: ${caption}
    #| echo: false
    #| tbl-cap-location: bottom
    library(vroom)
    library(knitr)
    library(kableExtra)
    data <- vroom("${table_data}", col_names = trimws(strsplit("${col_names}", ",")[[1]]), show_col_types = FALSE)
    data |>
    head(1000) |>
    kable()
    \\`\\`\\`

    END_REPORT

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        quarto: \$( quarto --version )
    END_VERSIONS
    """
}

process QUARTO_FIGURE {
    container 'ghcr.io/chusj-pigu/quarto:latest'

    tag "$meta.id"
    label 'process_low'
    label 'process_single_cpu'
    label 'process_very_low_memory'
    label 'process_very_low_time'

    input:
    tuple val(meta),
        path(figure_data),
        val(caption),
        val(section),
        val(process)

    output:
    tuple val(meta),
        val(section),
        path("*_inputs"),
        emit: quarto_figure
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"

    """
    mkdir ${prefix}_${section}_${process}_inputs
    cp ${figure_data} ${prefix}_${section}_${process}_inputs/${figure_data}

    cat <<-END_REPORT > ${prefix}_${section}_${process}_inputs/${prefix}-${section}-${process}.qmd
    ![${caption}](${figure_data})

    END_REPORT

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        quarto: \$( quarto --version )
    END_VERSIONS
    """
}


process QUARTO_SECTION {
    container 'ghcr.io/chusj-pigu/quarto:latest'

    tag "$meta.id"
    label 'process_low'
    label 'process_single_cpu'
    label 'process_very_low_memory'
    label 'process_very_low_time'

    input:
    tuple val(meta),
        val(section),
        path(section_inputs)
    val section_description

    output:
    tuple val(meta),
        val(section),
        path("*_inputs"),
        val("${meta.id}-${section}.qmd"),
        emit: quarto_section
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"

    """

    mkdir ${prefix}_${section}_inputs


    for file in ${section_inputs}; do
        cp -r \${file}/* ${prefix}_${section}_inputs
    done

    # Transform: uppercase and replace underscores with spaces
    formatted_section=\$(echo "${section}" | tr '_' ' ' | tr '[:lower:]' '[:upper:]')

    cat <<-END_REPORT > ${prefix}_${section}_inputs/${prefix}-${section}.qmd
    # \${formatted_section}
    ${section_description}

    END_REPORT

    for file in ${section_inputs}; do
        cat \${file}/*.qmd >> ${prefix}_${section}_inputs/${prefix}-${section}.qmd
    done

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        quarto: \$( quarto --version )
    END_VERSIONS
    """
}


process QUARTO_TEXT {
    container 'ghcr.io/chusj-pigu/quarto:latest'

    tag "$meta.id"
    label 'process_low'
    label 'process_single_cpu'
    label 'process_very_low_memory'
    label 'process_very_low_time'

    input:
    tuple val(meta),
        val(text_data),
        val(section),
        val(process)

    output:
    tuple val(meta),
        val(section),
        path("*_inputs"),
        emit: quarto_text

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"

    """
    mkdir ${prefix}_${section}_${process}_inputs

    cat <<-END_REPORT > ${prefix}_${section}_${process}_inputs/${prefix}-${section}-${process}.qmd
    ${text_data}

    END_REPORT
    """
}
