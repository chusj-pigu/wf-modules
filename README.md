[![Build and Push Docker Image](https://github.com/bwbioinfo/modules/actions/workflows/build-and-push.yml/badge.svg?query=branch%3Atemplate)](https://github.com/bwbioinfo/modules/actions/workflows/build-and-push.yml?query=branch%3Atemplate)

# module/dexseq

This repository provides:
1. A [Common Workflow Language (CWL)](https://www.commonwl.org/) tool definition for running DGE analysis in R with [DEXseq](https://bioconductor.org/packages/release/bioc/html/DEXSeq.html) and [stageR](https://bioconductor.org/packages/release/bioc/html/stageR.html). 
2. The tool Docker container definition.
3. A nextflow file with processes for the tools funcions.

Additional workflow languages will be supported ( e.g. WDL, Snakemake, etc) in the future. The aim is to provide a consistent tool definition for running bioinformatics tools across different workflow languages.

## Prerequisites

To use this tool, you must have the following software installed on your system:

-   [CWL tool](https://github.com/common-workflow-language/cwltool) or [Nextflow](https://www.nextflow.io/)
-   [Docker](https://www.docker.com/) OR [Singularity](https://sylabs.io/singularity/) OR [Apptainer](https://apptainer.org/)

## Installation

In CWL or NextFlow, you can add the tool as a submodule to your project.

```
git submodule add -b dexseq https://github.com/chusj-pigu/wf-modules modules/local/dexseq
```

## License

This project is licensed under the [MIT License](https://github.com/bwbioinfo/modkit-docker-cwl/blob/main/LICENSE).

## Contact

If you have any questions or feedback, please contact the author via GitHub.
