FROM python:3.10.15

# Install dependencies
RUN apt update && apt install -y \
    procps \
    git \
    && apt-get clean 

WORKDIR /opt/app

RUN pip3 install pysam>=0.21.0 \
     edlib>=1.3.9 \
     psutil>=5.9.4 \
     sniffles

ENV PATH /opt/app/:$PATH

RUN git clone https://github.com/fritzsedlazeck/Sniffles && \
    mv Sniffles/annotations/*.bed /opt/app && \
    rm -r Sniffles

CMD ["bash"]