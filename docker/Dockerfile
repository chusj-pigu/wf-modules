FROM continuumio/miniconda3

# Set a working directory
WORKDIR /opt/app

# Create a conda environment and install dependencies
RUN conda create -n sniffles python=3.10.15 && \
    conda run -n sniffles pip install \
    pysam>=0.21.0 \
    edlib>=1.3.9 \
    psutil>=5.9.4 \
    sniffles

# Activate the conda environment
SHELL ["/bin/bash", "-c"]
RUN echo "conda activate sniffles" >> ~/.bashrc
ENV PATH /opt/conda/envs/sniffles/bin:$PATH