FROM ubuntu:22.04

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

ENV CONDA_DIR=/opt/conda
RUN curl -fsSL -o miniforge.sh \
      https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh && \
    bash miniforge.sh -b -p $CONDA_DIR && \
    rm miniforge.sh

ENV PATH=$CONDA_DIR/bin:$PATH

ENV MOSDEPTH_VERSION=0.3.14

# Create env with mosdepth
RUN mamba create -y -n mosenv -c conda-forge -c bioconda --override-channels mosdepth=${MOSDEPTH_VERSION} && \
    mamba clean -afy

ENV CONDA_DEFAULT_ENV=mosenv
ENV PATH=$CONDA_DIR/envs/mosenv/bin:$PATH

# Confirm it works
RUN mosdepth --version
