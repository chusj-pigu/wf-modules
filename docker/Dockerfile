FROM ubuntu:22.04

# Set noninteractive frontend to avoid tzdata prompts
ENV DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    echo "America/New_York" > /etc/timezone && \
    apt update && apt install -y tzdata

# Install system dependencies
RUN apt-get update && apt-get install -y \
    r-base-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    procps

# Set CRAN mirror
RUN echo 'options(repos = c(CRAN = "https://cloud.r-project.org"))' >> /etc/R/Rprofile.site

# Install tidyverse
RUN R -e 'install.packages("tidyverse")'

# Install data.table
RUN R -e 'install.packages("data.table")'

# Verify installation
RUN R -e 'library(tidyverse)'

WORKDIR /opt/
CMD ["R"]
