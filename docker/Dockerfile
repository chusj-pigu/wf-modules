FROM ubuntu:20.04

RUN DEBIAN_FRONTEND=noninteractive apt-get -y update && \
    apt-get install -y tzdata && \
    ln -fs /usr/share/zoneinfo/America/Montreal /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

RUN	DEBIAN_FRONTEND=noninteractive apt-get install -y locales && rm -rf /var/lib/apt/lists/* && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install perl-base
RUN	DEBIAN_FRONTEND=noninteractive apt-get -y update && apt-get -y install libvcflib-tools libvcflib-dev
RUN	DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install software-properties-common -y
RUN	DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:deadsnakes/ppa
RUN	DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y install python3.10 python3.10-venv python3.10-dev
RUN	python3.10 -m ensurepip --upgrade
RUN	python3.10 -m pip install pandas
RUN	export PATH="$PATH:/opt/annovar"

## You will need to download a copy of annovar by requesting the author's permission on this page: 
##    https://www.openbioinformatics.org/annovar/annovar_download_form.php

COPY annovar/ /opt/annovar
RUN	chmod -R o+rx /opt/annovar/



ENV	LANG=en_US.UTF-8
ENV	PATH=$PATH:/opt/annovar