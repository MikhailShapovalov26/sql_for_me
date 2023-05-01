### Redis FDW

В данном разделе показанно как настроить Redis для кэширования данных и настроенно взаимодействие с базой данных POstgres.
Всё собранно в одном контейнере, что возможно не являеться отличным решением, но для ознакомления с инструментов и тестирования я думаю подойдет. 

Версия Postgres 15 </br>
Redis Redis server v=6.0.16 sha=00000000:0 malloc=jemalloc-5.2.1 bits=64 build=6d95e1af3a2c082a

В данном примере логин <b>example</b> пароль <b>example</b>, логин указан в mapping!



    CREATE EXTENSION redis_fdw;

    select * from pg_catalog.pg_available_extensions
    where installed_version  is not null

    create server redis_server
    foreign data wrapper redis_fdw
    options (address 'localhost', port '6379')

    create user mapping for example
    server redis_server;

    create foreign table myredishash (key text, val text[])
    server redis_server
    Options(database '0', tabletype 'hash', tablekeyprefix 'mytable:');

    insert into myredishash (key, val)
    values ('mytable:t1','{prop1,val1,prop2,val2}')

    insert into myredishash (key, val)
    values ('mytable:t2','{key1,val1,key,val2}')

    select * from myredis_list ml 

    CREATE FOREIGN TABLE myredis_list (val text)
    SERVER redis_server
    OPTIONS (database '1', tabletype 'list', singleton_key 'mylist');

    INSERT INTO myredis_list (val)
    VALUES ('a b c d'),('Hello world!');