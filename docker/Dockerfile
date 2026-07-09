FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    curl \
    git \
    gcc \
    g++ \
    zlib1g-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libbz2-dev \
    liblzma-dev \
    pkg-config \
    make \
    procps

WORKDIR /opt/app

RUN git clone https://github.com/marbl/Winnowmap.git && cd Winnowmap && make -j8

ENV PATH="/opt/app/Winnowmap/bin:${PATH}"