FROM ubuntu:latest

# Install dependencies
RUN apt update && apt upgrade -y
RUN apt-get install -y \
    curl \
    git \
    procps \
    make \
    gcc \
    g++ \
    libz-dev \
    libbz2-dev \
    liblzma-dev


# TODO: Install procps for NextFlow

WORKDIR /opt/
RUN git clone https://github.com/lh3/gfatools
WORKDIR /opt/gfatools
RUN make

# Add gfatools to PATH
ENV PATH="/opt/gfatools:${PATH}"
