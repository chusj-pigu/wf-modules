process HMMCOPY_WIG {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/ichorcna:latest'

    label "process_low"
    tag "$meta.id"

    input:
    tuple val(meta),
        path(bam),
        path(bai),
        val(window),
        val(min_mapq)

    output:
    tuple val(meta),
        path("*.wig"),
        emit: wig
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    def args = task.ext.args ?: ''
    def chr_list = params.chr_wig ?:
        'chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22,chrX,chrY'
    """
    /opt/hmmcopy_utils/bin/readCounter \\
        ${args} \\
        --window ${window} \\
        -c ${chr_list} \\
        --quality ${min_mapq} \\
        $bam > ${prefix}.wig

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        HMMcopy: "0.99.0"
    END_VERSIONS
    """
}

process ICHORCNA_DOWNLOAD {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/ichorcna:latest'

    label "local"
    label "process_single_cpu"
    label "process_very_low_memory"
    tag "$meta.id"

    input:
    tuple val(meta),
        val(genome_build),
        path(wig),
        val(purity)

    output:
    tuple val(meta),
        val(genome_build),
        path(wig),
        val(purity),
        path("seqinfo.RData"),
        emit: seq_info
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    def args = task.ext.args ?: ''
    def purity_corrected = purity.toDouble()
    def normal_prop = (1 - purity_corrected).round(2)
    def purity_low = (normal_prop - (normal_prop / 2)).round(2)
    def purity_high = (normal_prop + (normal_prop / 2)).round(2)
    def ploidy = params.custom_ploidy ?: 'c(2,3)'
    def maxCN = params.custom_maxCN ?: 5
    def bin_suffix = [10000: '10kb', 50000: '50kb', 500000: '500kb'].get(params.ichor_bin_size, '1000kb')
    def gcWig = "/opt/ichorCNA/inst/extdata/gc_${genome_build}_${bin_suffix}.wig"
    def mapWig = "/opt/ichorCNA/inst/extdata/map_${genome_build}_${bin_suffix}.wig"

    def centromere =genome_build == 'hg38'
            ? '/opt/ichorCNA/inst/extdata/GRCh38.GCA_000001405.2_centromere_acen.txt'
            : '/opt/ichorCNA/inst/extdata/GRCh37.GCA_000001405.2_centromere_acen.txt'
    def normal_panel_path = params.normal_panel ?: (
        genome_build == 'hg38'
            ? [1000000: '/opt/ichorCNA/inst/extdata/HD_ULP_PoN_hg38_1Mb_median_normAutosome_median.rds',
               500000 : '/opt/ichorCNA/inst/extdata/HD_ULP_PoN_hg38_500kb_median_normAutosome_median.rds'].get(params.ichor_bin_size)
            : [1000000: '/opt/ichorCNA/inst/extdata/HD_ULP_PoN_1Mb_median_normAutosome_mapScoreFiltered_median.rds',
               500000 : '/opt/ichorCNA/inst/extdata/HD_ULP_PoN_500kb_median_normAutosome_mapScoreFiltered_median.rds'].get(params.ichor_bin_size)
    )
    def panel = normal_panel_path == null ? "" : "--normalPanel ${normal_panel_path}"
    def chrWig = params.chr_wig ?:
        "chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22,chrX,chrY"

    def chr_name = chrWig.replaceAll(/chr/, '').split(',')

    def chrList_num = chr_name.takeWhile{ it -> it.isInteger() }.collect { it -> it.toInteger() }.toSorted()
    def chrList_non_numeric = chr_name.collect { it -> it.toUpperCase() }.contains('X') ? "X" : null

    def numericPart = ''
    if (chrList_num.size() > 0) {
        def isContiguous = (chrList_num.min()..chrList_num.max()).toList()
        numericPart = (isContiguous && chrList_num.size() > 1)
            ? "${chrList_num.min()}:${chrList_num.max()}"
            : chrList_num.join(',')
    }

    def chrtrain = numericPart
    def genome_style = params.genome_style ?: 'UCSC'
    def estimate_sc_prevalence = params.estimate_sc_prevalence ? 'True' : 'False'

    """
    Rscript /opt/ichorCNA/scripts/runIchorCNA.R \\
        --id ${prefix} \\
        --WIG ${wig} \\
        --ploidy "${ploidy}" \\
        --normal "c($purity_low,$normal_prop,$purity_high)" \\
        --maxCN ${maxCN} \\
        --gcWig ${gcWig} \\
        --mapWig ${mapWig} \\
        --centromere ${centromere} \\
        ${panel} \\
        --includeHOMD 'False' \\
        --chrs "c($numericPart, \\\"$chrList_non_numeric\\\")" \\
        --chrTrain "${chrtrain}" \\
        --genomeBuild "${genome_build}" \\
        --genomeStyle "${genome_style}" \\
        --estimateNormal 'True' \\
        --estimatePloidy 'True' \\
        --estimateScPrevalence ${estimate_sc_prevalence} \\
        --txnE 0.9999 \\
        --txnStrength 10000 \\
        ${args} \\
        --outDir ./ \\
        --downloadOnly True

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        ichorCNA: "0.2.0"
    END_VERSIONS
    """
}


process ICHORCNA {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/ichorcna:latest'

    label "process_low"
    tag "$meta.id"

    input:
    tuple val(meta),
        val(genome_build),
        path(wig),
        val(purity),
        path(seq_info)

    output:
    tuple val(meta),
        path("${meta.id}*"),
        emit: ichor_dir
    tuple val(meta),
        path("${meta.id}/*_genomeWide.pdf"),
        emit: plot
    path "versions.yml",
        emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    def args = task.ext.args ?: ''
    def purity_corrected = purity.toDouble()
    def normal_prop = (1 - purity_corrected).round(2)
    def purity_low = (normal_prop - (normal_prop / 2)).round(2)
    def purity_high = (normal_prop + (normal_prop / 2)).round(2)
    def ploidy = params.custom_ploidy ?: 'c(2,3)'
    def maxCN = params.custom_maxCN ?: 5
    def bin_suffix = [10000: '10kb', 50000: '50kb', 500000: '500kb'].get(params.ichor_bin_size, '1000kb')
    def gcWig = "/opt/ichorCNA/inst/extdata/gc_${genome_build}_${bin_suffix}.wig"
    def mapWig = "/opt/ichorCNA/inst/extdata/map_${genome_build}_${bin_suffix}.wig"

    def centromere =genome_build == 'hg38'
            ? '/opt/ichorCNA/inst/extdata/GRCh38.GCA_000001405.2_centromere_acen.txt'
            : '/opt/ichorCNA/inst/extdata/GRCh37.GCA_000001405.2_centromere_acen.txt'
    def normal_panel_path = params.normal_panel ?: (
        genome_build == 'hg38'
            ? [1000000: '/opt/ichorCNA/inst/extdata/HD_ULP_PoN_hg38_1Mb_median_normAutosome_median.rds',
               500000 : '/opt/ichorCNA/inst/extdata/HD_ULP_PoN_hg38_500kb_median_normAutosome_median.rds'].get(params.ichor_bin_size)
            : [1000000: '/opt/ichorCNA/inst/extdata/HD_ULP_PoN_1Mb_median_normAutosome_mapScoreFiltered_median.rds',
               500000 : '/opt/ichorCNA/inst/extdata/HD_ULP_PoN_500kb_median_normAutosome_mapScoreFiltered_median.rds'].get(params.ichor_bin_size)
    )
    def panel = normal_panel_path == null ? "" : "--normalPanel ${normal_panel_path}"
    def chrWig = params.chr_wig ?:
        'chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22,chrX,chrY'
    def chr_name = chrWig.replaceAll(/chr/, '').split(',')

    def chrList_num = chr_name.takeWhile{ it -> it.isInteger() }.collect { it -> it.toInteger() }.toSorted()
    def chrList_non_numeric = chr_name.collect { it -> it.toUpperCase() }.contains('X') ? "X" : null

    def numericPart = ''
    if (chrList_num.size() > 0) {
        def isContiguous = (chrList_num.min()..chrList_num.max()).toList()
        numericPart = (isContiguous && chrList_num.size() > 1)
            ? "${chrList_num.min()}:${chrList_num.max()}"
            : chrList_num.join(',')
    }

    def chrtrain = numericPart
    def genome_style = params.genome_style ?: 'UCSC'
    def estimate_sc_prevalence = params.estimate_sc_prevalence ? 'True' : 'False'

    """
    Rscript /opt/ichorCNA/scripts/runIchorCNA.R \\
        --id ${prefix} \\
        --WIG ${wig} \\
        --ploidy "${ploidy}" \\
        --normal "c($purity_low,$normal_prop,$purity_high)" \\
        --maxCN ${maxCN} \\
        --gcWig ${gcWig} \\
        --mapWig ${mapWig} \\
        --centromere ${centromere} \\
        ${panel} \\
        --includeHOMD 'False' \\
        --chrs "c($numericPart, \\\"$chrList_non_numeric\\\")" \\
        --chrTrain "${chrtrain}" \\
        --genomeBuild "${genome_build}" \\
        --genomeStyle "${genome_style}" \\
        --estimateNormal 'True' \\
        --estimatePloidy 'True' \\
        --estimateScPrevalence ${estimate_sc_prevalence} \\
        --txnE 0.9999 \\
        --txnStrength 10000 \\
        ${args} \\
        --outDir ./ \\
        --seqInfo $seq_info

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        ichorCNA: "0.2.0"
    END_VERSIONS
    """
}

