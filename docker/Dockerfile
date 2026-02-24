# Build stage (pinned, Alpine-based to match runtime libc)
FROM rust:1.93.1-alpine3.21 AS build

# Needed for building many Rust crates with native deps
RUN apk add --no-cache build-base musl-dev

# Planned deterministic installs when crates are available
ARG GENEMANCER_VERSION=0.2.1
# ARG TRANCISTOR_VERSION=0.0.0
# ARG NANOCOV_VERSION=0.0.0
RUN cargo install --locked --version ${GENEMANCER_VERSION} genemancer
# RUN cargo install --locked --version ${TRANCISTOR_VERSION} trancistor
# RUN cargo install --locked --version ${NANOCOV_VERSION} nanocov

# Runtime stage (pinned, same distro family)
FROM alpine:3.21
RUN apk add --no-cache bash libgcc libstdc++

# Install binaries built in previous stage
COPY --from=build /usr/local/cargo/bin/ /usr/local/bin/

WORKDIR /root/
ENV PATH="/usr/local/bin:${PATH}"

CMD ["/bin/sh"]
