FROM ubuntu:20.04

# build arguments
ARG USER_ID
ARG USER_NAME
ARG GROUP_ID
ARG GROUP_NAME

# install dependencies
RUN apt-get update && apt-get -y install --no-install-recommends \
    sudo \
    curl \
    git \
    python3 \
    python3-pip \
    python3-venv \
    python-is-python3 \
    libfile-copy-recursive-perl \
    build-essential \
    unzip

# create user, group and add as sudo
RUN groupadd -g ${GROUP_ID} ${GROUP_NAME}
RUN useradd -s /bin/bash -g ${GROUP_NAME} -u ${USER_ID} ${USER_NAME}
RUN echo "%${USER_NAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}/

# install
COPY . .dotfiles
RUN sudo chown ${USER_NAME}:${GROUP_NAME} -R .dotfiles
RUN sudo rm -rf .dotfiles/.git
RUN touch .bashrc
RUN cd .dotfiles && ./install.sh all






