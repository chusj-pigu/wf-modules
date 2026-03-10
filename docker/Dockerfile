# --- build stage -------------------------------------------------------------
FROM rust:1.93.1 AS builder

# Build a fully-static Linux binary (musl)
RUN rustup target add x86_64-unknown-linux-musl

# deps needed for building modkit (OpenSSL headers, musl toolchain, git)
RUN apt-get update && apt-get install -y --no-install-recommends \
    musl-tools \
    pkg-config \
    libssl-dev \
    git \
 && rm -rf /var/lib/apt/lists/*

ENV RUSTFLAGS="-C target-feature=+crt-static"
WORKDIR /opt/app

# Install from git into /usr/local/cargo/bin/
RUN cargo install \
    --locked \
    --target x86_64-unknown-linux-musl \
    --git https://github.com/nanoporetech/modkit.git \
    --rev 481e3c9e7930f3f499eadf1ef441606f33e6881c

# --- runtime stage -----------------------------------------------------------
FROM alpine:3.21 AS runtime

RUN apk add --no-cache \
    ca-certificates \
    pigz \
    bash

# Copy the modkit binary built by cargo install
COPY --from=builder /usr/local/cargo/bin/modkit /usr/local/bin/modkit

# Nice defaults
ENV PATH="/usr/local/bin:${PATH}"
ENTRYPOINT ["modkit"]
CMD ["--help"]
