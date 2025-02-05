FROM ubuntu:23.10
FROM continuumio/miniconda3

RUN apt-get update && apt-get install -y \
    python3 \
    pigz \
    git

RUN conda config --add channels defaults
RUN conda config --add channels bioconda
RUN conda config --add channels conda-forge
RUN conda config --set channel_priority strict

RUN conda install -c bioconda chopper


