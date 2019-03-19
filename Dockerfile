#
# Dockerfile for alpine-builder
#
FROM alpine:3.8
LABEL maintainer "jar3b <hellotan@live.ru>"
RUN apk add --no-cache alpine-sdk bash libtool autoconf automake linux-headers sudo git
RUN adduser -D builder \
    && passwd -d builder \
    && echo "builder ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers \
    && addgroup builder abuild \
    && chgrp abuild /var/cache/distfiles \
    && chmod g+w /var/cache/distfiles \
    && su -c "abuild-keygen -a -i -n" builder \
    && mkdir /projects
USER builder
WORKDIR /projects