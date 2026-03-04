FROM rust:1.93.1 as builder

RUN rustup target add x86_64-unknown-linux-musl

RUN apt-get update && apt-get install -y musl-tools pkg-config libssl-dev git

ENV RUSTFLAGS="-C target-feature=+crt-static"

WORKDIR /opt/app

RUN cargo install \
    --target x86_64-unknown-linux-musl \
    --git https://github.com/nanoporetech/modkit.git 