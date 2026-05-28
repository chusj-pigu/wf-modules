FROM mambaorg/micromamba:latest

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    procps wget zip git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/app

RUN micromamba create -n severus_env \
    -c bioconda -c conda-forge -c defaults \
    severus libdeflate -y \
    && micromamba clean -afy

ENV PATH="/opt/conda/envs/severus_env/bin:${PATH}"

RUN git clone https://github.com/KolmogorovLab/Severus

RUN severus -h