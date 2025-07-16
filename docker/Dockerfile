FROM python:3.11

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    curl \
    git \
    procps \
    r-base-dev \
    samtools && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /opt

# Install R packages
RUN R -e "install.packages(c('textshaping', 'knitr', 'tidyverse', 'kableExtra', \
    'tensorflow', 'data.table', 'openxlsx', 'remotes'), dependencies=TRUE, repos='http://cran.rstudio.com/')" && \
    R -e "remotes::install_version('keras', version = '2.13.0', repos='http://cran.rstudio.com/')"

# Install Python packages
RUN pip3 install --upgrade pip && \
    pip3 install tensorflow==2.15.1

# Install Rust and modkit
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    . "$HOME/.cargo/env" && \
    cargo install --git https://github.com/nanoporetech/modkit.git

# Add Rust to PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# Copy local MARLIN repo if needed (overrides the cloned version)
COPY ./MARLIN /opt/MARLIN

# Download MARLIN model
RUN wget -O /opt/marlin_v1.model.hdf5 "https://zenodo.org/records/15565404/files/marlin_v1.model.hdf5?download=1"

RUN mv /opt/marlin_v1.model.hdf5 /opt/MARLIN/MARLIN_realtime/files/

# Set executable permissions for MARLIN scripts
RUN chmod a+x /opt/MARLIN/MARLIN_realtime/*.sh

# Add MARLIN scripts to PATH
ENV PATH="/opt/MARLIN/MARLIN_realtime:${PATH}"
