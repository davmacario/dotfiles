FROM ubuntu:24.04

ARG USERNAME=user
ARG REPO_DOTFILES
ARG ENTRYPOINT="./setup.sh"
ARG CUSTOM_BRANCH="main"
ARG NVIM_VERSION

RUN apt update && apt install -y git sudo

RUN useradd -ms /bin/bash $USERNAME
RUN adduser $USERNAME sudo
RUN echo "$USERNAME ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/$USERNAME"
USER $USERNAME
WORKDIR "/home/$USERNAME"

COPY ./launch.sh /home/$USERNAME/launch.sh
RUN sudo chmod +x /home/$USERNAME/launch.sh
RUN /home/$USERNAME/launch.sh

# ENTRYPOINT [ "bash", "-c", "~/launch.sh" ]
