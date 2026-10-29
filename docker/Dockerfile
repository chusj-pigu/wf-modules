# syntax=docker/dockerfile:1.7

############################
# Builder stage
############################
FROM rust:1.95-slim-trixie AS builder

WORKDIR /app

# Install build dependencies.
# Add extra libs here if your crate needs them, e.g. libssl-dev, pkg-config, clang.
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    pkg-config \
    ca-certificates \
    build-essential \
    clang \
    make \
    cmake \
    perl \
    autoconf \
    automake \
    libtool \
    && rm -rf /var/lib/apt/lists/*


RUN git clone https://github.com/jwanglab/nasvar
WORKDIR /app/nasvar
RUN cargo build --release

############################
# Runtime stage
############################
FROM debian:trixie-slim AS runtime

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    gzip \
    procps \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Change this to your binary name
ARG BIN_NAME=nasvar

COPY --from=builder /app/nasvar/target/release/${BIN_NAME} /usr/local/bin/${BIN_NAME}
COPY --from=builder /app/nasvar/config /app/nasvar/config
COPY files /app/nasvar/files

## Get gff files
RUN cd /app/nasvar/files && \
    wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/009/914/755/GCF_009914755.1_T2T-CHM13v2.0/GCF_009914755.1_T2T-CHM13v2.0_genomic.gff.gz && \
    wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.40_GRCh38.p14/GCF_000001405.40_GRCh38.p14_genomic.gff.gz
