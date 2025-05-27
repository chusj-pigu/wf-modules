FROM python:3.13-slim

RUN apt update && apt install -y \
    build-essential \
    gcc \
    libz-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    procps \
    && apt clean

WORKDIR /opt/app

RUN pip3 install --upgrade pip && \
    pip3 install scipy \
    pysam==0.21.0 \
    biopython \
    cigar \
    numpy \
    pyvcf3 \
    scikit-learn \
    cuteSV

CMD ["bash"]