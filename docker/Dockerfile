# Build stage (glibc-based to match Ubuntu runtime)
FROM rust:1.93.1-slim-bullseye AS build

ENV DEBIAN_FRONTEND=noninteractive
ENV RUSTFLAGS="-C strip=symbols"

# Needed for building Rust crates with native deps.
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    pkg-config \
    binutils \
    libfontconfig1-dev \
    libfreetype6-dev \
    libexpat1-dev \
    libpng-dev \
    zlib1g-dev \
    libbrotli-dev \
    libbz2-dev \
    ca-certificates \
    git \
    && rm -rf /var/lib/apt/lists/*

# Planned deterministic installs when crates are available
ARG GENEMANCER_VERSION=0.2.5
# ARG TRANCISTOR_VERSION=0.0.0
ARG NANOCOV_VERSION=0.1.0
RUN cargo install --locked --version ${GENEMANCER_VERSION} --features cuda genemancer
# RUN cargo install --locked --version ${TRANCISTOR_VERSION} trancistor
RUN cargo install --locked --version ${NANOCOV_VERSION} nanocov
RUN strip /usr/local/cargo/bin/genemancer /usr/local/cargo/bin/nanocov || true

# Runtime stage (minimal CUDA runtime on Ubuntu 22.04)
FROM nvidia/cuda:12.8.0-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libstdc++6 \
    libfontconfig1 \
    libfreetype6 \
    libexpat1 \
    libpng16-16 \
    zlib1g \
    libbrotli1 \
    libbz2-1.0 \
    && rm -rf /var/lib/apt/lists/*

# Install binaries built in previous stage
COPY --from=build /usr/local/cargo/bin/genemancer /usr/local/bin/genemancer
COPY --from=build /usr/local/cargo/bin/nanocov /usr/local/bin/nanocov

ENV PATH="/usr/local/bin:${PATH}"

CMD ["genemancer", "--help"]
