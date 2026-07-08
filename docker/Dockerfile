FROM mambaorg/micromamba:latest

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    procps wget zip git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/app

RUN micromamba create -n fgbio \
    -c bioconda -c conda-forge \
    fgbio-minimal -y \
    && micromamba clean -afy

ENV PATH="/opt/conda/envs/fgbio/bin:${PATH}"
