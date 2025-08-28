FROM ghcr.io/chusj-pigu/htslib:latest

# Install dependencies
RUN apt update && apt install -y \
    bash \
    curl \
    git \
    make \
    wget \
    gcc \
    procps

WORKDIR /opt/
# Clone and build Pomfret
COPY pomfret /opt/pomfret
WORKDIR /opt/pomfret
RUN make
ENV PATH="/opt/pomfret:${PATH}"
