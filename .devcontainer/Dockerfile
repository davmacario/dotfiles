FROM ubuntu:24.04

# Args passed via devcontainer json
ARG USERNAME
ARG USER_UID
ARG USER_GID

USER root

RUN export DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install --no-install-recommends \
    ca-certificates \
    tar \
    curl \
    zip \
    unzip \
    sudo \
    git && \
    apt autoremove -y

# Remove default user ubuntu and create custom user (w/ passwordless sudo)
RUN userdel -r ubuntu && \
    groupadd -g ${GID} ${USERNAME} && \
    useradd -u ${UID} -g ${GID} -G sudo -m -s /bin/bash ${USERNAME}
RUN mkdir -p "/etc/sudoers.d" && \
    echo "$USERNAME ALL=(ALL:ALL) NOPASSWD: ALL" | tee "/etc/sudoers.d/$USERNAME"
