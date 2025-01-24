FROM rust:latest

# Install dependencies
RUN apt update && apt install -y \
    procps \
    && rm -rf /var/lib/apt/lists/*

RUN cargo install gxf2bed