FROM ubuntu:latest

## Install Dependencies
RUN apt-get update && apt-get install -y \
    libssl-dev \
    pkg-config \
    procps \
    pigz \
    git

WORKDIR /opt

RUN git clone https://github.com/slw287r/dep.git

RUN rm -rf /var/lib/apt/lists/*

## Set Environment Variables
ENV PATH="/opt/dep/bin:${PATH}"
