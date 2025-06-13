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

# Install Mamba in base env
RUN conda install -y -n base -c conda-forge mamba

# Use mamba to install mosdepth in a clean env
RUN mamba create -y -n mosenv -c bioconda -c conda-forge mosdepth=0.3.10

# Activate env by default
SHELL ["/bin/bash", "--login", "-c"]
ENV CONDA_DEFAULT_ENV=mosenv
ENV PATH=$CONDA_DIR/envs/mosenv/bin:$PATH

# Confirm it works
RUN mosdepth --version

