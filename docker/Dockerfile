# Use the official Ubuntu image as the base image
FROM ubuntu:latest

# Update the package list and install any necessary packages
RUN apt update && apt upgrade -y \
    && apt install -y \
    build-essential \
    git \
    g++ \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-gnutls-dev \
    libssl-dev \
    libxml2-dev \
    libncurses5-dev \
    libncursesw5-dev

WORKDIR /opt/
# Install hifiasm (requiring g++ and zlib)
RUN git clone https://github.com/chhylp123/hifiasm
WORKDIR /opt/hifiasm
RUN make
# Set the PATH environment variable to include the hifiasm binary
ENV PATH="/opt/hifiasm:${PATH}"


CMD [ "hifiasm" ]
