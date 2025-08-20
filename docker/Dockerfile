FROM python:latest

RUN apt-get update && apt-get install -y \
    procps \
    parallel \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip
RUN pip install tk
RUN pip install figeno

RUN figeno --version > /opt/version.txt
COPY scripts/ /opt/scripts

RUN chmod +x /opt/scripts/*
ENV PATH="$PATH:/opt/scripts"

CMD ["figeno"]
