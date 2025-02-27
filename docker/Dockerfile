FROM hkubal/clairs-to:latest

WORKDIR /opt/bin
# Install dependencies
RUN apt-get update && apt-get install -y \
    procps

CMD run_clairs_to --help