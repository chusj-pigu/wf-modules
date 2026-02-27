FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /opt/app

# -------------------------
# System dependencies
# -------------------------
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    g++ \
    make \
    git \
    curl \
    libbz2-dev \
    liblzma-dev \
    zlib1g-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libssl-dev \
    libffi-dev \
    libgomp1 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Fix legacy C issues
ENV CFLAGS="-std=c99"
ENV CXXFLAGS="-std=c++14"

# -------------------------
# Virtualenv
# -------------------------
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# -------------------------
# Core packaging tools
# -------------------------
RUN pip install --upgrade \
    pip==24.0 \
    setuptools==69.5.1 \
    wheel==0.43.0

# -------------------------
# Build system + core deps
# -------------------------
RUN pip install \
    poetry-core==1.9.0 \
    cython==0.29.37 \
    build

# -------------------------
# Scientific stack (pinned)
# -------------------------
RUN pip install \
    numpy==1.26.4 \
    pandas==2.2.2 \
    scipy==1.11.4 \
    matplotlib==3.8.4 \
    seaborn==0.13.2 \
    bokeh==3.4.1 \
    statsmodels==0.14.2

# -------------------------
# 🔴 CRITICAL BUILD DEP ORDER
# -------------------------

# Install low-level compiled deps first
RUN pip install --no-build-isolation --no-cache-dir ailist

RUN pip install --no-build-isolation --no-cache-dir genome_info

RUN pip install --no-build-isolation --no-cache-dir hmmCNV

RUN pip install --no-build-isolation --no-cache-dir linear_segment

RUN pip install --no-cache-dir pysam

# Torch (CPU)
RUN pip install torch --index-url https://download.pytorch.org/whl/cpu

RUN pip install --no-build-isolation --no-cache-dir ngsfragments

# Finally install MethylVerse
RUN pip install --no-cache-dir MethylVerse

RUN python -m MethylVerse MPACT -h
