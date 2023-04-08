# PostgreSQL Extensions
## 1.
### postgres_fdw

Расширение позволяет обращаться к внешним СУБД, файлам и веб-сервисам:

- Можно получать данные из нескольких баз, не используя сторонние инструменты.
- Пригодится для шардинга, где нужно поделить одну большую базу данных на несколько инстансов в вертикальной или горизонтальной логике.
- Поможет провести бесшовную миграцию с одной базы данных на другую или объединить несколько БД.
- Готовые FDW (foreign-data wrappers) есть у MySQL, Redis, MongoDB, ClickHouse, Kafka и других СУБД. 

Делаем отдельную схему для тестирвоания

    create schema test_fdw;

Проверяем установленные модули в моем экземпляре postgreSQL

    select *
    from pg_catalog.pg_available_extensions 
    where installed_version is not null 
Вывод

    plpgsql	1.0	1.0	PL/pgSQL procedural language
    postgres_fdw	1.1	1.1	foreign-data wrapper for remote PostgreSQL servers

Для установки postgres_fdw	потребуется команда

    create extension postgres_fdw 

Далее создаем server для настройки соединения между базами данных

    create server pfdw_ 
    foreign data wrapper postgres_fdw --какую обертку будем использовать
    options (host '127.0.0.1', port '5433', dbname 'netology')

Далее указываем какую учетную запись будем использовать для подключения

    create user mapping for postgres 
    server pfdw_
    options (user 'Логин', password 'Пароль тут')

Далее необходимо создать аналогичную таблицу, к которой мы подключимся и продублируем данные, сразу пролписываем зависимости от server схемы данных и именни таблицы.

    CREATE foreign table test_fdw.out_person (
        person_id       int4,
        first_name      varchar(250) ,
        middle_name     varchar(250),
        last_name       varchar(250),
        taxpayer_number varchar(40),
        dob             date)
    server pfdw_
    options (schema_name 'hr', table_name 'person')

Далее проверяем в новой схеме актуальность данных

    SELECT person_id, first_name, middle_name, last_name, taxpayer_number, dob
    FROM test_fdw.out_person;

Далее запрос с использованием join

    select op.first_name, op.middle_name, op.last_name, p.pos_title, p.pos_category, p.grade 
    from test_fdw.out_person op
    join hr.employee em on em.person_id=op.person_id
    join hr."position" p on em.pos_id=p.pos_id
    where p.grade is not null
    order by  op.first_name desc

![result](./img/join_1_1.png)

