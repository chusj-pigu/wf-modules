
# IchorCNA

Test within container :

```
Rscript /opt/ichorCNA/scripts/runIchorCNA.R --id tumor_sample \
  --WIG /opt/ichorCNA/inst/extdata/gc_hg38_1000kb.wig --ploidy "c(2,3)" --normal "c(0.5,0.6,0.7,0.8,0.9)" --maxCN 5 \
  --gcWig /opt/ichorCNA/inst/extdata/gc_hg38_1000kb.wig \
  --mapWig /opt/ichorCNA/inst/extdata/map_hg38_1000kb.wig \
  --centromere /opt/ichorCNA/inst/extdata/GRCh38.GCA_000001405.2_centromere_acen.txt \
  --normalPanel /opt/ichorCNA/inst/extdata/HD_ULP_PoN_hg38_1Mb_median_normAutosome_median.rds \
  --includeHOMD False --chrs "c(1:22, \"X\")" --chrTrain "c(1:22)" \
  --estimateNormal True --estimatePloidy True --estimateScPrevalence True \
  --scStates "c(1,3)" --txnE 0.9999 --txnStrength 10000 --outDir ./
```

**This will work best with singularity**

# Notes: HMMCopy is also available in the container

## CI/CD

[![Build Status](https://github.com/chusj-pigu/wf-modules/actions/workflows/build-and-push.yml/badge.svg?branch=)](https://github.com/chusj-pigu/wf-modules/actions/workflows/build-and-push.yml?query=branch%3A)

