FROM ubuntu:24.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    zlib1g-dev


WORKDIR /opt
RUN git clone https://github.com/lh3/minimap2
WORKDIR /opt/minimap2 
RUN make

# Add minimap2 to PATH
ENV PATH="/opt/minimap2:${PATH}"
