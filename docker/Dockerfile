FROM rockylinux/rockylinux:9.1

RUN dnf -y update && \
    dnf -y install \
    wget \
    bzip2 \
    python3-devel \
    python3-pip \
    gcc-c++ \
    procps

WORKDIR /opt/
RUN mkdir -p miniconda3
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda3/miniconda.sh
RUN chmod +xw /opt/miniconda3/miniconda.sh
RUN  /opt/miniconda3/miniconda.sh -b -u -p /opt/miniconda3
RUN rm -rf /opt/miniconda3/miniconda.sh
RUN /opt/miniconda3/bin/conda init bash
RUN /opt/miniconda3/bin/conda init zsh

ENV PATH=/opt/miniconda3/bin:${PATH}

RUN conda install -c bioconda seqkit
RUN seqkit version

CMD [ "seqkit" ]