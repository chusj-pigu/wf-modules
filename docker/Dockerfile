FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    git \
    procps \
    wget \
    zip \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/princessmaximacenter/Lamprey /Lamprey
WORKDIR /Lamprey

RUN python -m venv venv
ENV PATH="/Lamprey/venv/bin:${PATH}"

RUN pip install --upgrade pip && \
    pip install .