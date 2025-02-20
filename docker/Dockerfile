# Use the official Arch Linux base image
FROM archlinux:latest

# Install dependencies for building AUR packages
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
        base-devel \
        git \
        procps \
        wget \
        curl

# Create a non-root user and switch to it
RUN useradd -m -s /bin/bash builder && \
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Switch to the non-root user
USER builder
WORKDIR /home/builder

# Install yay (AUR helper)
RUN git clone https://aur.archlinux.org/yay.git && \
    cd yay && \
    makepkg -si --noconfirm && \
    cd .. && \
    rm -rf yay

# Install mosdepth from AUR
RUN yay -S --noconfirm mosdepth
USER root

# Default command (optional)
CMD ["mosdepth", "--help"]