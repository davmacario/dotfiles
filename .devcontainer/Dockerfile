FROM ubuntu:24.04

ARG USERNAME

USER root

RUN export DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt-get -y install --no-install-recommends ca-certificates tar curl zip unzip git && \
    apt autoremove -y

RUN useradd -ms /bin/bash $USERNAME
RUN usermod -aG sudo $USERNAME
RUN mkdir "/etc/sudoers.d"
RUN echo "$USERNAME ALL=(ALL:ALL) NOPASSWD: ALL" | tee "/etc/sudoers.d/$USERNAME"
