FROM rust:1.90

## Install Dependencies
RUN apt-get update && apt-get install -y \
    clang \
    libssl-dev \
    procps \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN cargo install rustqc

RUN rustqc -h