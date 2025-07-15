FROM python:3.11

# Install dependencies
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    git \
    r-base-dev

# TODO: Install procps for NextFlow

RUN apt-get update && apt-get install -y \
    procps

WORKDIR /opt

RUN git clone https://github.com/hovestadt/MARLIN

RUN set -e && \
    R -e "install.packages('textshaping', dependencies=TRUE, repos='http://cran.rstudio.com/')" && \
    R -e "install.packages('knitr', dependencies=TRUE, repos='http://cran.rstudio.com/')" && \
    R -e "install.packages('tidyverse', dependencies=TRUE, repos='http://cran.rstudio.com/')" && \
    R -e "install.packages('kableExtra', dependencies=TRUE, repos='http://cran.rstudio.com/')" && \
    R -e "install.packages('tensorflow', dependencies=TRUE, repos='http://cran.rstudio.com/')" && \
    R -e "install.packages('data.table', dependencies=TRUE, repos='http://cran.rstudio.com/')" && \
    R -e "install.packages('openxlsx', dependencies=TRUE, repos='http://cran.rstudio.com/')" && \
    R -e "install.packages('remotes', dependencies=TRUE, repos='http://cran.rstudio.com/')" && \
    R -e "remotes::install_version('keras', version = '2.13.0', repos='http://cran.rstudio.com/')"


# Install rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
# Add .cargo/bin to PATH
ENV PATH="/root/.cargo/bin:${PATH}"
# install modkit

# Install modkit
RUN cargo install --git https://github.com/nanoporetech/modkit.git

# Install MARLIN
COPY ./MARLIN /opt/MARLIN

# Make Alias
RUN echo 'alias marlin="/opt/MARLIN/MARLIN_realtime/0_real_time_prediction_main.sh"' >> ~/.bashrc
RUN echo 'alias marlin_rt="/opt/MARLIN/MARLIN_realtime/1_process_live.sh"' >> ~/.bashrc

RUN pip3 install --upgrade pip
RUN pip3 install tensorflow==2.15.1
