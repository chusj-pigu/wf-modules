FROM rust:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    # DONE: Install procps for NextFlow
    procps \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/
RUN git clone https://github.com/bwbioinfo/rs-chromplotter.git

WORKDIR /opt/rs-chromplotter
RUN  cargo install --path .

# DONE: Make an alias to get version
RUN chromplotter --version > /opt/version
RUN cat /opt/version

# Add the command to run the executable
CMD ["chromplotter"]
