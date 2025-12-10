# syntax=docker/dockerfile:1

ARG BASE_IMAGE=debian:bookworm-slim
ARG BWA_MEM2_URL=https://github.com/bwa-mem2/bwa-mem2/releases/download/v2.3/bwa-mem2-2.3_x64-linux.tar.bz2

FROM ${BASE_IMAGE} AS fetch
ARG BWA_MEM2_URL

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    bzip2 \
    wget && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN wget -q "${BWA_MEM2_URL}" -O /tmp/bwa-mem2.tar.bz2 && \
    tar -xjf /tmp/bwa-mem2.tar.bz2 -C /opt && \
    rm /tmp/bwa-mem2.tar.bz2

FROM ${BASE_IMAGE}

LABEL description="bwa-mem2 latest"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    zlib1g \
    libgomp1 \
    tabix && \
    rm -rf /var/lib/apt/lists/*

COPY --from=fetch /opt/bwa-mem2-2.3_x64-linux/bwa-mem2* /usr/local/bin/

WORKDIR /data

CMD ["bwa-mem2"]
