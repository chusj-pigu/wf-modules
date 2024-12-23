[![Build and Push Docker Image](https://github.com/bwbioinfo/modules/actions/workflows/build-and-push.yml/badge.svg?query=branch%3Amodkit)](https://github.com/bwbioinfo/modkit/actions/workflows/build-and-push.yml?query=branch%3Amodkit)

# modkit-docker-cwl

This repository provides a [Common Workflow Language (CWL)](https://www.commonwl.org/) tool for running the [modkit](https://github.com/biswajyotim/modkit) program. The tool is packaged in a Docker container, allowing it to run on any system with Docker or Singularity installed.

## Prerequisites

To use this tool, you must have the following software installed on your system:

-   [CWL tool](https://github.com/common-workflow-language/cwltool)
-   [Docker](https://www.docker.com/) OR [Singularity](https://sylabs.io/singularity/) OR [Apptainer](https://apptainer.org/)

## Installation

To install and run the tool, follow these steps:

1.  Clone this repository to your local machine.

2.  Install Docker, if you haven't already done so.

3.  (Optional) Build the Docker image by running the following command from the root of the repository:

    ``` bash
    docker build -f docker/Dockerfile -t modkit-docker-cwl .
    ```

    OR pull the pre-built container: `bash  docker pull ghcr.io/bwbioinfo/modkit-docker-cwl:latest` Note: This is only needed if you wish to access the container commands directly via Docker.

4.  Run the CWL tool by executing the following command from the root of the repository:

    ``` bash
    cwl-runner modkit-tool.cwl modkit-inputs.yml
    ```

    OR, if using Singularity: `bash  cwl-runner --singularity modkit-tool.cwl modkit-inputs.yml`

    This will run the `modkit` software on the input files specified in the `modkit-inputs.yml` file.

## Usage

To use the tool, you will need to create a YAML file specifying the input files and any other parameters required. An example YAML file is provided in the `example` directory of this repository.

-   The `modkit-tool.cwl` file describes the steps of the `modkit` analysis workflow.
-   The `modkit-inputs.yml` file is an example input file specifying the input data and configurable options.
-   The `modkit-tool.cwl` file includes the Docker specification. Alternatively, you can use [Singularity](https://sylabs.io/singularity/) via the CWL runner option `--singularity`.

The output of the analysis will be written to a directory named `output` in the current working directory.

## Contributing

If you wish to contribute to this project, please follow the standard GitHub workflow:

1.  Fork the repository.
2.  Create a new branch for your changes.
3.  Make your changes and commit them.
4.  Push your changes to your fork.
5.  Submit a pull request to this repository.

## License

This project is licensed under the [MIT License](https://github.com/bwbioinfo/modkit-docker-cwl/blob/main/LICENSE).

## Contact

If you have any questions or feedback, please contact the author via GitHub.