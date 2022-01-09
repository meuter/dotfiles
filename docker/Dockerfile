FROM alpine:edge

ARG username

ARG USER_ID
ARG USER_NAME
ARG GROUP_ID
ARG GROUP_NAME

RUN apk update && apk upgrade && apk add \
    neovim \
    bash \
    sudo \
    starship \
    git

RUN echo "%${USER_NAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN sed -i 's,/bin/ash,/bin/bash,g' /etc/passwd
RUN addgroup -g ${GROUP_ID} ${GROUP_NAME}
RUN adduser -s /bin/bash -G ${GROUP_NAME} -u ${USER_ID} $USER_NAME -D

COPY docker/bashrc /home/${USER_NAME}/.bashrc
COPY starship/.config/starship.toml /home/${USER_NAME}/.config/staship.toml

RUN chown -R ${USER_NAME}:${GROUP_NAME} /home/${USER_NAME}

USER $USER_NAME
CMD /bin/bash
