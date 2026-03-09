# --- build stage -------------------------------------------------------------
FROM rust:alpine AS builder

# Build dependencies
RUN apk add --no-cache \
    musl-dev \
    bash

# Create a dummy workdir to keep things tidy
WORKDIR /build

# Install the Rust binary
RUN cargo install --locked --root /opt/gxf2bed gxf2bed

# --- runtime stage -----------------------------------------------------------
FROM alpine:latest AS runtime

# Runtime utilities
RUN apk add --no-cache \
    bash \
    procps

# Copy the compiled binary from the builder image
COPY --from=builder /opt/gxf2bed/bin/gxf2bed /usr/local/bin/gxf2bed

# Default shell
SHELL ["/bin/bash", "-lc"]

ENTRYPOINT ["gxf2bed"]
CMD ["--help"]
