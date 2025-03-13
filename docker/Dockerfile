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
RUN rm snpEff_latest_core.zip

WORKDIR /opt/app/snpEff

# # Pre download the hg38 and hg19 genomes in the container
RUN java -jar snpEff.jar download GRCh38.p14
RUN java -jar snpEff.jar download GRCh37.p13

# CMD [ "java", "-jar", "snpEff.jar", "java", "-jar", "SnpSift.jar" ]