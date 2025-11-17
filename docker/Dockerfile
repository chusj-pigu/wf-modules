FROM python:3.12

# Install dependencies
RUN apt-get update && apt-get install -y \
    bash \
    git \
    procps \
    samtools

WORKDIR /opt/app

RUN pip install --upgrade pip
RUN pip install matplotlib methylartist