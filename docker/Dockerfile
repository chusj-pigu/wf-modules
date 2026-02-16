FROM ubuntu:22.04

# Basic system deps
RUN apt-get update && apt-get install -y \
    curl \
    bzip2 \
    ca-certificates \
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    libxrender1 \
    bash \
    procps \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Miniconda
ENV CONDA_DIR=/opt/conda
RUN curl -fsSL -o miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash miniconda.sh -b -p $CONDA_DIR && \
    rm miniconda.sh

ENV PATH=$CONDA_DIR/bin:$PATH

RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

# Install Mamba in base env
RUN conda install -y -n base -c conda-forge mamba

# Use mamba to install cuteSV and its dependecies in a clean env
RUN mamba create -y -n bam2gff -c bioconda -c conda-forge \
    spliced_bam2gff \
    && conda clean -afy

# Activate env by default
SHELL ["/bin/bash", "--login", "-c"]
ENV CONDA_DEFAULT_ENV=bam2gff
ENV PATH=$CONDA_DIR/envs/bam2gff/bin:$PATH

WORKDIR /opt/app