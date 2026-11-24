# Adapted from the bonefish Dockerfile by Dylan Costo
#   Upstream: https://github.com/DylanCosto/bonefish/blob/v0.5.0/Dockerfile
#   Commit:   421cfca03ac82ddc2310d493eec626c64c4d9f6d (tag v0.5.0)
#   License:  MIT, see ./LICENSE (copied unchanged from upstream)
# Change: source is cloned at a pinned tag instead of `COPY . .`,
#         so the image builds outside the bonefish repo.
FROM rust:1.98-bookworm AS build
ARG BONEFISH_VERSION=v0.5.0
WORKDIR /src
RUN git clone --depth 1 --branch ${BONEFISH_VERSION} https://github.com/DylanCosto/bonefish.git . \
 && cargo build --release --locked --features jemalloc \
 && strip target/release/bonefish \
 && target/release/bonefish --version

FROM debian:bookworm-slim
RUN apt-get update \
 && apt-get install -y --no-install-recommends procps \
 && rm -rf /var/lib/apt/lists/*
COPY --from=build /src/target/release/bonefish /usr/local/bin/bonefish
COPY --from=build /src/LICENSE /src/README.md /usr/share/doc/bonefish/
LABEL org.opencontainers.image.title="bonefish" \
      org.opencontainers.image.version="0.5.0" \
      org.opencontainers.image.authors="Dylan Costo (upstream bonefish)" \
      org.opencontainers.image.source="https://github.com/DylanCosto/bonefish" \
      org.opencontainers.image.licenses="MIT"
CMD ["bonefish", "--help"]