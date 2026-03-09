# --- build stage -------------------------------------------------------------
FROM rust:1.87-alpine3.21 AS builder

ARG GXF2BED_VERSION=0.3.2

RUN apk add --no-cache \
    musl-dev \
    bash

WORKDIR /build

RUN cargo install \
    --locked \
    --root /opt/gxf2bed \
    --version ${GXF2BED_VERSION} \
    gxf2bed

# --- runtime stage -----------------------------------------------------------
FROM alpine:3.21 AS runtime

RUN apk add --no-cache \
    bash \
    procps

COPY --from=builder /opt/gxf2bed/bin/gxf2bed /usr/local/bin/gxf2bed

ENTRYPOINT ["gxf2bed"]
CMD ["--help"]
