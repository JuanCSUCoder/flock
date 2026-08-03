FROM juancsucoder/bun_opencode

RUN apk add git
RUN git config --global user.name "Flock Agent" && git config --global user.email "agent@flock.local"

ENTRYPOINT [ "opencode" ]
