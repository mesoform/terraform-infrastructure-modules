FROM postgres:10.6

COPY ./setup-master.sh /docker-entrypoint-initdb.d/setup-master.sh

RUN chmod 0666 /docker-entrypoint-initdb.d/setup-master.sh