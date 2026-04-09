nextflow.enable.dsl=2

include {
    CLASSY_MARLIN
    CLASSY_TUCAN
    CLASSY_STURGEON_GENERAL
    CLASSY_STURGEON_BRAINSTEM
    CLASSY_CROSSNN_CAPER
    CLASSY_CROSSNN_PANCAN
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
    ch_sturgeon_general = Channel.of(tuple(meta, file("${projectDir}/data/sample.bam"), file("${projectDir}/data/sample.bam.bai"), file("${projectDir}/data/hg38.fa")))
    ch_sturgeon_brainstem = Channel.of(tuple(meta, file("${projectDir}/data/sample.bam"), file("${projectDir}/data/sample.bam.bai"), file("${projectDir}/data/hg38.fa")))
    ch_crossnn_caper = Channel.of(tuple(meta, file("${projectDir}/data/sample.bam"), file("${projectDir}/data/sample.bam.bai"), file("${projectDir}/data/hg38.fa")))
    ch_crossnn_pancan = Channel.of(tuple(meta, file("${projectDir}/data/sample.bam"), file("${projectDir}/data/sample.bam.bai"), file("${projectDir}/data/hg38.fa")))

    CLASSY_MARLIN(ch_marlin)
    CLASSY_TUCAN(ch_tucan)
    CLASSY_STURGEON_GENERAL(ch_sturgeon_general)
    CLASSY_STURGEON_BRAINSTEM(ch_sturgeon_brainstem)
    CLASSY_CROSSNN_CAPER(ch_crossnn_caper)
    CLASSY_CROSSNN_PANCAN(ch_crossnn_pancan)
}
