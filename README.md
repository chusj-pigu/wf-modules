[![Build and Push Docker Image](https://github.com/bwbioinfo/modules/actions/workflows/build-and-push.yml/badge.svg?query=branch%3Asamtools)](https://github.com/bwbioinfo/modules/actions/workflows/build-and-push.yml?query=branch%3Asamtools)

# module/samtools

This repository provides:
1. A [Common Workflow Language (CWL)](https://www.commonwl.org/) tool definition for running the [samtools](https://link-to-tool) program. 
2. The samtools Docker container definition.
3. A nextflow file with processes for the samtools funcions.

Additional workflow languages will be supported ( e.g. WDL, Snakemake, etc) in the future. The aim is to provide a consistent definition for running bioinformatics tools across different workflow languages.

## Prerequisites

To use this samtools container/module, you must have the following software installed on your system:

-   [CWL tool](https://github.com/common-workflow-language/cwltool) or [Nextflow](https://www.nextflow.io/)
-   [Docker](https://www.docker.com/) OR [Singularity](https://sylabs.io/singularity/) OR [Apptainer](https://apptainer.org/)

## Installation

In CWL or NextFlow, you can add the samtools module as a submodule to your project.

```
git submodule add -b samtools https://github.com/bwbioinfo/modules modules/local/samtools
```

## License

This project is licensed under the [MIT License](https://github.com/bwbioinfo/modules/blob/samtools/LICENSE).

## Contact

If you have any questions or feedback, please contact the author via GitHub.
## CI/CD

[![Build Status](https://github.com/chusj-pigu/wf-modules/actions/workflows/build-and-push.yml/badge.svg?branch=)](https://github.com/chusj-pigu/wf-modules/actions/workflows/build-and-push.yml?query=branch%3A)

