# Use the official Alpine image as the base image
FROM ubuntu:latest

# Update the package list and install any necessary packages
RUN apt update && apt install -y \
    python3 \
    python3-pip \
    r-base-dev \
    pipx \
    wget \
    procps \
    libfontconfig1-dev \
    libcurl4-openssl-dev \
    libxml2-dev

RUN pipx install jupyter --include-deps
RUN pipx install papermill

ENV CONTAINER_NAME="Quarto with Tidyverse"
ENV R_LIBS_USER=/lib/R/site-library

ENV R_LIBS_USER=/usr/local/lib/R/site-library
RUN mkdir -p ${R_LIBS_USER}

RUN R -e "install.packages(c('knitr', 'tidyverse', 'kableExtra'), dependencies=TRUE, repos='http://cran.rstudio.com/')"

RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.6.39/quarto-1.6.39-linux-amd64.deb

RUN dpkg -i quarto-1.6.39-linux-amd64.deb

# Set the working directory in the container

WORKDIR /data

# Set the default command for the container

CMD [ "quarto" ]
