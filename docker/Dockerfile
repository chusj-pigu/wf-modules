FROM python:latest

# Install dependencies
RUN apt update && apt install -y \
    build-essential \
    python3-dev \
    procps \
    && apt-get clean 

WORKDIR /opt/app

RUN pip3 install whatshap

ENV PATH /opt/app/:$PATH

CMD ["bash"]