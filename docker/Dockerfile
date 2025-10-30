FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y bedtools \
    procps

RUN apt-get clean

WORKDIR /opt/data

COPY chrom_sizes/* ./