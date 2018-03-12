#
# Dockerfile for alpine-builder
#
FROM alpine:3.7
LABEL maintainer "jar3b <hellotan@live.ru>"
RUN apk add --no-cache alpine-sdk libressl-dev mariadb-dev postgresql-dev gdbm-dev readline-dev bash libtool autoconf \
    automake perl-dev python2-dev openldap-dev krb5-dev unixodbc-dev linux-pam-dev sqlite-dev talloc-dev libpcap-dev \
    linux-headers curl-dev hiredis-dev json-c-dev sudo
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