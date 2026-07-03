FROM mambaorg/micromamba:latest

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    procps wget zip git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/app

RUN micromamba create -n cutadapt \
    -c bioconda -c conda-forge \
    cutadapt -y \
    && micromamba clean -afy

ENV PATH="/opt/conda/envs/cutadapt/bin:${PATH}"