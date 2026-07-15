nextflow.enable.dsl=2

include {
    CLASSY_MARLIN
    CLASSY_MARLIN_PILEUP
    CLASSY_TUCAN
    CLASSY_TUCAN_PILEUP
    CLASSY_STURGEON_GENERAL
    CLASSY_STURGEON_GENERAL_PILEUP
    CLASSY_STURGEON_BRAINSTEM
    CLASSY_STURGEON_BRAINSTEM_PILEUP
    CLASSY_CROSSNN_CAPER
    CLASSY_CROSSNN_CAPER_PILEUP
    CLASSY_CROSSNN_PANCAN
    CLASSY_CROSSNN_PANCAN_PILEUP
    CLASSY_ALMA
    CLASSY_ALMA_PILEUP
    CLASSY_LAMPREY
    CLASSY_LAMPREY_PILEUP
    CLASSY_MPACT
    CLASSY_MPACT_PILEUP
    CLASSY_COMBINED
    CLASSY_COMBINED_PILEUP
} from '../main'

workflow {
    def meta = [id: 'smoke']

    ch_marlin = channel.of(tuple(meta, file("${projectDir}/data/sample.bam"), file("${projectDir}/data/sample.bam.bai"), 'hg38', file("${projectDir}/data/hg38.fa")))
    ch_tucan = channel.of(tuple(meta, file("${projectDir}/data/sample.bam"), file("${projectDir}/data/sample.bam.bai"), 'hg38', file("${projectDir}/data/hg38.fa")))
    ch_sturgeon_general = channel.of(tuple(meta, file("${projectDir}/data/sample.bam"), file("${projectDir}/data/sample.bam.bai"), 'hg38', file("${projectDir}/data/hg38.fa")))
    ch_sturgeon_brainstem = channel.of(tuple(meta, file("${projectDir}/data/sample.bam"), file("${projectDir}/data/sample.bam.bai"), 'hg38', file("${projectDir}/data/hg38.fa")))
    ch_crossnn_caper = channel.of(tuple(meta, file("${projectDir}/data/sample.bam"), file("${projectDir}/data/sample.bam.bai"), 'hg38', file("${projectDir}/data/hg38.fa")))
    ch_crossnn_pancan = channel.of(tuple(meta, file("${projectDir}/data/sample.bam"), file("${projectDir}/data/sample.bam.bai"), 'hg38', file("${projectDir}/data/hg38.fa")))
    ch_alma = channel.of(tuple(meta, file("${projectDir}/data/sample.bam"), file("${projectDir}/data/sample.bam.bai"), 'hg38', file("${projectDir}/data/hg38.fa")))
    ch_lamprey = channel.of(tuple(meta, file("${projectDir}/data/sample.bam"), file("${projectDir}/data/sample.bam.bai"), 'hg38', file("${projectDir}/data/hg38.fa")))
    ch_mpact = channel.of(tuple(meta, file("${projectDir}/data/sample.bam"), file("${projectDir}/data/sample.bam.bai"), 'hg38', file("${projectDir}/data/hg38.fa")))
    ch_combined = channel.of(tuple(meta, file("${projectDir}/data/sample.bam"), file("${projectDir}/data/sample.bam.bai"), 'hg38', file("${projectDir}/data/hg38.fa")))
    ch_marlin_pileup = channel.of(tuple(meta, 'hg38', file("${projectDir}/data/sample.pileup.bed")))
    ch_tucan_pileup = channel.of(tuple(meta, 'hg38', file("${projectDir}/data/sample.pileup.bed")))
    ch_sturgeon_general_pileup = channel.of(tuple(meta, 'hg38', file("${projectDir}/data/sample.pileup.bed")))
    ch_sturgeon_brainstem_pileup = channel.of(tuple(meta, 'hg38', file("${projectDir}/data/sample.pileup.bed")))
    ch_crossnn_caper_pileup = channel.of(tuple(meta, 'hg38', file("${projectDir}/data/sample.pileup.bed")))
    ch_crossnn_pancan_pileup = channel.of(tuple(meta, 'hg38', file("${projectDir}/data/sample.pileup.bed")))
    ch_alma_pileup = channel.of(tuple(meta, 'hg38', file("${projectDir}/data/sample.pileup.bed")))
    ch_lamprey_pileup = channel.of(tuple(meta, 'hg38', file("${projectDir}/data/sample.pileup.bed")))
    ch_mpact_pileup = channel.of(tuple(meta, 'hg38', file("${projectDir}/data/sample.pileup.bed")))
    ch_combined_pileup = channel.of(tuple(meta, 'hg38', file("${projectDir}/data/sample.pileup.bed")))

    CLASSY_MARLIN(ch_marlin)
    CLASSY_MARLIN_PILEUP(ch_marlin_pileup)
    CLASSY_TUCAN(ch_tucan)
    CLASSY_TUCAN_PILEUP(ch_tucan_pileup)
    CLASSY_STURGEON_GENERAL(ch_sturgeon_general)
    CLASSY_STURGEON_GENERAL_PILEUP(ch_sturgeon_general_pileup)
    CLASSY_STURGEON_BRAINSTEM(ch_sturgeon_brainstem)
    CLASSY_STURGEON_BRAINSTEM_PILEUP(ch_sturgeon_brainstem_pileup)
    CLASSY_CROSSNN_CAPER(ch_crossnn_caper)
    CLASSY_CROSSNN_CAPER_PILEUP(ch_crossnn_caper_pileup)
    CLASSY_CROSSNN_PANCAN(ch_crossnn_pancan)
    CLASSY_CROSSNN_PANCAN_PILEUP(ch_crossnn_pancan_pileup)
    CLASSY_ALMA(ch_alma)
    CLASSY_ALMA_PILEUP(ch_alma_pileup)
    CLASSY_LAMPREY(ch_lamprey)
    CLASSY_LAMPREY_PILEUP(ch_lamprey_pileup)
    CLASSY_MPACT(ch_mpact)
    CLASSY_MPACT_PILEUP(ch_mpact_pileup)
    CLASSY_COMBINED(ch_combined)
    CLASSY_COMBINED_PILEUP(ch_combined_pileup)
}
