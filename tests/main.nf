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
} from '../main'

workflow {
    def meta = [id: 'smoke']

    ch_marlin = Channel.of(
        tuple(
            meta,
            file("${projectDir}/data/sample.bam"),
            file("${projectDir}/data/sample.bam.bai"),
            file("${projectDir}/data/hg38.fa")
        )
    )
    ch_tucan = Channel.of(tuple(meta, file("${projectDir}/data/sample.bam"), file("${projectDir}/data/sample.bam.bai"), file("${projectDir}/data/hg38.fa")))
    ch_marlin_pileup = Channel.of(tuple(meta, file("${projectDir}/data/sample.pileup.bed")))
    ch_tucan_pileup = Channel.of(tuple(meta, file("${projectDir}/data/sample.pileup.bed")))
    ch_sturgeon_general = Channel.of(tuple(meta, file("${projectDir}/data/sample.bam"), file("${projectDir}/data/sample.bam.bai"), file("${projectDir}/data/hg38.fa")))
    ch_sturgeon_general_pileup = Channel.of(tuple(meta, file("${projectDir}/data/sample.pileup.bed")))
    ch_sturgeon_brainstem = Channel.of(tuple(meta, file("${projectDir}/data/sample.bam"), file("${projectDir}/data/sample.bam.bai"), file("${projectDir}/data/hg38.fa")))
    ch_sturgeon_brainstem_pileup = Channel.of(tuple(meta, file("${projectDir}/data/sample.pileup.bed")))
    ch_crossnn_caper = Channel.of(tuple(meta, file("${projectDir}/data/sample.bam"), file("${projectDir}/data/sample.bam.bai"), file("${projectDir}/data/hg38.fa")))
    ch_crossnn_caper_pileup = Channel.of(tuple(meta, file("${projectDir}/data/sample.pileup.bed")))
    ch_crossnn_pancan = Channel.of(tuple(meta, file("${projectDir}/data/sample.bam"), file("${projectDir}/data/sample.bam.bai"), file("${projectDir}/data/hg38.fa")))
    ch_crossnn_pancan_pileup = Channel.of(tuple(meta, file("${projectDir}/data/sample.pileup.bed")))

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
}
