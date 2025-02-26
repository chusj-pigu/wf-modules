FROM snakemake/snakemake:v7.32.4

# Install dependencies
RUN apt-get update && apt-get install -y \
    procps \
    texlive \
    texlive-latex-extra \
    git

RUN git clone https://gitlab.com/pesk/nanoDx.git