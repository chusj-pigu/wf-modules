FROM ubuntu:22.04

# Set noninteractive frontend to avoid tzdata prompts
ENV DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    echo "America/New_York" > /etc/timezone && \
    apt update && apt install -y tzdata

# Install base R and necessary system libraries
RUN apt update && apt install -y \
    r-base-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libbz2-dev \
    liblzma-dev \
    libz-dev \
    libpcre2-dev \
    libicu-dev \
    libpng-dev \
    libjpeg-dev \
    libtiff-dev \
    libglib2.0-dev \
    libxt-dev \
    libfontconfig1-dev \
    build-essential \
    cmake \
    wget \
    git \
    && apt clean

# Set R library path
ENV R_LIBS_USER=/usr/local/lib/R/site-library
RUN mkdir -p ${R_LIBS_USER}

#Install cran dependencies
RUN R -e "install.packages('BiocManager', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('BH', 'R.utils', 'snow', 'future.apply', 'matrixStats', 'bitops', 'snowfall', 'RCurl', 'crayon', 'futile.logger', 'optparse', 'remotes'), dependencies=TRUE, repos='http://cran.rstudio.com/')"

# Install Bioconductor dependencies
RUN R -e "BiocManager::install(c('CGHcall', 'Biostrings', 'GenomicRanges', 'Rsamtools', 'BiocParallel', 'GenomeInfoDb'), ask=FALSE)"

# Install QDNAseq
RUN R -e "BiocManager::install(c('QDNAseq', 'QDNAseq.hg19'), ask=FALSE)"

# Install QDNAseq.hg38 from github

# Install QDNAseq
RUN R -e "remotes::install_github('asntech/QDNAseq.hg38')"

# Verify installation
RUN R -e "library('QDNAseq')"
RUN R -e "library('QDNAseq.hg38')"

WORKDIR /opt/
COPY scripts /opt/scripts
# Make scripts executable
RUN chmod +x /opt/scripts/*.R

# Add call_qdnaseq.R to path
ENV PATH="/opt/scripts:${PATH}"
