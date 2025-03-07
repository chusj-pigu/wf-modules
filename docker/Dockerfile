# Use the official Maven image with Java 21 as the build stage
FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    build-essential \
    openjdk-21-jdk  \
    git \ 
    procps \
    wget \
    unzip \
    pigz

WORKDIR /opt/app/

RUN wget https://snpeff.blob.core.windows.net/versions/snpEff_latest_core.zip

RUN unzip snpEff_latest_core.zip

WORKDIR /opt/app/snpEff

