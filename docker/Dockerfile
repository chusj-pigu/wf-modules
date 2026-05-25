FROM mambaorg/micromamba:latest

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    procps wget zip \
    && rm -rf /var/lib/apt/lists/*

RUN micromamba create -n severus_env \
    -c bioconda -c conda-forge -c defaults \
    severus libdeflate -y \
    && micromamba clean -afy

ENV PATH="/opt/conda/envs/severus_env/bin:${PATH}"

RUN severus -h

ENTRYPOINT ["severus"]