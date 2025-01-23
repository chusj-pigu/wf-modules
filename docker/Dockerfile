FROM ubuntu:latest

# Install dependencies
RUN apt-get update -y
RUN apt-get install -y wget


WORKDIR /opt
RUN wget https://github.com/ShiLab-Bioinformatics/subread/releases/download/2.0.2/subread-2.0.2-Linux-x86_64.tar.gz
RUN tar -xvzf subread-2.0.2-Linux-x86_64.tar.gz

ENV PATH="/opt/subread-2.0.2-Linux-x86_64/bin:${PATH}"