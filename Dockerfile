FROM ghcr.io/anomalyco/opencode

# 1. Install CLI tools including docker-cli
RUN apk add --no-cache curl bash git docker-cli

ARG USER_NAME=agent
ARG USER_UID=1000
ARG USER_GID=1000
ARG DOCKER_GID=999

# 2. Create agent user and a docker group for socket access
RUN addgroup -g $USER_GID $USER_NAME \
    && adduser -u $USER_UID -G $USER_NAME -s /bin/bash -D $USER_NAME \
    && addgroup -g $DOCKER_GID docker \
    && addgroup $USER_NAME docker

# 3. Pre-create directories and set ownership
RUN mkdir -p /home/agent/.local/state /home/agent/.local/share /home/agent/.config /home/agent/worktree \
    && chown -R $USER_UID:$USER_GID /home/agent

# Set the active user
USER $USER_NAME

WORKDIR /home/agent/worktree

RUN curl -fsSL https://bun.sh/install | bash

ENV PATH="/home/agent/.bun/bin:${PATH}"

RUN git config --global user.name "Flock Agent" && git config --global user.email "agent@flock.local"

ENTRYPOINT [ "opencode" ]
