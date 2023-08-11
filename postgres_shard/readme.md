# Шардирование в Postgres в Docker

1)

- Делаем docker-compose.yml

- Далее неообходимо pg_hba.conf  прописать зависимости между разными базами данных. В каждом докер контейнере я прописал

        host test test Хост имя контейнера md5

- Далее необходимо загрузить единый дамп памяти в 3 бд, чтоб они были по единому подобию.

- И далее требуется выполнить скрипты ниже на главной БД, в которую не будет идти запись. 

        CREATE EXTENSION postgres_fdw;
        CREATE EXTENSION

        CREATE SERVER news_1_s FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'postgresdb_2', dbname 'test');
        CREATE SERVER

        CREATE SERVER news_2_s FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'postgresdb_3', dbname 'test');
        CREATE SERVER

        CREATE USER MAPPING FOR test SERVER news_1_s OPTIONS (user 'test', password 'test');
        CREATE USER MAPPING

        CREATE USER MAPPING FOR test SERVER news_2_s OPTIONS (user 'test', password 'test');
        CREATE USER MAPPING

        CREATE FOREIGN TABLE public.orders_1 (
            id integer NOT NULL,
            title character varying(80) NOT NULL,
            price integer DEFAULT 0
        )
        SERVER news_1_s
        OPTIONS (schema_name 'public', table_name 'orders');
        CREATE FOREIGN TABLE

        CREATE FOREIGN TABLE public.orders_2 (
            id integer NOT NULL,
            title character varying(80) NOT NULL,
            price integer DEFAULT 0
        )
        SERVER news_2_s
        OPTIONS (schema_name 'public', table_name 'orders');
        CREATE FOREIGN TABLE

        CREATE VIEW orders AS SELECT * FROM orders_1 UNION ALL SELECT * FROM orders_2;
        ERROR:  relation "orders" already exists

        CREATE RULE new_insert AS ON INSERT TO orders DO INSTEAD NOTHING;
        CREATE RULE

        CREATE RULE new_update AS ON UPDATE TO orders DO INSTEAD NOTHING;
        CREATE RULE

        CREATE RULE new_delete AS ON DELETE TO orders DO INSTEAD NOTHING;
        CREATE RULE

        CREATE RULE new_insert_to_1 AS ON INSERT TO orders WHERE (price >499) DO INSTEAD INSERT INTO orders_1 VALUES (NEW.*);
        CREATE RULE

        CREATE RULE new_insert_to_2 AS ON INSERT TO orders WHERE (price <= 499) DO INSTEAD INSERT INTO orders_2 VALUES (NEW.*);
        CREATE RULE
- И далее тестируем

        INSERT INTO orders ( id, title, price) VALUES (9, 'TEST', 700)

![Screenshot](rezultat/rezultat)