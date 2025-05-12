FROM bioconductor/bioconductor_docker:RELEASE_3_21

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
    libgfortran5 \
    libudunits2-dev \
    libv8-dev \
    build-essential \
    cmake \
    wget \
    git \
    && apt clean

# Set R library path
ENV R_LIBS_USER=/usr/local/lib/R/site-library
RUN mkdir -p ${R_LIBS_USER}

# Install R and Bioconductor packages in one block
RUN R -e "\
install.packages(c('statmod', 'tidyverse', 'png', 'bitops', 'ggplot2', 'remotes', 'ggrepel', 'RSQLite', 'S4Vectors', 'XML', 'RCurl', 'yaml', 'matrixStats', 'RColorBrewer', 'paletteer', 'pheatmap', 'writexl', 'locfit', 'heatmaply', 'plotly', 'plyr', 'DT', 'shinyBS', 'shinyAce', 'threejs', 'shinydashboard', 'futile.logger', 'snow', 'filelock', 'NMF', 'RcppArmadillo', 'BH', 'rjson', 'restfulr'), dependencies=TRUE, repos='http://cran.rstudio.com/'); \
BiocManager::install(c('graph', 'RBGL', 'GenomeInfoDb', 'Biostrings', 'MatrixGenerics', 'DelayedArray', 'BiocParallel', 'SummarizedExperiment', 'Rsamtools', 'GenomicAlignments', 'GenomicRanges', 'KEGGREST', 'AnnotationDbi', 'GO.db', 'limma', 'annotate', 'rtracklayer', 'biomaRt', 'BiocFileCache', 'BiocGenerics', 'RMariaDB'), ask=FALSE, update=TRUE); \
BiocManager::install(c('DESeq2', 'pcaExplorer', 'GenomicFeatures', 'txdbmaker'), ask=FALSE, update=TRUE); \
library(txdbmaker)"


