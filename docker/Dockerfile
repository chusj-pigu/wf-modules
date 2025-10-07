FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    git \
    python3.9 \
    python3-pip \
    python3.9-venv

RUN git clone https://github.com/marcpaga/sturgeon
WORKDIR /sturgeon

RUN python3.9 -m venv venv
RUN ./venv/bin/pip install --upgrade pip
RUN ./venv/bin/pip install .

ENV PATH="/sturgeon/venv/bin:${PATH}"
