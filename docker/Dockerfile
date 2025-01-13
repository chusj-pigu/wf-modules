FROM rust:latest

RUN apt-get update && apt-get install -y \
    procps \
    git \
    wget \
    gcc \
    zlib1g-dev \
    make \
    libbz2-dev \
    liblzma-dev \
    autoconf

WORKDIR /opt/

RUN git clone https://github.com/samtools/htslib.git

WORKDIR /opt/htslib
RUN git submodule update --init --recursive

RUN autoreconf -i  # Build the configure script and install files it uses
RUN ./configure    # Optional but recommended, for choosing extra functionality
RUN make install

RUN apt-get install -y \
    libgsl-dev \
    clang

RUN cargo install varlociraptor

RUN rm -rf /var/lib/apt/lists/*