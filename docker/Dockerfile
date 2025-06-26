FROM rust:latest

# Install required system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libclang-dev llvm-dev clang ca-certificates curl build-essential \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install alignoth from crates.io
RUN cargo install alignoth --locked
