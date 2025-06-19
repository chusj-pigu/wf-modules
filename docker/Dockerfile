FROM ubuntu:22.04

# Set timezone
ENV DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    echo "America/New_York" > /etc/timezone && \
    apt update && apt install -y tzdata

# Install required system dependencies (excluding MySQL)
RUN apt update && apt install -y \
    software-properties-common \
    dirmngr \
    gnupg \
    libcurl4-openssl-dev \
    libssl-dev \
    libmariadb-dev \
    libmariadb-dev-compat \
    libxml2-dev \
    libbz2-dev \
    liblzma-dev \
    libz-dev \
    libpcre2-dev \
    libicu-dev \
    libpng-dev \
    libjpeg-dev \
    libtiff-dev \
    libgit2-dev \
    libssh2-1-dev \
    libexpat1-dev \
    libglib2.0-dev \
    libxt-dev \
    libfontconfig1-dev \
    libsqlite3-dev \
    libgraphviz-dev \
    libboost-graph-dev \
    libfftw3-dev \
    gfortran \
    libgfortran5 \
    libreadline-dev \
    libudunits2-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libv8-dev \
    build-essential \
    cmake \
    wget \
    git \
    curl \
    ca-certificates \
    && apt clean

# Install R 4.5.0 from source
RUN cd /tmp && \
    wget https://cran.r-project.org/src/base/R-4/R-4.5.0.tar.gz && \
    tar -xzf R-4.5.0.tar.gz && \
    cd R-4.5.0 && \
    ./configure --enable-R-shlib --with-blas --with-lapack && \
    make -j$(nproc) && \
    make install && \
    cd / && rm -rf /tmp/R-4.5.0*

# Set R library path
ENV R_LIBS_USER=/usr/local/lib/R/site-library
RUN mkdir -p ${R_LIBS_USER}

# Install Bioconductor 3.21 and packages
RUN R -e "\
install.packages('BiocManager', repos='https://cloud.r-project.org'); \
BiocManager::install(version='3.21'); \
install.packages('statmod', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('png', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('bitops', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('ggplot2', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('remotes', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('ggrepel', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('RSQLite', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('S4Vectors', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('XML', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('data.table', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('optparse', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('RCurl', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('yaml', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('matrixStats', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('RColorBrewer', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('paletteer', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('pheatmap', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('writexl', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('locfit', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('heatmaply', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('plotly', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('plyr', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('DT', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('shinyBS', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('shinyAce', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('threejs', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('shinydashboard', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('futile.logger', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('snow', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('filelock', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('NMF', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('RcppArmadillo', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('BH', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('rjson', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('restfulr', dependencies=TRUE, repos='https://cloud.r-project.org'); \
BiocManager::install('graph', ask=FALSE, update=TRUE); \
BiocManager::install('RBGL', ask=FALSE, update=TRUE); \
BiocManager::install('GenomeInfoDb', ask=FALSE, update=TRUE); \
BiocManager::install('Biostrings', ask=FALSE, update=TRUE); \
BiocManager::install('MatrixGenerics', ask=FALSE, update=TRUE); \
BiocManager::install('DelayedArray', ask=FALSE, update=TRUE); \
BiocManager::install('BiocParallel', ask=FALSE, update=TRUE); \
BiocManager::install('SummarizedExperiment', ask=FALSE, update=TRUE); \
BiocManager::install('Rsamtools', ask=FALSE, update=TRUE); \
BiocManager::install('GenomicAlignments', ask=FALSE, update=TRUE); \
BiocManager::install('GenomicRanges', ask=FALSE, update=TRUE); \
BiocManager::install('KEGGREST', ask=FALSE, update=TRUE); \
BiocManager::install('AnnotationDbi', ask=FALSE, update=TRUE); \
BiocManager::install('GO.db', ask=FALSE, update=TRUE); \
BiocManager::install('limma', ask=FALSE, update=TRUE); \
BiocManager::install('annotate', ask=FALSE, update=TRUE); \
BiocManager::install('rtracklayer', ask=FALSE, update=TRUE); \
BiocManager::install('biomaRt', ask=FALSE, update=TRUE); \
BiocManager::install('BiocFileCache', ask=FALSE, update=TRUE); \
BiocManager::install('BiocGenerics', ask=FALSE, update=TRUE); \
BiocManager::install('RMariaDB', ask=FALSE, update=TRUE); \
BiocManager::install('DESeq2', ask=FALSE, update=TRUE); \
BiocManager::install('pcaExplorer', ask=FALSE, update=TRUE); \
BiocManager::install('GenomicFeatures', ask=FALSE, update=TRUE); \
BiocManager::install('txdbmaker', ask=FALSE, update=TRUE); \
install.packages('ragg', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('textshaping', dependencies=TRUE, repos='https://cloud.r-project.org'); \
install.packages('tidyverse', dependencies=TRUE, repos='https://cloud.r-project.org')"


