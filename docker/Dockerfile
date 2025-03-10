# Use Debian as the base image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /opt

# Copy the current directory contents into the container at /opt
COPY alma /opt/alma

RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r /opt/alma/reqs.txt

RUN cp -r /opt/alma/models \ 
    /usr/local/lib/python3.9/site-packages/alma_classifier/

# Make alias for bed_to_pickle.py
RUN echo "alias bed_to_pickle='python /opt/alma/scripts/bed_to_pickle.py'" >> ~/.bashrc

CMD [ "alma-classifier" ]