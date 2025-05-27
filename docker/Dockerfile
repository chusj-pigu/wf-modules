FROM hkubal/clair3:latest

WORKDIR /opt/bin
# Install dependencies
RUN apt-get update && apt-get install -y \
    procps \
    python3-dev

CMD run_clair3.sh --help