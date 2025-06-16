FROM ubuntu:22.04

# System dependencies
RUN apt-get update && apt-get install -y \
    curl \
    bzip2 \
    ca-certificates \
    bash \
    git \
    procps \
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    libxrender1 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Miniconda
ENV CONDA_DIR=/opt/conda
RUN curl -fsSL -o miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash miniconda.sh -b -p $CONDA_DIR && \
    rm miniconda.sh

ENV PATH=$CONDA_DIR/bin:$PATH

# Install Mamba (better dependency resolution)
RUN conda install -y -n base -c conda-forge mamba

# Create environment with straglr dependencies
COPY environment.yaml /opt/environment.yaml
RUN mamba env create -n straglr -f /opt/environment.yaml && conda clean -a -y

# Set shell to activate the env
SHELL ["/bin/bash", "--login", "-c"]
ENV CONDA_DEFAULT_ENV=straglr
ENV PATH=$CONDA_DIR/envs/straglr/bin:$PATH

WORKDIR /opt/app

RUN git clone https://github.com/bcgsc/straglr

WORKDIR /opt/app/straglr



