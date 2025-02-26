FROM snakemake/snakemake:v7.32.4

WORKDIR /usr/src/app

# Install dependencies
RUN apt-get update && apt-get install -y \
    procps \
    texlive \
    texlive-latex-extra \
    git

RUN git clone https://gitlab.com/pesk/nanoDx.git

RUN cd nanoDx