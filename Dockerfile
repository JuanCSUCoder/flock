FROM juancsucoder/bun_opencode

RUN apk add git

ENTRYPOINT [ "opencode" ]
