FROM hkubal/clairs-to:v0.5.1

WORKDIR /opt/bin
# Install dependencies
RUN apt-get update && apt-get install -y \
    procps \
    python3-dev
CMD run_clairs_to --help
