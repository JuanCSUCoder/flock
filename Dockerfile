FROM ghcr.io/anomalyco/opencode

RUN apk add --no-cache curl bash git

ARG USER_NAME=agent
ARG USER_UID=1000
ARG USER_GID=1000

# Create group (-g 1000) and user (-u 1000, -D = don't assign password)
RUN addgroup -g $USER_GID $USER_NAME \
    && adduser -u $USER_UID -G $USER_NAME -s /bin/sh -D $USER_NAME

# Set the active user and home directory
USER $USER_NAME

WORKDIR /home/agent/worktree

RUN curl -fsSL https://bun.sh/install | bash

ENV PATH="/home/agent/.bun/bin:${PATH}"

RUN git config --global user.name "Flock Agent" && git config --global user.email "agent@flock.local"

ENTRYPOINT [ "opencode" ]
