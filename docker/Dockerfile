# Use the official Maven image with Java 21 as the build stage
FROM maven:3.9-eclipse-temurin-21 AS build

# Install Git (required to clone the repositories)
RUN apt-get update && apt-get install -y git \ 
    procps

# Clone SnpEff and SnpSift repositories
RUN git clone https://github.com/pcingola/SnpEff.git /root/workspace/SnpEff/
RUN git clone https://github.com/pcingola/SnpSift.git /root/workspace/SnpSift/

# Build SnpEff
WORKDIR /root/workspace/SnpEff/
RUN mvn clean install -DskipTests

WORKDIR /root/workspace/SnpEff/lib

# Antlr
RUN mvn install:install-file \
    -Dfile=antlr-4.5.1-complete.jar \
    -DgroupId=org.antlr \
    -DartifactId=antlr \
    -Dversion=4.5.1 \
    -Dpackaging=jar

# BioJava core
RUN mvn install:install-file \
    -Dfile=biojava3-core-3.0.7.jar \
    -DgroupId=org.biojava \
    -DartifactId=biojava3-core \
    -Dversion=3.0.7 \
    -Dpackaging=jar

# BioJava structure
RUN mvn install:install-file \
    -Dfile=biojava3-structure-3.0.7.jar \
    -DgroupId=org.biojava \
    -DartifactId=biojava3-structure \
    -Dversion=3.0.7 \
    -Dpackaging=jar

# Build SnpSift
WORKDIR /root/workspace/SnpSift/
RUN mvn clean install -DskipTests

# Create directory structure to run script_build
RUN mkdir -p /root/snpEff

# Create a symbolic link to the scripts_build directory
RUN ln -s /root/workspace/SnpEff/scripts_build /scripts_build

# Make the build script executable and run it
WORKDIR /root/workspace/SnpEff
RUN chmod +x /scripts_build/make.sh && /scripts_build/make.sh
