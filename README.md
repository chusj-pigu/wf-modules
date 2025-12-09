[![Build and Push Docker Image](https://github.com/bwbioinfo/modules/actions/workflows/build-and-push.yml/badge.svg?query=branch%3Asamtools)](https://github.com/bwbioinfo/modules/actions/workflows/build-and-push.yml?query=branch%3Asamtools)

# module/bwa-mem2

This repository provides:
1. The [bwa-mem2](https://github.com/bwa-mem2/bwa-mem2) Docker container definition.
2. A nextflow file with processes for the bwa-mem2 functions.

## Prerequisites

To use this bwa-mem2 container/module, you must have the following software installed on your system:

-   [Nextflow](https://www.nextflow.io/)
-   [Docker](https://www.docker.com/) OR [Singularity](https://sylabs.io/singularity/) OR [Apptainer](https://apptainer.org/)

## Installation

In CWL or NextFlow, you can add the bwa-mem2 module as a submodule to your project.

```
git submodule add -b bwa-mem2 https://github.com/chusj-pigu/wf-modules modules/local/bwa-mem2
```
