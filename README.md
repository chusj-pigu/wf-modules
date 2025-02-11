[![Build and Push Docker Image](https://github.com/bwbioinfo/modules/actions/workflows/build-and-push.yml/badge.svg?query=branch%3Aminimap2)](https://github.com/bwbioinfo/modules/actions/workflows/build-and-push.yml?query=branch%3Aminimap2)

# minimap2 Module/Template

This repository provides:
1. The minimap2 Docker container definition for running the [minimap2](https://github.com/lh3/minimap2) program.
2. A Nextflow file with processes for the minimap2 functions.

## Prerequisites

To use this minimap2 module, you must have the following software installed on your system:

-   [Nextflow](https://www.nextflow.io/)
-   [Docker](https://www.docker.com/) OR [Singularity](https://sylabs.io/singularity/) OR [Apptainer](https://apptainer.org/)

## Installation

In NextFlow, you can add the minimap2 tool as a submodule to your project.

```bash
git submodule add -b minimap2 https://github.com/chusj-pigu/wf-modules modules/local/minimap2
```

## License

This project is licensed under the [MIT License](https://github.com/bwbioinfo/modkit-docker-cwl/blob/main/LICENSE).

## Contact

If you have any questions or feedback, please contact the author via GitHub.
## CI/CD

[![Build Status](https://github.com/chusj-pigu/wf-modules/actions/workflows/build-and-push.yml/badge.svg?branch=)](https://github.com/chusj-pigu/wf-modules/actions/workflows/build-and-push.yml?query=branch%3A)

