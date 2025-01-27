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

WORKDIR /opt/
COPY scripts scripts
RUN chmod +x /opt/scripts/*
ENV PATH="/opt/scripts:${PATH}"

# Add aliases to Bash
RUN echo "alias nickls='eza -l --sort=time --reverse --time-style=long-iso --tree --all --level=2 -g'" >> /root/.bashrc && \
    echo "alias nicklss='eza -l --sort=time --reverse --time-style=long-iso --tree --level=2 -g'" >> /root/.bashrc && \
    echo "alias nicklsd='eza -l --sort=time --reverse --time-style=long-iso --tree --all --level=3 -g'" >> /root/.bashrc && \
    echo "alias nicklsdd='eza -l --sort=time --reverse --time-style=long-iso --tree --all --level=4 -g'" >> /root/.bashrc

# Prepare Nushell user configuration
RUN mkdir -p /root/.config/nushell && \
    touch /root/.config/nushell/config.nu

# Add aliases to Nushell user config
RUN echo "alias nickls = eza -l --sort=time --reverse --time-style=long-iso --tree --all --level=2 -g" >> /root/.config/nushell/config.nu && \
    echo "alias nicklss = eza -l --sort=time --reverse --time-style=long-iso --tree --level=2 -g" >> /root/.config/nushell/config.nu && \
    echo "alias nicklsd = eza -l --sort=time --reverse --time-style=long-iso --tree --all --level=3 -g" >> /root/.config/nushell/config.nu && \
    echo "alias nicklsdd = eza -l --sort=time --reverse --time-style=long-iso --tree --all --level=4 -g" >> /root/.config/nushell/config.nu

SHELL ["/usr/local/cargo/bin/nu", "-c"]

RUN [ nu_plugin_inc \
nu_plugin_polars \
nu_plugin_gstat \
nu_plugin_formats \
nu_plugin_query \
] | each { cargo install $in --locked } | ignore

RUN  ls --full-paths  /usr/local/cargo/bin/nu_plugin_* | get name | each { |$it| plugin add $it } 

RUN  plugin use polars
RUN  plugin use gstat
RUN  plugin use formats
RUN  plugin use query

ENV export NU_PLUGIN_DIRS=/usr/local/cargo/bin