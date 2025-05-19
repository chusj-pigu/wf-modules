FROM python:latest

# Install dependencies
RUN apt-get install procps \
    libssl-dev
# Set working directory
WORKDIR /opt
COPY requirements.txt /opt/requirements.txt
# Clone repo
RUN git clone https://github.com/treangenlab/methphaser.git
# Install requirements
RUN pip install -r requirements.txt
# Add to path
