FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    autoconf \
    build-essential \
    git \
    gsl-bin \
    libgsl-dev \
    libgsl0-dev \
    libperl-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    perl \
    pigz \
    procps \
    zlib1g \
    zlib1g-dev

WORKDIR /opt/app

RUN git clone --recurse-submodules https://github.com/samtools/htslib.git
RUN git clone https://github.com/samtools/bcftools.git

WORKDIR /opt/app/bcftools
 # The following is optional:
RUN autoheader && autoconf && ./configure --prefix=/opt/app/ --enable-libgsl --enable-perl-filters --
RUN make
RUN make install

# Add /opt/app/bin to the PATH
ENV PATH="/opt/app/bin:${PATH}"

WORKDIR /opt/app

