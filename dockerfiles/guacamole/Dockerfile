FROM jumpserver/jms_guacamole:1.4.8

ENV DOCKERIZE_VERSION=v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && chmod +x /usr/bin/dockerize    \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

ENV TINI_VERSION=v0.18.0
RUN wget -c https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-amd64 -O /usr/bin/tini \
    && chmod +x /usr/bin/tini

ADD entrypoint.sh /config/entrypoint.sh
RUN chmod +x /config/entrypoint.sh

ENTRYPOINT [ "tini", "--" ]
# CMD "dockerize -wait ${JUMPSERVER_SERVER} /config/entrypoint.sh"
# CMD [ "/config/entrypoint.sh" ]
CMD dockerize -wait ${JUMPSERVER_SERVER} /config/entrypoint.sh