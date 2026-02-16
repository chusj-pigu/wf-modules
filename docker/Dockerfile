FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV CONDA_DIR=/opt/conda

# Basic system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    procps \
    build-essential \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN curl -fsSL -o miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash miniconda.sh -b -p $CONDA_DIR && \
    rm miniconda.sh

ENV PATH=$CONDA_DIR/bin:$PATH

RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

# Update conda and enable faster solver
RUN conda update -n base -c defaults conda -y && \
    conda install -n base -c conda-forge mamba -y

# Install SQANTI3
WORKDIR /opt/app
RUN wget https://github.com/ConesaLab/SQANTI3/releases/download/v5.5.4/SQANTI3_v5.5.4.zip && \
    unzip SQANTI3_v5.5.4.zip -d sqanti3 && \
    rm SQANTI3_v5.5.4.zip

# Create squanti3 environment
RUN mamba env create -f sqanti3/SQANTI3.conda_env.yml && \
    conda clean -afy

# Make squanti3 default environment
SHELL ["/bin/bash", "--login", "-c"]
ENV CONDA_DEFAULT_ENV=sqanti3
ENV PATH=$CONDA_DIR/envs/sqanti3/bin:$PATH

WORKDIR /opt/app/sqanti3
