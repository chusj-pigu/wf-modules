FROM hkubal/clair3:v2.0.1_gpu

WORKDIR /opt/bin
# Install dependencies
RUN apt-get update && apt-get install -y \
    procps \
    python3-dev

CMD run_clair3.sh --help