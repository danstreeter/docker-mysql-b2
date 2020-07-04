FROM alpine:3.12
LABEL MAINTAINER "Dan Streeter <dan@danstreeter.co.uk>"

RUN apk add --update mysql-client py-pip tzdata && \
    rm -rf /var/cache/apk/* && \
    pip install b2

# Correct the timezone to UK
RUN cp /usr/share/zoneinfo/Europe/London /etc/localtime
RUN echo "Europe/London" >  /etc/timezone
RUN apk del tzdata

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

CMD ["/usr/local/bin/docker-entrypoint.sh"]

