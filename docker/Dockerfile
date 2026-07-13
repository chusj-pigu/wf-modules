FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    procps \
    wget \
    zip \
    && rm -rf /var/lib/apt/lists/*

# Install lamprey
RUN git clone https://github.com/princessmaximacenter/Lamprey /Lamprey
WORKDIR /Lamprey

RUN python -m venv venv
ENV PATH="/Lamprey/venv/bin:${PATH}"

RUN pip install --upgrade pip && \
    pip install .

# Download model 
RUN python -c "from huggingface_hub import snapshot_download; snapshot_download(repo_id='tachterberg/Lamprey')"

# Install modkit
WORKDIR /opt

RUN MODKIT_VERSION=v0.6.4 && \
    wget -q "https://github.com/nanoporetech/modkit/releases/download/${MODKIT_VERSION}/modkit_${MODKIT_VERSION}_u16_x86_64.tar.gz" -O - | tar -xz && \
    mv dist_modkit_${MODKIT_VERSION}_cd85862/modkit /usr/local/bin/modkit

ENV PATH="/usr/local/bin:${PATH}"

RUN modkit -h