FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    procps \
    git

WORKDIR /opt/app

RUN git clone https://github.com/gpertea/gffread && \
    cd gffread && \
    make release

ENV PATH="/opt/app/gffread:${PATH}"
