# syntax=docker/dockerfile:1

ARG BASE_IMAGE=rockylinux/rockylinux:9
ARG BWA_MEM2_REPO=https://github.com/bwa-mem2/bwa-mem2.git

FROM ${BASE_IMAGE} AS build
ARG BWA_MEM2_REPO

RUN dnf -y update && \
    dnf -y install git gcc gcc-c++ make zlib-devel && \
    dnf clean all && rm -rf /var/cache/dnf

WORKDIR /src
RUN git clone --depth 1 --recurse-submodules ${BWA_MEM2_REPO} bwa-mem2

WORKDIR /src/bwa-mem2
RUN make -j"$(nproc)"

FROM ${BASE_IMAGE}

LABEL description="bwa-mem2 latest"

RUN dnf -y install --setopt=install_weak_deps=False \
    zlib \
    libgomp && \
    dnf clean all && rm -rf /var/cache/dnf

COPY --from=build /src/bwa-mem2/bwa-mem2* /usr/local/bin/

WORKDIR /data

CMD ["bwa-mem2"]
