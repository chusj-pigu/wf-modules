# syntax=docker/dockerfile:1

############################
# 1) Builder (Alpine + Rust)
############################
FROM rust:1.93.1-alpine3.21 AS builder

# Optional: choose qsv source and feature set at build time
ARG QSV_GIT_URL=https://github.com/dathere/qsv.git
ARG QSV_GIT_REF=45710000513e667c9a3e8c569693d04c74523a75
ARG QSV_FEATURES=feature_capable

# Build deps. Keep them only in builder stage.
# - build-base: gcc/make/etc
# - pkgconfig + openssl-dev: common native deps for crates that do TLS, etc.
# - git: to clone repo
RUN apk add --no-cache \
    build-base \
    pkgconfig \
    openssl-dev \
    git

WORKDIR /src

# Install qsv to a deterministic path so runtime COPY is stable.
RUN set -eux; \
    ref_args=""; \
    if [ -n "${QSV_GIT_REF}" ]; then \
      ref_args="--rev ${QSV_GIT_REF}"; \
    fi; \
    cargo install \
      --root /opt/qsv-install \
      --git "${QSV_GIT_URL}" \
      ${ref_args} \
      --features "${QSV_FEATURES}" \
      --bin qsv \
      qsv

############################
# 2) Runtime (minimal Alpine)
############################
FROM alpine:3.21

# Add bash to the runtime image.
RUN apk add --no-cache \
      bash \
      ca-certificates \
    && adduser -D -u 10001 qsv

COPY --from=builder /opt/qsv-install/bin/qsv /usr/local/bin/qsv

USER qsv
ENTRYPOINT ["qsv"]
CMD ["--help"]
