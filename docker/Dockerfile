FROM rust:latest

## Install Dependencies
RUN apt-get update && apt-get install -y \
    libssl-dev \
    procps \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN cargo install oarfish

RUN oarfish -h