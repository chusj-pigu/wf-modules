FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-pip \
    r-base \
    r-base-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    r-base-dev \
    cmake

WORKDIR /opt/

RUN R -e 'install.packages("optparse")'
RUN R -e 'install.packages("BiocManager")'
RUN R -e 'install.packages("plyr")'

RUN R -e 'BiocManager::install("HMMcopy")'
RUN R -e 'BiocManager::install("GenomicRanges")'


COPY ichorCNA /opt/ichorCNA
RUN R -e 'install.packages("ichorCNA", repos=NULL, type="source")'

ENV PATH="/opt/ichorCNA/scripts:${PATH}"
ENV PATH="/opt/ichorCNA/R:${PATH}"

## This should be in a separate container eventually

RUN git clone https://github.com/shahcompbio/hmmcopy_utils.git

WORKDIR /opt/hmmcopy_utils
RUN cmake .
RUN make

ENV PATH="/opt/hmmcopy_utils/bin:${PATH}"

WORKDIR /opt/


CMD ["/bin/bash"]