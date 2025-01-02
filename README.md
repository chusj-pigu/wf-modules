[![Build and Push Docker Image](https://github.com/bwbioinfo/modules/actions/workflows/build-and-push.yml/badge.svg?query=branch%3Apychopper)](https://github.com/bwbioinfo/modules/actions/workflows/build-and-push.yml?query=branch%3Apychopper)

# module/pychopper

This repository provides:
1. A [Common Workflow Language (CWL)](https://www.commonwl.org/) pychopper definition for running the [pychopper](https://github.com/epi2me-labs/pychopper) program. 
2. The pychopper Docker container definition.
3. A nextflow file with processes for the pychoppers funcions.

Additional workflow languages will be supported ( e.g. WDL, Snakemake, etc) in the future. The aim is to provide a consistent pychopper definition for running bioinformatics pychoppers across different workflow languages.

## Prerequisites

To use this tool, you must have the following software installed on your system:

-   [CWL tool](https://github.com/common-workflow-language/cwltool) or [Nextflow](https://www.nextflow.io/)
-   [Docker](https://www.docker.com/) OR [Singularity](https://sylabs.io/singularity/) OR [Apptainer](https://apptainer.org/)

## Installation

In CWL or NextFlow, you can add the pychopper as a submodule to your project.

```
git submodule add -b pychopper https://github.com/chusj-pugu/wf-modules modules/local/pychopper
```

## License

This project is licensed under the [MIT License](https://github.com/bwbioinfo/modkit-docker-cwl/blob/main/LICENSE).

## Contact

If you have any questions or feedback, please contact the author via GitHub.
