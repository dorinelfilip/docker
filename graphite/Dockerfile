FROM alpine:3.5

RUN apk add --update-cache     \
        ca-certificates        \
        libffi-dev             \
        py-pip                 \
        py-cairo               \
    && rm -rf /var/cache/apk/*

RUN apk add --update-cache --virtual=build-deps                                    \
        gcc                                                                        \
        python-dev                                                                 \
        musl-dev                                                                   \
    && apk add --update-cache nginx                                                \
    && pip install --upgrade pip && pip install gunicorn                           \
    && pip install scandir                                                         \
    && pip install supervisor supervisor-stdout                                    \
    && pip install https://github.com/graphite-project/graphite-web/archive/1.0.1.tar.gz \
    && pip install https://github.com/graphite-project/whisper/archive/1.0.1.tar.gz \
    && pip install https://github.com/graphite-project/carbon/archive/1.0.1.tar.gz \
    && rm -rf /opt/graphite/conf/*.example                                         \
    && apk del build-deps                                                          \
    && rm -rf /var/cache/apk/*

COPY scripts /usr/local/bin/
COPY config /opt/graphite/initconfig
COPY config/supervisord.conf /etc/supervisord.conf

EXPOSE 2003 2004 80
VOLUME /opt/graphite/storage
VOLUME /opt/graphite/conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
