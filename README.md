[![Build and Push Docker Image](https://github.com/bwbioinfo/modules/actions/workflows/build-and-push.yml/badge.svg?query=branch%3Atemplate)](https://github.com/bwbioinfo/modules/actions/workflows/build-and-push.yml?query=branch%3Atemplate)

# Figeno

This repository provides:

1\. The Figeno Docker container definition.

------------------------------------------------------------------------

## Prerequisites

To use this tool, you must have the following software installed on your system:

-   [Docker](https://www.docker.com/) OR [Singularity](https://sylabs.io/singularity/) OR [Apptainer](https://apptainer.org/)

------------------------------------------------------------------------

## Installation

``` bash
docker build -t figeno:latest .
```

To run the Figeno GUI from the Docker container:

Port forwared to 5900:

``` bash
docker run -p 5900:5000 figeno-test:latest figeno gui -s --host 0.0.0.0 --port 5000 --debug 
```

Then accessible at `localhost:5900` .

You will need to bind additional directories to access your files.

------------------------------------------------------------------------

## License

This project is licensed under the [GNU GENERAL PUBLIC LICENSE](https://github.com/CompEpigen/figeno/blob/main/LICENSE).

------------------------------------------------------------------------

## Contact

If you have any questions or feedback, please contact the maintainers via the [Figeno GitHub Repository](https://github.com/CompEpigen/figeno).## CI/CD

[![Build Status](https://github.com/chusj-pigu/wf-modules/actions/workflows/build-and-push.yml/badge.svg?branch=)](https://github.com/chusj-pigu/wf-modules/actions/workflows/build-and-push.yml?query=branch%3A)

