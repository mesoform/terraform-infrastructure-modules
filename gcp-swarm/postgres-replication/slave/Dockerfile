FROM postgres:10.6

ENV GOSU_VERSION 1.10

ADD ./gosu /usr/bin/
RUN chmod +x /usr/bin/gosu

COPY ./docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["gosu", "postgres", "postgres"]