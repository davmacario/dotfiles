FROM ubuntu:24.04

ARG USERNAME

USER root

RUN export DEBIAN_FRONTEND=noninteractive
RUN apt update && apt autoremove -y
RUN apt-get -y install --no-install-recommends tar curl zip unzip

RUN useradd -ms /bin/bash $USERNAME
RUN usermod -aG sudo $USERNAME
RUN mkdir "/etc/sudoers.d"
RUN echo "$USERNAME ALL=(ALL:ALL) NOPASSWD: ALL" | tee "/etc/sudoers.d/$USERNAME"
