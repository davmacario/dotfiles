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
COPY ./sync_user.sh /sync_user.sh
RUN /sync_user.sh --user ${USERNAME} --uid ${USER_UID} --gid ${USER_GID} && \
    rm /sync_user.sh
