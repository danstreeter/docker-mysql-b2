FROM alpine:3.5
MAINTAINER Mitchell Hewes <me@mitcdh.com>

RUN apk add --update mysql-client py-pip && \
    rm -rf /var/cache/apk/* && \
    pip install b2

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

CMD ["/usr/local/bin/docker-entrypoint.sh"]

