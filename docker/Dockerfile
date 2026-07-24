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
    wget \
    procps \
    gzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app/stellerator
RUN cargo install Stellerator

# Copy genes gtf into the container
WORKDIR /opt/data
RUN wget https://hgdownload.gi.ucsc.edu/goldenPath/hg38/bigZips/genes/hg38.ncbiRefSeq.gtf.gz && \
    gzip -dc hg38.ncbiRefSeq.gtf.gz  | grep -v 'alt' | grep -v 'fix' > hg38.ncbiRefSeq.gtf && \
    rm hg38.ncbiRefSeq.gtf.gz 
RUN wget https://hgdownload.soe.ucsc.edu/goldenPath/hg19/bigZips/genes/hg19.ncbiRefSeq.gtf.gz && \
    gzip -d hg19.ncbiRefSeq.gtf.gz
RUN wget https://hgdownload.soe.ucsc.edu/goldenPath/hs1/bigZips/genes/hs1.ncbiRefSeq.gtf.gz && \
    gzip -d hs1.ncbiRefSeq.gtf.gz
