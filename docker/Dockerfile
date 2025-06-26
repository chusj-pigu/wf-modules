FROM rust:latest


RUN apt-get update && apt-get install -y \
    build-essential \
    pkg-config \
    libssl-dev \
    libclang-dev \
    llvm-dev \
    clang \
    cmake \
    curl \
    git \
    procps \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN cargo install perbase

# Cleanup

RUN apt-get clean && rm -rf /var/lib/apt/lists/*