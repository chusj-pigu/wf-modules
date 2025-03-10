# Use Debian as the base image
FROM debian:latest

# Install dependencies
RUN apt update && apt install -y \
    build-essential \
    gcc g++ cmake \
    zlib1g-dev bzip2 libbz2-dev \
    liblzo2-dev liblz4-dev xz-utils liblzma-dev \
    libzstd-dev e2fsprogs libattr1-dev \
    libaio-dev libgcrypt-dev \
    curl wget tar autoconf automake libtool \
    git pkg-config \
    gettext

# Set working directory
WORKDIR /opt

# Download and compile libthreadar
RUN git clone https://github.com/Edrusb/libthreadar.git

WORKDIR /opt/libthreadar
RUN git checkout branch_1.5.x
RUN misc/init
RUN ./configure --prefix=/opt
RUN make -j$(nproc) && make install

# Ensure the library path is known to the linker
RUN echo "/opt/lib" > /etc/ld.so.conf.d/libthreadar.conf && ldconfig

# Set environment variables
ENV LD_LIBRARY_PATH="/opt/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/opt/lib/pkgconfig:$PKG_CONFIG_PATH"

# Set working directory
WORKDIR /opt

# Download and compile DAR
RUN git clone https://github.com/Edrusb/DAR.git

WORKDIR /opt/DAR
RUN git checkout branch_2.7.x
RUN misc/init

# Configure with multithreading and threadar support
RUN ./configure --enable-threadar --enable-threads --prefix=/opt LDFLAGS="-L/opt/lib" CPPFLAGS="-I/opt/include"

# Compile and install DAR
RUN make -j$(nproc) && make install

# Add the binary path to the environment
ENV PATH="/opt/bin:${PATH}"

# Set working directory
WORKDIR /opt

# Set the default command
CMD ["dar", "--help"]
