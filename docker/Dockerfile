FROM hkubal/clairs-to:latest

WORKDIR /opt/bin
# Install dependencies
RUN apt-get update && apt-get install -y \
    procps \
    python3-dev

RUN pip3 install --user whatshap

ENV PATH=$HOME/.local/bin:$PATH

RUN whatshap --help

CMD run_clairs_to --help