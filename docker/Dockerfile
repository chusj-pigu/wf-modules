FROM mambaorg/micromamba:latest

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    procps wget zip git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/app

RUN micromamba create -n wakhan_env \
    -c bioconda -c conda-forge -c defaults \
    wakhan libdeflate -y \
    && micromamba clean -afy

ENV PATH="/opt/conda/envs/wakhan_env/bin:${PATH}"