FROM python:3.8

# Install dependencies
RUN apt-get update && apt-get install -y \
    procps \
    bash \
    curl \
    git \
    gcc \
    make \
    openjdk-17-jre \
    autoconf \
    unzip

# Install bcftools
WORKDIR /opt
RUN wget https://github.com/samtools/bcftools/releases/download/1.14/bcftools-1.14.tar.bz2
RUN tar -jxvf bcftools-1.14.tar.bz2
RUN rm bcftools-1.14.tar.bz2
WORKDIR /opt/bcftools-1.14
RUN make install

# Install python packages
RUN pip install --upgrade pip
# Numpy >= v1.24 is NOT compatible with SubChrom
RUN pip install pybedtools pandas==1.3.5 numpy==1.21.6 matplotlib==3.5.3 scipy==1.7.3 argparse
RUN pip install deeptools==3.5.0

# Install bedtools
WORKDIR /opt/
RUN wget https://github.com/arq5x/bedtools2/releases/download/v2.30.0/bedtools-2.30.0.tar.gz
RUN tar -zxvf bedtools-2.30.0.tar.gz
RUN rm bedtools-2.30.0.tar.gz
WORKDIR /opt/bedtools2 
RUN make install

# Install GATK
WORKDIR /opt/
RUN wget https://github.com/broadinstitute/gatk/releases/download/4.1.8.0/gatk-4.1.8.0.zip
RUN unzip gatk-4.1.8.0.zip
RUN mv gatk-4.1.8.0 /opt/gatk
RUN rm gatk-4.1.8.0.zip 

# Install SubChrom
WORKDIR /opt/
RUN git clone https://github.com/Shaohua-Lei/SubChrom.git

ENV PATH="/opt/gatk:/opt/SubChrom/scripts:${PATH}"

# Set working directory
WORKDIR /opt/SubChrom/data/

ENV MPLCONFIGDIR=/tmp/mplconfig

# Get the SNP databases
RUN curl -o SNPmarker_hg38.zip https://zenodo.org/records/10155688/files/SNPmarker_hg38.zip?download=1 && \
    unzip SNPmarker_hg38.zip && rm SNPmarker_hg38.zip
RUN curl -o SNPmarker_hg19.zip https://zenodo.org/records/10155688/files/SNPmarker_hg19.zip?download=1 && \
    unzip SNPmarker_hg19.zip && rm SNPmarker_hg19.zip

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*