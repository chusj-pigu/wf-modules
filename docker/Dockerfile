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
    bedtools \
    ca-certificates \
    gzip \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Change this to your binary name
ARG BIN_NAME=nasvar

RUN mkdir /app/nasvar/files

COPY --from=builder /app/nasvar/target/release/${BIN_NAME} /usr/local/bin/${BIN_NAME}
COPY --from=builder /app/nasvar/config /app/nasvar/config
COPY files /app/nasvar/files

