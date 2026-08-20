FROM mambaorg/micromamba:latest

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    procps wget zip git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/app

# Install Severus's runtime dependencies only (not the bioconda 'severus' package
# itself — we want your fork's code providing the `severus` command instead)
RUN micromamba create -n severus_env \
    -c bioconda -c conda-forge -c defaults \
    "python>=3.8" "samtools>=1.14" "networkx>=2.6" pygraphviz pydot \
    matplotlib-base biopython numpy pysam plotly libdeflate pip -y \
    && micromamba clean -afy

ENV PATH="/opt/conda/envs/severus_env/bin:${PATH}"

# Clone your fork and install it into the env so `severus` resolves to your code
ARG CACHEBUST=1
RUN git clone https://github.com/charlenelawdes/Severus \
    && cd Severus \
    && pip install --no-cache-dir .

RUN severus -h