FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    git \
    procps \
    wget \
    zip \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/UMCUGenetics/tucan.git
WORKDIR /tucan

RUN python -m venv venv
ENV PATH="/tucan/venv/bin:${PATH}"

RUN pip install --upgrade pip
RUN pip install . huggingface_hub

RUN python -c "from src.tucan.download_model import get_model; print(get_model())"

RUN cd models && zip -r model.zip model && rm -r model