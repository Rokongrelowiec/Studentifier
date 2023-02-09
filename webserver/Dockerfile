FROM dart:stable-sdk

ADD . $HOME/studentifier-api
WORKDIR $HOME/studentifier-api

RUN /bin/bash -c 'dart pub get && \
                  dart --disable-analytics'


HEALTHCHECK --interval=5m --timeout=3s \
    CMD curl -f http://localhost:8069/healthcheck || return 1

ENTRYPOINT ["dart", "run", "bin/webserver.dart", "--port", "8069"]
