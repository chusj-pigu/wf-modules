# syntax=docker/dockerfile:1

############################
# 1) Builder (Alpine + Rust)
############################
FROM rust:1.94.0-alpine3.23 AS builder

ARG QSV_GIT_URL=https://github.com/dathere/qsv.git
ARG QSV_GIT_REF=908b7aae10db1991e8b149d27ace9bafd23e0ccc
ARG QSV_FEATURES="polars,feature_capable"

RUN apk add --no-cache \
    bash \
    build-base \
    pkgconfig \
    openssl-dev \
    git \
    python3

ENV PYO3_PYTHON=/usr/bin/python3

WORKDIR /src

RUN cargo install \
    --locked \
    --root /opt/qsv-install \
    --git "${QSV_GIT_URL}" \
    --rev "${QSV_GIT_REF}" \
    --features ${QSV_FEATURES} \
    --bin qsv \
    qsv

############################
# 2) Runtime
############################
FROM alpine:3.23

RUN apk add --no-cache \
    bash \
    ca-certificates \
 && adduser -D -u 10001 qsv

COPY --from=builder /opt/qsv-install/bin/qsv /usr/local/bin/qsv

USER qsv
ENTRYPOINT ["qsv"]
CMD ["--help"]
