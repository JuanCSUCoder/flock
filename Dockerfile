FROM juancsucoder/bun_opencode

RUN apk add git
RUN git config --global user.name "Flock Agent" && git config --global user.email "agent@flock.local"

ARG USER_NAME=agent
ARG USER_UID=1000
ARG USER_GID=1000

# Create group (-g 1000) and user (-u 1000, -D = don't assign password)
RUN addgroup -g $USER_GID $USER_NAME \
    && adduser -u $USER_UID -G $USER_NAME -s /bin/sh -D $USER_NAME

# Set the active user and home directory
USER $USER_NAME

WORKDIR /worktree

ENTRYPOINT [ "opencode" ]
