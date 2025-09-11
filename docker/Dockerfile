FROM python:3.11

# Install system dependencies
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    git \
    procps \
    r-base-dev \
    r-cran-matrix \
    samtools && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /opt

# Install R packages
# Set CRAN repository URL as environment variable
ENV CRAN_REPO=http://cran.rstudio.com/

# Install R packages individually and fail fast if any fail
RUN R -e "stopifnot(install.packages('textshaping', dependencies=TRUE, repos=Sys.getenv('CRAN_REPO')) == 0)"
RUN R -e "stopifnot(install.packages('knitr', dependencies=TRUE, repos=Sys.getenv('CRAN_REPO')) == 0)"
RUN R -e "stopifnot(install.packages('tidyverse', dependencies=TRUE, repos=Sys.getenv('CRAN_REPO')) == 0)"
RUN R -e "stopifnot(install.packages('kableExtra', dependencies=TRUE, repos=Sys.getenv('CRAN_REPO')) == 0)"
RUN R -e "stopifnot(install.packages('tensorflow', dependencies=TRUE, repos=Sys.getenv('CRAN_REPO')) == 0)"
RUN R -e "stopifnot(install.packages('data.table', dependencies=TRUE, repos=Sys.getenv('CRAN_REPO')) == 0)"
RUN R -e "stopifnot(install.packages('openxlsx', dependencies=TRUE, repos=Sys.getenv('CRAN_REPO')) == 0)"
RUN R -e "stopifnot(install.packages('remotes', dependencies=TRUE, repos=Sys.getenv('CRAN_REPO')) == 0)"

# Install specific version of keras and fail if it doesn't work
RUN R -e "remotes::install_version('keras', version = '2.13.0', repos=Sys.getenv('CRAN_REPO'))"



# Install Python packages
RUN pip3 install --upgrade pip && \
    pip3 install tensorflow==2.15.1 \
    pip3 install uv \
    pip3 install h5py

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
