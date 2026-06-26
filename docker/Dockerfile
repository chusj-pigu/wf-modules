FROM rust:1.95-slim-trixie AS builder
WORKDIR /app
# Install build dependencies.
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    pkg-config \
    ca-certificates \
    build-essential \
    clang \
    make \
    cmake \
    autoconf \
    automake \
    libtool \
    && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/chusj-pigu/stellerator
WORKDIR /app/stellerator
RUN cargo build --release

# Final stage - smaller image
FROM debian:trixie-slim
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    procps \
    gzip \
    && rm -rf /var/lib/apt/lists/*

# Copy the binary from builder
COPY --from=builder /app/stellerator/target/release/stellerator /usr/local/bin/stellerator
RUN chmod +x /usr/local/bin/stellerator

# Copy genes gtf into the container
WORKDIR /opt/data
RUN wget https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/genes/hg38.refGene.gtf.gz && \
    gzip -dc hg38.refGene.gtf.gz | grep -v 'alt' | grep -v 'fix' > hg38.refGene.gtf && \
    rm hg38.refGene.gtf.gz
RUN wget https://hgdownload.soe.ucsc.edu/goldenPath/hg19/bigZips/genes/hg19.refGene.gtf.gz && \
    gzip -d hg19.refGene.gtf.gz
RUN wget https://hgdownload.soe.ucsc.edu/goldenPath/hs1/bigZips/genes/hs1.ncbiRefSeq.gtf.gz && \
    gzip -d hs1.ncbiRefSeq.gtf.gz
