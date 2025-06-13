FROM bioconda/bioconda-utils-build-env:latest

WORKDIR /opt/app

# Install dependencies for building AUR packages
RUN conda install bioconda::mosdepth

RUN mosdepth --help