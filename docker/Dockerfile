# Stable base (Jammy) to avoid surprises
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Build deps: autotools + dev libs for htslib/Delly + boost
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash ca-certificates curl git procps \
    build-essential cmake \
    autoconf automake libtool pkg-config \
    zlib1g-dev libbz2-dev liblzma-dev \
    libboost-all-dev \
    procps \
    wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# Clone with submodules
RUN git clone --recursive https://github.com/dellytools/delly.git

WORKDIR /opt/data

# Add blacklists to container
RUN wget https://gear-genomics.embl.de/data/delly/Homo_sapiens.GRCh38.dna.primary_assembly.fa.r101.s501.blacklist.gz && \
    wget https://gear-genomics.embl.de/data/delly/Homo_sapiens.GRCh38.dna.primary_assembly.fa.r101.s501.blacklist.gz.fai && \
    wget https://gear-genomics.embl.de/data/delly/Homo_sapiens.GRCh37.dna.primary_assembly.fa.r101.s501.blacklist.gz && \
    wget https://gear-genomics.embl.de/data/delly/Homo_sapiens.GRCh37.dna.primary_assembly.fa.r101.s501.blacklist.gz.fai 

WORKDIR /opt/delly

# Build with OpenMP support
RUN make clean && make PARALLEL=1 src/delly

# Install
RUN install -m 0755 src/delly /usr/local/bin/delly

# Add to path
ENV PATH="/usr/local/bin:${PATH}"

ENTRYPOINT ["delly"]
