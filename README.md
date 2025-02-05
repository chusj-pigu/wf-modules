[![Build and Push Docker Image](https://github.com/bwbioinfo/modules/actions/workflows/build-and-push.yml/badge.svg?query=branch%3Asamtools)](https://github.com/bwbioinfo/modules/actions/workflows/build-and-push.yml?query=branch%3Asamtools)

# module/samtools

This repository provides:
1. The [samtools](http://www.htslib.org/) Docker container definition.
2. A nextflow file with processes for the samtools funcions.

## Prerequisites

To use this samtools container/module, you must have the following software installed on your system:

-   [Nextflow](https://www.nextflow.io/)
-   [Docker](https://www.docker.com/) OR [Singularity](https://sylabs.io/singularity/) OR [Apptainer](https://apptainer.org/)

## Installation

In CWL or NextFlow, you can add the samtools module as a submodule to your project.

```
git submodule add -b samtools https://github.com/chusj-pigu/wf-modules modules/local/samtools
```

## License

This project is licensed under the [MIT License](https://github.com/bwbioinfo/modules/blob/samtools/LICENSE).

## Contact

If you have any questions or feedback, please contact the author via GitHub.
