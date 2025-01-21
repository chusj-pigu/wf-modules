FROM rust:latest

## Install Dependencies
RUN apt-get update && apt-get install -y \
    libssl-dev \
    pkg-config \
    pigz \
    && rm -rf /var/lib/apt/lists/* \
    git

WORKDIR /opt

RUN cargo install --git https://github.com/nanoporetech/modkit.git