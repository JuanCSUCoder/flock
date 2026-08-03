FROM ghcr.io/anomalyco/opencode

# 1. Install CLI tools, docker, sudo, and doas
RUN apk add --no-cache curl bash git docker iptables sudo doas

ARG USER_NAME=agent
ARG USER_UID=1000
ARG USER_GID=1000

# 2. Create agent user and a docker group for socket access
RUN addgroup -g $USER_GID $USER_NAME \
    && adduser -u $USER_UID -G $USER_NAME -s /bin/bash -D $USER_NAME \
    && addgroup $USER_NAME docker

# 3. Configure passwordless sudo and doas for the agent user
RUN echo "$USER_NAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && echo "permit nopass $USER_NAME as root" > /etc/doas.conf

# 4. Pre-create directories and set ownership
RUN mkdir -p /home/agent/.local/state /home/agent/.local/share /home/agent/.config /home/agent/worktree \
    && chown -R $USER_UID:$USER_GID /home/agent

# Set the active user
USER $USER_NAME

WORKDIR /home/agent/worktree

RUN curl -fsSL https://bun.sh/install | bash

ENV PATH="/home/agent/.bun/bin:${PATH}"

RUN git config --global user.name "Flock Agent" && git config --global user.email "agent@flock.local"

ENTRYPOINT ["/bin/sh", "-c", "sudo -n dockerd --storage-driver=vfs >/dev/null 2>&1 & sleep 2 && exec opencode \"$@\"", "--"]
