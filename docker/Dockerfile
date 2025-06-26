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

# Install CRAN packages individually
RUN R -e "install.packages('BiocManager', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('BH', repos='http://cran.rstudio.com/', dependencies=TRUE)"
RUN R -e "install.packages('R.utils', repos='http://cran.rstudio.com/', dependencies=TRUE)"
RUN R -e "install.packages('snow', repos='http://cran.rstudio.com/', dependencies=TRUE)"
RUN R -e "install.packages('future.apply', repos='http://cran.rstudio.com/', dependencies=TRUE)"
RUN R -e "install.packages('matrixStats', repos='http://cran.rstudio.com/', dependencies=TRUE)"
RUN R -e "install.packages('bitops', repos='http://cran.rstudio.com/', dependencies=TRUE)"
RUN R -e "install.packages('snowfall', repos='http://cran.rstudio.com/', dependencies=TRUE)"
RUN R -e "install.packages('RCurl', repos='http://cran.rstudio.com/', dependencies=TRUE)"
RUN R -e "install.packages('crayon', repos='http://cran.rstudio.com/', dependencies=TRUE)"
RUN R -e "install.packages('futile.logger', repos='http://cran.rstudio.com/', dependencies=TRUE)"
RUN R -e "install.packages('optparse', repos='http://cran.rstudio.com/', dependencies=TRUE)"
RUN R -e "install.packages('remotes', repos='http://cran.rstudio.com/', dependencies=TRUE)"
RUN R -e "install.packages('grDevices', repos='http://cran.rstudio.com/', dependencies=TRUE)"

# Install Bioconductor packages individually
RUN R -e "BiocManager::install('CGHcall', ask=FALSE)"
RUN R -e "BiocManager::install('Biostrings', ask=FALSE)"
RUN R -e "BiocManager::install('GenomicRanges', ask=FALSE)"
RUN R -e "BiocManager::install('Rsamtools', ask=FALSE)"
RUN R -e "BiocManager::install('BiocParallel', ask=FALSE)"
RUN R -e "BiocManager::install('GenomeInfoDb', ask=FALSE)"

# Install QDNAseq and hg19 annotation
RUN R -e "BiocManager::install('QDNAseq', ask=FALSE)"
RUN R -e "BiocManager::install('QDNAseq.hg19', ask=FALSE)"

# Install QDNAseq.hg38 from GitHub
RUN R -e "remotes::install_github('asntech/QDNAseq.hg38')"

# Test libraries
RUN R -e "library(QDNAseq)"
RUN R -e "library(QDNAseq.hg38)"

# Copy and prepare scripts
WORKDIR /opt/
COPY scripts /opt/scripts
RUN chmod +x /opt/scripts/*.R

# Add scripts to PATH
ENV PATH="/opt/scripts:${PATH}"
