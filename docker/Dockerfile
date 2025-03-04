FROM rust:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    cmake \
    libclang-dev \
    procps

WORKDIR /opt/
RUN git clone https://github.com/wdecoster/cramino.git
    
WORKDIR /opt/cramino
RUN  cargo install --path .

RUN cramino --help