FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    git \
    python3.9 \
    python3-pip \
    python3.9-venv \
    procps \
    wget

RUN git clone https://github.com/UMCUGenetics/sturgeon
WORKDIR /sturgeon

RUN python3.9 -m venv venv
RUN ./venv/bin/pip install --upgrade pip
RUN ./venv/bin/pip install .

# Install the model to call it by name
RUN wget https://www.dropbox.com/s/yzca4exl40x9ukw/general.zip?dl=0 -O general.zip

RUN mv *.zip sturgeon/include/models

ENV PATH="/sturgeon/venv/bin:${PATH}"
