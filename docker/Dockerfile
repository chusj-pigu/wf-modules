FROM python:3.10

# Install dependencies
RUN apt-get update && apt-get install -y \
    procps \
    bash \
    curl \
    git \
    gcc \
    make \
    openjdk-17-jre \
    autoconf


# Install htslib
WORKDIR /opt/
RUN git clone https://github.com/samtools/htslib.git
WORKDIR /opt/htslib
RUN git submodule update --init --recursive
RUN autoreconf -i
RUN make install

# Install bcftools
WORKDIR /opt
RUN git clone https://github.com/samtools/bcftools.git
WORKDIR /opt/bcftools
RUN git submodule update --init --recursive
RUN autoreconf -i
RUN make install

# Install python packages
RUN pip install --upgrade pip
RUN pip install pybedtools pandas numpy matplotlib scipy argparse
RUN pip install deeptools

# Install bedtools
WORKDIR /opt/
RUN wget https://github.com/arq5x/bedtools2/releases/download/v2.29.1/bedtools-2.29.1.tar.gz
RUN tar -zxvf bedtools-2.29.1.tar.gz
WORKDIR /opt/bedtools2 
RUN make install

# Install GATK
WORKDIR /opt/
RUN wget https://github.com/broadinstitute/gatk/releases/download/4.6.1.0/gatk-4.6.1.0.zip
RUN unzip gatk-4.6.1.0.zip
RUN mv gatk-4.6.1.0 /opt/gatk

# Install SubChrom
WORKDIR /opt/
RUN git clone https://github.com/Shaohua-Lei/SubChrom.git

ENV PATH="/opt/gatk:/opt/SubChrom/scripts:${PATH}"

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set working directory
WORKDIR /data