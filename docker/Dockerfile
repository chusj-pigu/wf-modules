FROM hkubal/clair3:latest

WORKDIR /opt/bin
# Install dependencies
RUN apt-get update && apt-get install -y \
    procps

CMD run_clair3.sh --help