FROM ubuntu:latest

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    procps \
    tar \
    wget \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

ENV TIDEHUNTER_VERSION=1.5.5

WORKDIR /opt/app

RUN wget https://github.com/yangao07/TideHunter/releases/download/v${TIDEHUNTER_VERSION}/TideHunter-v${TIDEHUNTER_VERSION}.tar.gz \
    && tar -zxvf TideHunter-v${TIDEHUNTER_VERSION}.tar.gz \
    && cd TideHunter-v${TIDEHUNTER_VERSION} \
    && make \
    && cp bin/TideHunter /usr/local/bin/ \
    && cd .. \
    && rm -rf TideHunter-v${TIDEHUNTER_VERSION}.tar.gz

