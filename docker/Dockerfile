FROM python:latest

RUN apt-get update && apt-get install -y \
    procps \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip
RUN pip install tk
RUN pip install figeno 

RUN figeno --version > /opt/version.txt

CMD ["figeno"]