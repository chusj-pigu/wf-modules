FROM rust:latest

RUN apt-get update && apt-get install -y \
    procps \
    gnuplot \
    fd-find

RUN cargo install eza
RUN cargo install zoxide
RUN cargo install sd
RUN cargo install du-dust
RUN cargo install ripgrep
RUN cargo install bandwhich
RUN cargo install nu

RUN useradd -p '' -s /usr/local/cargo/bin/nu nushell \
    && mkdir -p /home/nushell/.config/nushell/ \
    # Setup default config file for nushell
    && cd /home/nushell/.config/nushell \
    && chmod +x /usr/local/cargo/bin/nu \
    && chown -R nushell:nushell /home/nushell/.config/nushell \
    # Reset Nushell config to default
    && su -c 'config reset -w' nushell \
    && ls /usr/local/cargo/bin/nu_plugin* \
    | xargs -I{} su -c 'plugin add {}' nushell \
    && rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/*

# Prepare Nushell user configuration
RUN mkdir -p /root/.config/nushell && \
    touch /root/.config/nushell/config.nu

RUN chown -R nushell:nushell /opt/
RUN chown -R nushell:nushell /usr/local/cargo

WORKDIR /opt/
RUN mkdir -p nu-plugins
COPY scripts scripts
RUN chmod a+x /opt/scripts/*
ENV PATH="/opt/scripts:${PATH}"

USER nushell

SHELL ["/usr/local/cargo/bin/nu", "-c"]

ENV NU_PLUGIN_DIRS='/opt/nu-plugins'
ENV PATH="/opt/scripts:${PATH}"

RUN [ nu_plugin_inc \
nu_plugin_polars \
nu_plugin_gstat \
nu_plugin_formats \
nu_plugin_query \
] | each { cargo install $in --locked } | ignore

RUN  ls --full-paths  /usr/local/cargo/bin/nu_plugin_* | get name | each { |$it| plugin add $it } 
