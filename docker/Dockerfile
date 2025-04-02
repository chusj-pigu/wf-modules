# Use the official Arch Linux base image
FROM ubuntu:latest

# Install dependencies for building AUR packages
RUN apt-get update && apt-get install -y \
    bzip2 \
    gcc \
    libgsl-dev \
    libgsl0-dev \
    libperl-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    make \
    procps \
    tar \
    wget \
    curl \
    zlib1g-dev

WORKDIR /opt/app

# Install htslib dependency

RUN wget https://github.com/samtools/htslib/releases/download/1.21/htslib-1.21.tar.bz2 && \
    tar -vxjf htslib-1.21.tar.bz2 && \
    cd htslib-1.21 && \
    make

# Install mosdepth
RUN wget https://github.com/brentp/mosdepth/releases/download/v0.3.11/mosdepth && \
    chmod +x mosdepth

ENV PATH="/usr/local/bin/:${PATH}"

RUN rm htslib-1.21.tar.bz2

RUN mv mosdepth /usr/local/bin/

RUN mosdepth --help
