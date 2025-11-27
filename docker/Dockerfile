FROM debian:bookworm-slim AS builder

ENV DEBIAN_FRONTEND=noninteractive
ARG INSTALL_PREFIX=/opt

ENV PATH="${INSTALL_PREFIX}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
    LD_LIBRARY_PATH="${INSTALL_PREFIX}/lib:/usr/local/lib:/usr/lib/x86_64-linux-gnu" \
    PKG_CONFIG_PATH="${INSTALL_PREFIX}/lib/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/share/pkgconfig"

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    autoconf \
    automake \
    build-essential \
    bzip2 \
    cmake \
    doxygen \
    curl \
    e2fsprogs \
    graphviz \
    g++ \
    gcc \
    gettext \
    git \
    groff \
    libaio-dev \
    libattr1-dev \
    libbz2-dev \
    libcurl4-openssl-dev \
    libext2fs-dev \
    libgcrypt-dev \
    librsync-dev \
    liblzo2-dev \
    liblz4-dev \
    liblzma-dev \
    libgpgme-dev \
    libtool \
    libzstd-dev \
    pkg-config \
    tar \
    wget \
    xz-utils \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR ${INSTALL_PREFIX}

RUN set -eux \
    && git clone https://github.com/Edrusb/libthreadar.git \
    && cd libthreadar \
    && misc/init \
    && ./configure --prefix="${INSTALL_PREFIX}" \
    && make -j"$(nproc)" \
    && make install \
    && echo "${INSTALL_PREFIX}/lib" > /etc/ld.so.conf.d/libthreadar.conf \
    && ldconfig

RUN set -eux \
    && git clone https://github.com/Edrusb/DAR.git \
    && cd DAR \
    && misc/init \
    && LDFLAGS="-L${INSTALL_PREFIX}/lib" \
    CPPFLAGS="-I${INSTALL_PREFIX}/include" \
    PKG_CONFIG_PATH="${INSTALL_PREFIX}/lib/pkgconfig" \
    ./configure \
    --enable-threadar \
    --enable-threads \
    --prefix="${INSTALL_PREFIX}" \
    && make -j"$(nproc)" \
    && make install

FROM debian:bookworm-slim AS runner

ENV DEBIAN_FRONTEND=noninteractive
ARG INSTALL_PREFIX=/opt

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    bzip2 \
    e2fsprogs \
    graphviz \
    libaio1 \
    libattr1 \
    libbz2-1.0 \
    libcurl4 \
    libext2fs2 \
    libgcrypt20 \
    librsync2 \
    liblzo2-2 \
    liblz4-1 \
    liblzma5 \
    libzstd1 \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder ${INSTALL_PREFIX} ${INSTALL_PREFIX}

RUN echo "${INSTALL_PREFIX}/lib" > /etc/ld.so.conf.d/libthreadar.conf && ldconfig

ENV LD_LIBRARY_PATH="${INSTALL_PREFIX}/lib" \
    PKG_CONFIG_PATH="${INSTALL_PREFIX}/lib/pkgconfig" \
    PATH="${INSTALL_PREFIX}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

WORKDIR ${INSTALL_PREFIX}

CMD ["dar", "--help"]
