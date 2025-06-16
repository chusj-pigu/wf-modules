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
RUN mamba create -y -n straglr-env -c bioconda -c conda-forge \
    python=3.8.13 \
    pysam>=0.14.0 \
    pybedtools>=0.9.0 \
    numpy>=1.22.3 \
    pathos>=0.2.3 \
    scikit-learn>=1.1 \
    scipy>=1.8.0 \
    trf=4.09.1 \
    blast=2.5.0 && \
    conda clean -afy

WORKDIR /opt/app
RUN git clone https://github.com/bcgsc/straglr.git && \
    chmod +x /opt/app/straglr/straglr.py && \
    ln -s /opt/app/straglr/straglr.py /usr/local/bin/straglr

ENV PATH=$CONDA_DIR/envs/straglr-env/bin:$PATH




