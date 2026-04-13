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
        printf '\n{{< include %s >}}\n' "\${section}" >> ${prefix}_report_output/${prefix}.qmd
    done

    cd ${prefix}_report_output

    export QUARTO_CACHE_DIR="\${PWD}/.quarto_cache"
    export XDG_CACHE_HOME="\${PWD}/.cache"

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
    def chunkClasses = section == 'target_calls' ? "\n    #| classes: target-calls-wide" : ""
    def col_names_render = col_names
    if (col_names instanceof Boolean) {
        col_names_render = col_names ? 'TRUE' : 'FALSE'
    } else if (col_names instanceof String) {
        def trimmed = col_names.trim()
        if (trimmed.equalsIgnoreCase('true') || trimmed.equalsIgnoreCase('false')) {
            col_names_render = trimmed.toUpperCase()
        }
    }

    """
    mkdir ${prefix}_${section}_${process}_inputs
    cp ${table_data} ${prefix}_${section}_${process}_inputs/${table_data}

    cat <<-END_REPORT > ${prefix}_${section}_${process}_inputs/${prefix}-${section}-${process}.qmd
    \\`\\`\\`{r}
    #| label: ${prefix}-${section}-${process}${chunkClasses}
    #| tbl-cap: ${caption}
    #| echo: false
    #| tbl-cap-location: bottom
    library(vroom)
    library(knitr)
    library(kableExtra)
    data <- vroom("${table_data}", col_names = ${col_names_render}, show_col_types = FALSE)
    data |>
    head(1000) |>
    kable()
    \\`\\`\\`

END_REPORT
    # Remove template indentation so Quarto executes the R chunk instead of rendering it as literal code.
    sed -i 's/^    //' ${prefix}_${section}_${process}_inputs/${prefix}-${section}-${process}.qmd

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
    def chunkClasses = section == 'target_calls' ? "\n    #| classes: target-calls-wide" : ""

    """
    mkdir ${prefix}_${section}_${process}_inputs
    cp ${table_data} ${prefix}_${section}_${process}_inputs/${table_data}

    cat <<-END_REPORT > ${prefix}_${section}_${process}_inputs/${prefix}-${section}-${process}.qmd
    \\`\\`\\`{r}
    #| label: ${prefix}-${section}-${process}${chunkClasses}
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
    # Remove template indentation so Quarto executes the R chunk instead of rendering it as literal code.
    sed -i 's/^    //' ${prefix}_${section}_${process}_inputs/${prefix}-${section}-${process}.qmd

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
        path(section_inputs),
        val(section_description)

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

    {
        printf "# %s\n" "\${formatted_section}"
        printf "%s\n\n" "${section_description}"
    } > ${prefix}_${section}_inputs/${prefix}-${section}.qmd

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

    cat <<'END_REPORT' > ${prefix}_${section}_${process}_inputs/${prefix}-${section}-${process}.qmd
${text_data}
END_REPORT
    """
}

process QUARTO_CODE {
    container 'ghcr.io/chusj-pigu/quarto:latest'

    tag "$meta.id"
    label 'process_low'
    label 'process_single_cpu'
    label 'process_very_low_memory'
    label 'process_very_low_time'

    input:
    tuple val(meta),
        path(command_file),
        val(section),
        val(process)

    output:
    tuple val(meta),
        val(section),
        path("*_inputs"),
        emit: quarto_code
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    mkdir ${prefix}_${section}_${process}_inputs

    {
        echo '```bash'
        cat ${command_file}
        echo
        echo '```'
    } > ${prefix}_${section}_${process}_inputs/${prefix}-${section}-${process}.qmd

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        quarto: \$( quarto --version )
END_VERSIONS
    """
}

process QUARTO_TABLE_TABS {
    container 'ghcr.io/chusj-pigu/quarto:latest'
    tag "$meta.id"
    label 'process_low'
    label 'process_single_cpu'
    label 'process_very_low_memory'
    label 'process_very_low_time'

    input:
    tuple val(meta),
          val(section),
          val(process),
          path(tables),
          val(tabs),
          val(captions),
          val(colnames)

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
    def prefix       = task.ext.prefix ?: "${meta.id}"
    def input_dir    = "${prefix}_${section}_${process}_inputs"
    def table_list   = (tables   instanceof List ? tables   : [tables])
    def tab_list     = (tabs     instanceof List ? tabs     : [tabs])
    def caption_list = (captions instanceof List ? captions : [captions])
    def colname_list = (colnames instanceof List ? colnames : [colnames])

    assert (colname_list.size() == 1 || colname_list.size() == table_list.size()) : \
        "colnames must have size 1 or match tables for ${meta.id}"

    // Build setup chunk once
    def setup_chunk = [
        "```{r setup-${prefix}-${section}, include=FALSE}",
        "library(vroom)",
        "library(knitr)",
        "library(kableExtra)",
        "```"
    ].join("\n")

    // Build per-tab chunks
    def qmd_blocks = (0..<table_list.size()).collect { i ->
        def colname_value = colname_list.size() == 1 ? colname_list[0] : colname_list[i]
        def col_vector    = "c(" + colname_value.split(",").collect { '"' + it.trim() + '"' }.join(", ") + ")"
        def safe_label    = "${prefix}-${section}-${tab_list[i]}".replaceAll(/\s+/, '-')

        [
            "# ${tab_list[i]}",
            "```{r}",
            "#| label: ${safe_label}",
            "#| tbl-cap: \"${caption_list[i]}\"",
            "#| echo: false",
            "vroom(\"${table_list[i]}\", col_names = ${col_vector}, show_col_types = FALSE) |>",
            "  head(1000) |>",
            "  kable(format = \"html\", escape = FALSE) |>",
            "  kable_styling(",
            "    bootstrap_options = c(\"striped\", \"hover\", \"condensed\", \"responsive\"),",
            "    full_width = TRUE,",
            "    fixed_thead = TRUE",
            "  )",
            "```"
        ].join("\n")
    }.join("\n\n")

    def cp_commands = table_list.collect { "cp ${it} ${input_dir}/" }.join('\n')

    """
    mkdir -p ${input_dir}

    ${cp_commands}

    cat <<'END_REPORT' > ${input_dir}/${prefix}-${section}-${process}.qmd
${setup_chunk}

::: {.panel-tabset}

${qmd_blocks}

:::
END_REPORT

    cat <<'END_VERSIONS' > versions.yml
    "${task.process}":
        quarto: \$(quarto --version)
END_VERSIONS
    """
}

process QUARTO_FIGURE_TABS {
    container 'ghcr.io/chusj-pigu/quarto:latest'
    tag "$meta.id"
    label 'process_low'
    label 'process_single_cpu'
    label 'process_very_low_memory'
    label 'process_very_low_time'

    input:
    tuple val(meta),
          val(section),
          val(process),
          path(figures),
          val(tabs),
          val(captions)

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
    def prefix       = task.ext.prefix ?: "${meta.id}"
    def input_dir    = "${prefix}_${section}_${process}_inputs"
    def figure_list  = (figures  instanceof List ? figures  : [figures])
    def tab_list     = (tabs     instanceof List ? tabs     : [tabs])
    def caption_list = (captions instanceof List ? captions : [captions])

    assert tab_list.size() == figure_list.size() : \
        "tabs/figures size mismatch for ${meta.id}: ${tab_list.size()} vs ${figure_list.size()}"
    assert caption_list.size() == figure_list.size() : \
        "captions/figures size mismatch for ${meta.id}: ${caption_list.size()} vs ${figure_list.size()}"

    def qmd_blocks = (0..<figure_list.size()).collect { i ->
        def fname = figure_list[i].getName()
        [
            "# ${tab_list[i]}",
            "",
            "![${caption_list[i]}](${fname}){fig-alt=\"${caption_list[i]}\"}",
            ""
        ].join("\n")
    }.join("\n")

    def cp_commands = figure_list.collect { "cp -L ${it} ${input_dir}/" }.join('\n')

    """
    mkdir -p ${input_dir}

    ${cp_commands}

    cat <<'END_REPORT' > ${input_dir}/${prefix}-${section}-${process}.qmd

::: {.panel-tabset}

${qmd_blocks}
:::
END_REPORT

    cat <<'END_VERSIONS' > versions.yml
    "${task.process}":
        quarto: \$(quarto --version)
END_VERSIONS
    """
}
