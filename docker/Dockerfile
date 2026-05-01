# use the ubuntu base image
FROM ubuntu:22.04

# install required packages
RUN apt-get update && apt-get install -y \
    autoconf \
    build-essential \
    cmake \
    g++ \
    gfortran \
    git \
    libcurl4-gnutls-dev \
    hdf5-tools \
    libboost-date-time-dev \
    libboost-program-options-dev \
    libboost-system-dev \
    libboost-filesystem-dev \
    libboost-iostreams-dev \
    libbz2-dev \
    libdeflate-dev \
    libhdf5-dev \
    libncurses-dev \
    liblzma-dev \
    procps \
    pkg-config \
    zlib1g-dev \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# set environment
ENV BOOST_ROOT="/usr"

WORKDIR /opt

# install delly
RUN git clone --recursive https://github.com/dellytools/delly.git \
    && cd delly/ \
    && make STATIC=1 PARALLEL=1 all \
    && make install

# Add blacklists to container
WORKDIR /opt/data

RUN wget https://gear-genomics.embl.de/data/delly/Homo_sapiens.GRCh38.dna.primary_assembly.fa.r101.s501.blacklist.gz && \
    wget https://gear-genomics.embl.de/data/delly/Homo_sapiens.GRCh38.dna.primary_assembly.fa.r101.s501.blacklist.gz.fai && \
    wget https://gear-genomics.embl.de/data/delly/Homo_sapiens.GRCh38.dna.primary_assembly.fa.r101.s501.blacklist.gz.gzi && \
    wget https://gear-genomics.embl.de/data/delly/Homo_sapiens.GRCh37.dna.primary_assembly.fa.r101.s501.blacklist.gz && \
    wget https://gear-genomics.embl.de/data/delly/Homo_sapiens.GRCh37.dna.primary_assembly.fa.r101.s501.blacklist.gz.fai && \
    wget https://gear-genomics.embl.de/data/delly/Homo_sapiens.GRCh38.dna.primary_assembly.fa.r101.s501.blacklist.gz.gzi && \
    wget https://gear-genomics.embl.de/data/delly/T2T-CHM13v1.1.fa.r101.s501.gz && \
    wget https://gear-genomics.embl.de/data/delly/T2T-CHM13v1.1.fa.r101.s501.gz.fai && \
    wget https://gear-genomics.embl.de/data/delly/T2T-CHM13v1.1.fa.r101.s501.gz.gzi

# Add Delly to PATH
ENV PATH="/opt/delly/bin:${PATH}"

WORKDIR /opt

# Set OpenMP threads
ENV OMP_NUM_THREADS=10

