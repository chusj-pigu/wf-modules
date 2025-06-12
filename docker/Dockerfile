# Use the official Alpine image as the base image
FROM python:latest

ENV MAKEFLAGS="-j10"

# Update the package list and install any necessary packages
RUN apt update && apt install -y \
    r-base-dev \
    wget \
    procps \
    libfontconfig1-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    git \
    curl \
    ca-certificates \
    pipx \
    libharfbuzz-dev \
    libfribidi-dev \
    libmagick++-dev \
    cargo

# Install pipx packages
RUN pip install jupyter && \
    pip install papermill

ENV R_LIBS_USER=/usr/local/lib/R/site-library
RUN mkdir -p ${R_LIBS_USER}

# Ensure that Rscript is available in the PATH
ENV PATH="${PATH}:/usr/lib/R/bin"
ENV R_HOME=/usr/lib/R
ENV QUARTO_R=/usr/lib/R/bin/Rscript

RUN R -e "install.packages(c('textshaping','knitr', 'tidyverse', 'kableExtra'), dependencies=TRUE, repos='http://cran.rstudio.com/')"

RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.7.31/quarto-1.7.31-linux-amd64.deb

RUN dpkg -i quarto-1.7.31-linux-amd64.deb

# Set the working directory in the container

WORKDIR /data

# Set the default command for the container

CMD [ "quarto" ]
