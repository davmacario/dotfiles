FROM ubuntu:24.04

# Args passed via devcontainer json
ARG USERNAME
ARG USER_UID=1000
ARG USER_GID=1000

USER root

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install -y --no-install-recommends \
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
    groupadd --gid=${USER_GID} ${USERNAME} && \
    useradd --create-home --shell /bin/bash --gid ${USERNAME} --groups sudo --uid=${USER_UID} ${USERNAME}
RUN mkdir -p "/etc/sudoers.d" && \
    echo "$USERNAME ALL=(ALL:ALL) NOPASSWD: ALL" | tee "/etc/sudoers.d/$USERNAME"
