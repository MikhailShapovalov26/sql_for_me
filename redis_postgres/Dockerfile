FROM postgres:15.2
ENV POSTGRES_PASSWORD example
ENV POSTGRES_USER example
ENV export PATH=/usr/lib/postgresql/15/bin:$PATH
RUN apt update \
    && apt install -y redis \
                      git \
                      make \
                      gcc \
                      vim \
                      postgresql-server-dev-15 \
    && git clone https://github.com/pg-redis-fdw/redis_fdw.git 
RUN mkdir -p docker-entrypoint-initdb.d
WORKDIR /redis_fdw
RUN git checkout REL_15_STABLE \
     && echo "LDFLAGS += -L/usr/lib/postgresql/15/hiredis_bin/lib" >> ./Makefile

RUN pg_createcluster 15 cluster  
COPY ./conf/pg_hba.conf  /etc/postgresql/15/cluster/pg_hba.conf
USER postgres
RUN /etc/init.d/postgresql start  \
    && psql --command "CREATE role $POSTGRES_USER WITH password '$POSTGRES_PASSWORD';" \
    && psql --command "ALTER ROLE $POSTGRES_USER WITH LOGIN;" \
    && psql --command "ALTER USER $POSTGRES_USER CREATEDB;" \
    && psql --command "ALTER ROLE $POSTGRES_USER SUPERUSER;" 
USER root
RUN git clone https://github.com/redis/hiredis \
    && cd hiredis \
    && make PREFIX=/usr/lib/postgresql/15/hiredis_bin install \
    && cd .. \
    && PATH=/usr/lib/postgresql/15/bin:$PATH make USE_PGXS=1 \
    && PATH=/usr/lib/postgresql/15/bin:$PATH make USE_PGXS=1 install \
    && echo "/usr/lib/postgresql/15/hiredis_bin/lib" >> /etc/ld.so.conf \
    && ldconfig
ENTRYPOINT  /etc/init.d/postgresql restart && /etc/init.d/redis-server restart && tail -f /dev/null
# ENTRYPOINT ["sleep", "infinity" ]