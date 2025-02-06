process HMMCOPY_WIG {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/ichorcna:latest'

    label "process_low"
    tag "$meta.id"

    input:
    tuple val(meta), path(bam), path(bai)

    output:
    tuple val(meta), path("${meta}.wig"), emit: wig
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    def args = task.ext.args ?: ''
    def chr_list = params.chr_wig
    def window = params.window_wig
    def min_mapq = params.minmapq_wig
    """
    /opt/hmmcopy_utils/bin/readCounter \\
        ${args} \\
        --window ${window} \\
        -c ${chr_list} \\
        --quality ${min_mapq} \\
        $bam > ${prefix}.wig

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        HMMcopy: "0.99.0"    END_VERSIONS
    """
}

process ICHORCNA_DOWNLOAD {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/ichorcna:latest'

    label "process_low"
    tag "$meta.id"

    input:
    tuple val(meta), path(wig), val(purity), path(seq_info)

    output:
    tuple val(meta), path(wig), val(purity), path("seqinfo.RData"), emit: seq_info
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    def args = task.ext.args ?: ''
    def normal_prop = (1 - purity).round(2)
    def purity_low = (normal_prop - (normal_prop / 2)).round(2)
    def purity_high = (normal_prop + (normal_prop / 2)).round(2)
    def ploidy = params.custom_ploidy
    def maxCN = params.custom_maxCN
    def gcWig = params.custom_gcWig
    def mapWig = params.custom_mapWig
    def centromere = params.custom_centromere
    def panel = params.normal_panel
    def homd = params.homd
    def chrs = params.chrs
    def chrtrain = params.chr_train
    def genome_build = params.genome_build
    def genome_style = params.genome_style
    def estimate_normal = params.estimate_normal
    def estimate_ploidy = params.estimate_ploidy
    def estimate_sc_prevalence = params.estimate_sc_prevalence
    def txne = params.txnE
    def txn_strength = params.txn_strength

    """
    Rscript /opt/ichorCNA/scripts/runIchorCNA.R \\
        --id ${prefix} \\
        --WIG ${wig} \\
        --ploidy ${ploidy} \\
        --normal "c($purity_low,$normal_prop,$purity_high)" \\
        --maxCN ${maxCN} \\
        --gcWig ${gcWig} \\
        --mapWig ${mapWig} \\
        --centromere ${centromere} \\
        --normalPanel ${panel} \\
        --includeHOMD ${homd} \\
        --chrs ${chrs} \\
        --chrTrain ${chrtrain} \\
        --genomeBuild ${genome_build} \\
        --genomeStyle ${genome_style} \\
        --estimateNormal ${estimate_normal} \\
        --estimatePloidy ${estimate_ploidy} \\
        --estimateScPrevalence ${estimate_sc_prevalence} \\
        --txnE ${txne} \\
        --txnStrength ${txn_strength} \\
        ${args} \\
        --outDir ./ \\
        --downloadOnly True

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        ichorCNA: "0.2.0"    END_VERSIONS
    """
}


process ICHORCNA {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/chusj-pigu/ichorcna:latest'

    label "process_low"
    tag "$meta.id"

    input:
    tuple val(meta), path(wig), val(purity), path(seq_info)

    output:
    tuple val(meta), path("${meta}"), emit: ichor_dir
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    def args = task.ext.args ?: ''
    def normal_prop = (1 - purity).round(2)
    def purity_low = (normal_prop - (normal_prop / 2)).round(2)
    def purity_high = (normal_prop + (normal_prop / 2)).round(2)
    def ploidy = params.custom_ploidy ?: "c(2,3)"
    def maxCN = params.custom_maxCN ?: "5"
    def gcWig = params.custom_gcWig ?: "/opt/ichorCNA/inst/extdata/gc_${ref}_1000kb.wig"
    def mapWig = params.custom_mapWig ?: "/opt/ichorCNA/inst/extdata/map_${ref}_1000kb.wig"
    def centromere = params.custom_centromere ?: "/opt/ichorCNA/inst/extdata/GRCh38.GCA_000001405.2_centromere_acen.txt"
    def panel = params.normal_panel ?: "/opt/ichorCNA/inst/extdata/HD_ULP_PoN_hg38_1Mb_median_normAutosome_median.rds"
    def homd = params.homd ?: "False"
    def chrs = params.chrs ?: "c(1:22, \\\"X\\\")"
    def chrtrain = params.chr_train ?: "c(1:22)"
    def genome_build = params.genome_build ?: "hg38"
    def genome_style = params.genome_style ?: "UCSC"
    def estimate_normal = params.estimate_normal ?: True
    def estimate_ploidy = params.estimate_ploidy ?: True
    def estimate_sc_prevalence = params.estimate_sc_prevalence ?: False
    def txne = params.txnE ?: 0.9999
    def txn_strength = params.txn_strength ?: 10000

    """
    Rscript /opt/ichorCNA/scripts/runIchorCNA.R \\
        --id ${prefix} \\
        --WIG ${wig} \\
        --ploidy ${ploidy} \\
        --normal "c($purity_low,$normal_prop,$purity_high)" \\
        --maxCN ${maxCN} \\
        --gcWig ${gcWig} \\
        --mapWig ${mapWig} \\
        --centromere ${centromere} \\
        --normalPanel ${panel} \\
        --includeHOMD ${homd} \\
        --chrs ${chrs} \\
        --chrTrain ${chrtrain} \\
        --genomeBuild ${genome_build} \\
        --genomeStyle ${genome_style} \\
        --estimateNormal ${estimate_normal} \\
        --estimatePloidy ${estimate_ploidy} \\
        --estimateScPrevalence ${estimate_sc_prevalence} \\
        --txnE ${txne} \\
        --txnStrength ${txn_strength} \\
        ${args} \\
        --outDir ./ \\
        --seqInfo $seq_info

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        ichorCNA: "0.2.0"    END_VERSIONS
    """
}
