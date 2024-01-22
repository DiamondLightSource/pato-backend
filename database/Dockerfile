FROM mariadb:10.9.4-jammy

WORKDIR /docker-entrypoint-initdb.d
RUN apt-get update -y && \
    apt-get install -y git && \
    git clone https://github.com/DiamondLightSource/ispyb-database && \
    mv ispyb-database/schemas/ispyb/tables.sql 1.sql && \
    mv ispyb-database/schemas/ispyb/lookups.sql 2.sql

ADD data.sql /docker-entrypoint-initdb.d/3.sql
RUN chown -R mysql:mysql /docker-entrypoint-initdb.d/

ENV MYSQL_ROOT_PASSWORD ispyb-root
ENV MYSQL_DATABASE ispyb
ENV MYSQL_USER ispyb
ENV MYSQL_PASSWORD ispyb-user

EXPOSE 3306

CMD ["mysqld"]