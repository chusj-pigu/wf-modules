[![Build and Push Docker Image](https://github.com/bwbioinfo/modules/actions/workflows/build-and-push.yml/badge.svg?query=branch%3Atemplate)](https://github.com/bwbioinfo/modules/actions/workflows/build-and-push.yml?query=branch%3Atemplate)

# module/deseq

This repository provides:
1. A [Common Workflow Language (CWL)](https://www.commonwl.org/) tool definition for running DGE analysis in R with [DESeq2](https://bioconductor.org/packages/release/bioc/html/DESeq2.html) and associated visualization with [pcaexplorer](https://www.bioconductor.org/packages/release/bioc/html/pcaExplorer.html) and [pheatmap](https://www.rdocumentation.org/packages/pheatmap/versions/1.0.12/topics/pheatmap). 
2. The tool Docker container definition.
3. A nextflow file with processes for the tools funcions.

## Prerequisites

To use this tool, you must have the following software installed on your system:

-   [Nextflow](https://www.nextflow.io/)
-   [Docker](https://www.docker.com/) OR [Singularity](https://sylabs.io/singularity/) OR [Apptainer](https://apptainer.org/)

## Installation

In CWL or NextFlow, you can add the tool as a submodule to your project.

```
git submodule add -b deseq https://github.com/chusj-pigu/wf-modules modules/local/deseq
```

## License

This project is licensed under the [MIT License](https://github.com/bwbioinfo/modkit-docker-cwl/blob/main/LICENSE).

## Contact

If you have any questions or feedback, please contact the author via GitHub.
## CI/CD

[![Build Status](https://github.com/chusj-pigu/wf-modules/actions/workflows/build-and-push.yml/badge.svg?branch=)](https://github.com/chusj-pigu/wf-modules/actions/workflows/build-and-push.yml?query=branch%3A)

