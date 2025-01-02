FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    git \
    python3.10-venv \
    procps

RUN pip3 install edlib

RUN pip3 install git+https://github.com/epi2me-labs/pychopper.git

RUN pychopper --help

# TODO: Make an alias to get version