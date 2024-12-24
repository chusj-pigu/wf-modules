[![Build and Push Docker Image](https://github.com/bwbioinfo/modules/actions/workflows/build-and-push.yml/badge.svg?query=branch%3Aminimap2)](https://github.com/bwbioinfo/modules/actions/workflows/build-and-push.yml?query=branch%3Aminimap2)

# minimap2 Module/Template

This repository provides:
1. A [Common Workflow Language (CWL)](https://www.commonwl.org/) tool definition for running the [minimap2](https://github.com/lh3/minimap2) program. 
2. The minimap2 Docker container definition.
3. A Nextflow file with processes for the minimap2 functions.

Additional workflow languages will be supported (e.g., WDL, Snakemake, etc.) in the future. The aim is to provide a consistent tool definition for running minimap2 across different workflow languages.

## Prerequisites

To use this minimap2 module, you must have the following software installed on your system:

-   [CWL tool](https://github.com/common-workflow-language/cwltool) or [Nextflow](https://www.nextflow.io/)
-   [Docker](https://www.docker.com/) OR [Singularity](https://sylabs.io/singularity/) OR [Apptainer](https://apptainer.org/)

## Installation

In CWL or NextFlow, you can add the minimap2 tool as a submodule to your project.

```bash
git submodule add -b minimap2 https://github.com/bwbioinfo/modules modules/local/minimap2
```

## License

This project is licensed under the [MIT License](https://github.com/bwbioinfo/modkit-docker-cwl/blob/main/LICENSE).

## Contact

If you have any questions or feedback, please contact the author via GitHub.
