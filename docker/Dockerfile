FROM python:3.11-slim-bookworm

# Runtime + build deps.
# - samtools (bookworm ships 1.16, Severus needs >=1.14)
# - graphviz + libgraphviz-dev + build-essential: pygraphviz has no wheels and must compile
# - procps: needed by Nextflow for task metrics
RUN apt-get update && apt-get install -y --no-install-recommends \
        procps \
        git \
        samtools \
        graphviz \
        libgraphviz-dev \
        build-essential \
        pkg-config \
    && pip install --no-cache-dir \
        "networkx>=2.6" \
        pygraphviz \
        pydot \
        matplotlib \
        biopython \
        numpy \
        pysam \
        plotly \
    && apt-get purge -y --auto-remove build-essential pkg-config libgraphviz-dev \
    && rm -rf /var/lib/apt/lists/*

# Install the Severus via personnal fork (resolved the negative length SV)
ARG SEVERUS_REF=main
RUN git clone https://github.com/charlenelawdes/Severus /opt/Severus \
    && cd /opt/Severus \
    && git checkout "${SEVERUS_REF}" \
    && pip install --no-cache-dir . \
    && rm -rf /opt/Severus

# Ensure compatibility with apptainer for non-root use
RUN chmod -R a+rX /usr/local
ENV MPLCONFIGDIR=/tmp/matplotlib \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1
