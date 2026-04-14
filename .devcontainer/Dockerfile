FROM ubuntu:24.04

ARG USERNAME

USER root

RUN export DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt-get -y install --no-install-recommends \
    ca-certificates \
    tar \
    curl \
    zip \
    unzip \
    sudo \
    git && \
    apt autoremove -y

RUN useradd -ms /bin/bash $USERNAME && usermod -aG sudo $USERNAME
RUN mkdir -p "/etc/sudoers.d" && \
    echo "$USERNAME ALL=(ALL:ALL) NOPASSWD: ALL" | tee "/etc/sudoers.d/$USERNAME"
