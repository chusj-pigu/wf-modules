
# IchorCNA

IchorCNA has a function that requires internet access. Some small modifications have been made to allow the pre-downloading of the required files. 

### Download only mode

```
singularity run docker://ghcr/chusj-pigu/ichorcna:latest  /opt/ichorCNA/scripts/runIchorCNA.R \
  --id tumor_sample \
  --WIG /opt/ichorCNA/inst/extdata/MBC_315.ctDNA.reads.wig \
  --ploidy "c(2,3)" \
  --normal "c(0.5,0.6,0.7,0.8,0.9)" \
  --maxCN 5 \
  --gcWig /opt/ichorCNA/inst/extdata/gc_hg19_1000kb.wig \
  --mapWig /opt/ichorCNA/inst/extdata/map_hg19_1000kb.wig \
  --centromere /opt/ichorCNA/inst/extdata/GRCh37.p13_centromere_UCSC-gapTable.txt \
  --normalPanel /opt/ichorCNA/inst/extdata/HD_ULP_PoN_1Mb_median_normAutosome_mapScoreFiltered_median.rds \
  --includeHOMD False \
  --chrs "c(1:22, \"X\")" \
  --chrTrain "c(1:22)" \
  --estimateNormal True \
  --estimatePloidy True \
  --estimateScPrevalence True \
  --scStates "c(1,3)" \
  --txnE 0.9999 \
  --txnStrength 10000 \
  --genomeStyle "UCSC" \
  --downloadOnly True \  ### <--- Set to Download only
  --outDir ./
```

This will stop the script after downloading the required files.

```
Saved seqinfo to .//seqinfo.RData
Ran in download only mode - Exiting ichorCNA
```

You can then pass the files to the container and run the script again.

```
singularity run docker://ghcr/chusj-pigu/ichorcna:latest Rscript /opt/ichorCNA/scripts/runIchorCNA.R \
  --id tumor_sample \
  --WIG /opt/ichorCNA/inst/extdata/MBC_315.ctDNA.reads.wig \
  --ploidy "c(2,3)" \
  --normal "c(0.5,0.6,0.7,0.8,0.9)" \
  --maxCN 5 \
  --gcWig /opt/ichorCNA/inst/extdata/gc_hg19_1000kb.wig \
  --mapWig /opt/ichorCNA/inst/extdata/map_hg19_1000kb.wig \
  --centromere /opt/ichorCNA/inst/extdata/GRCh37.p13_centromere_UCSC-gapTable.txt \
  --normalPanel /opt/ichorCNA/inst/extdata/HD_ULP_PoN_1Mb_median_normAutosome_mapScoreFiltered_median.rds \
  --includeHOMD False \
  --chrs "c(1:22, \"X\")" \
  --chrTrain "c(1:22)" \
  --estimateNormal True \
  --estimatePloidy True \
  --estimateScPrevalence True \
  --scStates "c(1,3)" \
  --txnE 0.9999 \
  --txnStrength 10000 \
  --genomeStyle "UCSC" \
  --seqInfo /opt/seqinfo.RData \  ## <-- Pass the seqinfo file
  --outDir ./
```

**This will work best with singularity**

# Notes: HMMCopy is also available in the container

## CI/CD

[![Build Status](https://github.com/chusj-pigu/wf-modules/actions/workflows/build-and-push.yml/badge.svg?branch=)](https://github.com/chusj-pigu/wf-modules/actions/workflows/build-and-push.yml?query=branch%3A)

