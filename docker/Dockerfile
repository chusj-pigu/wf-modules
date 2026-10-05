FROM python:3.9-slim-bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    procps \
    wget \
 && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/UMCUGenetics/sturgeon
WORKDIR /sturgeon

RUN python -m venv venv
RUN ./venv/bin/pip install --upgrade pip
RUN ./venv/bin/pip install .

# Install the model to call it by name
RUN wget https://www.dropbox.com/s/yzca4exl40x9ukw/general.zip?dl=0 -O general.zip
RUN wget https://www.dropbox.com/s/55hypw7i8tidr0a/brainstem.zip?dl=1 -O brainstem.zip

RUN mv *.zip sturgeon/include/models

ENV PATH="/sturgeon/venv/bin:${PATH}"
