FROM rust:latest

RUN apt-get update && apt-get install -y \
    procps \
    gnuplot \
    fd-find \
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

# Install CRAN packages
RUN R -e "install.packages('BiocManager', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('argparse', 'tidyverse', 'ggplot2', 'ggrepel', 'RColorBrewer','paletteer','pheatmap','writexl'), dependencies=TRUE, repos='http://cran.rstudio.com/')"

# Install Bioconductor dependencies
RUN R -e "BiocManager::install(c('GenomicRanges', 'AnnotationDbi', 'GenomicAlignments', 'rtracklayer'), ask=FALSE)"

# Install target Bioconductor packages
RUN R -e "BiocManager::install(c('DESeq2', 'pcaExplorer', 'GenomicFeatures'), ask=FALSE)"

# Verify installation
RUN R -e "BiocManager::valid()"

# Install rust tools
RUN cargo install eza
RUN cargo install zoxide
RUN cargo install sd
RUN cargo install du-dust
RUN cargo install ripgrep
RUN cargo install bandwhich
RUN cargo install nu

RUN useradd -p '' -s /usr/local/cargo/bin/nu nushell \
    && mkdir -p /home/nushell/.config/nushell/ \
    # Setup default config file for nushell
    && cd /home/nushell/.config/nushell \
    && chmod +x /usr/local/cargo/bin/nu \
    && chown -R nushell:nushell /home/nushell/.config/nushell \
    # Reset Nushell config to default
    && su -c 'config reset -w' nushell \
    && ls /usr/local/cargo/bin/nu_plugin* \
    | xargs -I{} su -c 'plugin add {}' nushell \
    && rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/*

# Prepare Nushell user configuration
RUN mkdir -p /root/.config/nushell && \
    touch /root/.config/nushell/config.nu

RUN chown -R nushell:nushell /opt/
RUN chown -R nushell:nushell /usr/local/cargo

WORKDIR /opt/
RUN mkdir -p nu-plugins
COPY scripts scripts
RUN chmod a+x /opt/scripts/*
ENV PATH="/opt/scripts:${PATH}"

USER nushell

SHELL ["/usr/local/cargo/bin/nu", "-c"]

ENV NU_PLUGIN_DIRS='/opt/nu-plugins'
ENV PATH="/opt/scripts:${PATH}"

RUN [ nu_plugin_inc \
    nu_plugin_polars \
    nu_plugin_gstat \
    nu_plugin_formats \
    nu_plugin_query \
    ] | each { cargo install $in --locked } | ignore

RUN  ls --full-paths  /usr/local/cargo/bin/nu_plugin_* | get name | each { |$it| plugin add $it }

CMD ["nu"]
