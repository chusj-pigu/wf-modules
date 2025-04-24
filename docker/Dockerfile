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
    libmariadb-dev \
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

# Install CRAN packages
RUN R -e "install.packages('BiocManager', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('tidyverse', 'ggplot2', 'ggrepel', 'RColorBrewer','paletteer','pheatmap','writexl'), dependencies=TRUE, repos='http://cran.rstudio.com/')"

# Install Bioconductor dependencies
RUN R -e "BiocManager::install(c('GenomicRanges', 'AnnotationDbi', 'GenomicAlignments', 'rtracklayer', 'txdbmaker', 'RMariaDB'), ask=FALSE)"

# Install target Bioconductor packages
RUN R -e "BiocManager::install(c('DESeq2', 'pcaExplorer', 'GenomicFeatures'), ask=FALSE)"

# Verify installation
RUN R -e "BiocManager::valid()"

# Set default command
CMD ["R"]