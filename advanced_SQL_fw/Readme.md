# Итоговый проект по курсу «Продвинутый SQL»
### 1-5

Создаём схему

    create schema public;

Подлкючаем модуль для генерации uuid-ossp

    CREATE EXTENSION "uuid-ossp";

Создаём таблицы: 
1. account:

        create table public.account (
            id uuid default uuid_generate_v4 () primary key,
            name varchar(30) not null
        );

2. contact:

        create table public.contact (
        id uuid default uuid_generate_v4 () primary key,
        last_name varchar(10) not null,
        first_name varchar(15),
        account_id uuid references account (id) not null
        );

3. user:

        create table public."user" (
            id uuid default uuid_generate_v4 () primary key,
            last_name varchar(10) not null,
            first_name varchar(15) not null,
            dismissed boolean  default false
        );

4. Создаём type enum

        create type status_type as enum ('В очереди','Выполняется','Выполнено','Отменен')

5. courier:

        create table public.courier (
        id uuid default uuid_generate_v4 () primary key,
        from_place varchar(50) not null,
        where_place varchar(50) not null,
        name varchar(15) not null,
        account_id uuid references account (id) not null,
        contact_id uuid references contact (id) not null,
        description text,
        user_id uuid references "user" (id) not null,
        status status_type default 'В очереди', -- статусы
        created_date date default now()
        );
        
### 6. Необходимо реализовать процедуру insert_test_data(value), которая принимает на вход целочисленное значение.

    Create or replace procedure insert_test_data(value int)
    language plpgsql
    as $$
    declare
    begin
        for counter in 1..value loop
        insert into public.account(name) values((select ('{Google,YAndex,AWS,Postgres,Connect}'::text[])[ceil(random()*5)]));
        end loop;
        for counter in 1..value*2 loop
        insert into public.contact(last_name,first_name,account_id) 
        values(
        (select ('{Мурка,НеМурка,Полина,Иван,Семён}'::text[])[ceil(random()*5)]),
        (select ('{Мурковна,НеМурковна,Полиновская,Иванов,Семёновна}'::text[])[ceil(random()*5)]),
        (select a.id  from account as a order by random() limit 1)
        );
        end loop;
        for user in 1..value loop
        insert into public."user"(last_name,first_name,dismissed)
        values(
        (select ('{КУрьер_1,КУрьер_2,КУрьер_3,КУрьер_4,КУрьер_5}'::text[])[ceil(random()*5)]),
        (select ('{Иванов,Петров,Сидоров,Смирнов,Семёнов}'::text[])[ceil(random()*5)]),
        (select ('{0,1}'::bool[])[ceil(random()*2)])
        );
        end loop;
        for counter in 1..value*5 loop
            insert into public.courier(from_place,where_place,name,account_id,contact_id,description,user_id,status,created_date) 
            values (
            (select ('{Москва Красная площадь д 3,Москва НеКрасная площадь д 30,СПБ Эрмитаж,Самара жд вокзал,Эстония д 6}'::text[])[ceil(random()*5)]),
            (select ('{Сочи Сочинская д 3,Дом родной,СПБ Эрмитаж переулок 6,Воркута ул Холод 16,Луна д 6}'::text[])[ceil(random()*5)]),
            (select ('{БУмага важная,бумага неважная,Заявление,ОТвет,Распоряжение}'::text[])[ceil(random()*5)]),
            (select a.id  from account as a order by random() limit 1),
            (select c.id  from contact as c order by random() limit 1),
            (select ('{Мурка,НеМурка,Полина,Иван,Семён}'::text[])[ceil(random()*5)]),
            (select us.id  from public."user"  as us order by random() limit 1),
            (select status from unnest(enum_range(NULL::status_type )) status ORDER BY random() LIMIT 1),
            (now() - '1 years'::interval * random())
            );
        end loop;
        commit;
    end; $$

### 7. Необходимо реализовать процедуру erase_test_data(), которая будет удалять тестовые данные из отношений

    create or replace procedure erase_test_data()
    language plpgsql
    as $$
    begin
        truncate public.courier, public."user", public.contact, public.account  CASCADE;
        commit;
    end; 
    $$

#### 8.  Необходимо реализовать функцию по добавлению новой записи о заявке на курьера, необходимо реализовать процедуру для запеси данных.

    create or replace procedure  add_courier(from_place varchar(50), where_place varchar(50), name varchar(15), 
    account_id  uuid, contact_id uuid, description text, user_id uuid)
    as $$
        begin
            insert into public.courier(from_place,where_place,name,
            account_id,contact_id,description,user_id) 
            values (from_place, where_place, name, 
            account_id, contact_id, description, user_id);
        end; 
    $$ language plpgsql;

#### 9. Реализовать функцию по получению записей о заявках на курьера

    create or replace function  get_courier()
    RETURNS table(id uuid, from_place varchar(50), where_place varchar(50),
    name varchar(15), account_id uuid, account varchar(30), contact_id uuid, contact text, 
    description text, user_id uuid, "user"  text, status status_type, created_date date ) as $$
    begin 
        return query 	
        select cou.id, cou.from_place ,cou.where_place, cou."name",
        cou.account_id, a."name", 
        cou.contact_id, (con.first_name || ' ' || con.last_name )::text as contact,
        cou.description text, 
        cou.user_id uui, (us_.first_name || ' ' || us_.last_name )::text as "user",
        cou.status status_type, cou.created_date date 
        from public.courier as cou
        join public.account as a on cou.account_id=a.id
        join public.contact as con on cou.contact_id = con.id
        join public."user" as us_ on cou.user_id = us_.id
        order by cou.status, cou.created_date desc; 
    end; 
    $$ language plpgsql;

####  10. Реализовать функция по изменению статуса заявки.

    create or replace procedure change_status(status_ status_type, id_ uuid)
    as $$
    begin 
        update public.courier set status = status_ where id = id_;
    end; 
    $$ language plpgsql;


#### 11. Функция получения списка сотрудников компании  get_users(). user --фамилия и имя сотрудника через пробел  Сотрудник должен быть действующим! Сортировка должна быть по фамилии сотрудника.

    create or replace function get_users() RETURNS table(user text) 
    as $$
    begin 
        return query select (u.last_name || ' ' || u.first_name)::text
        from "user" u where u.dismissed = true
        order by u.first_name asc;
    end; 
    $$ language plpgsql;

#### 12. Реализовать функцию получения списка контрагентов.

    create or replace function  get_accounts() RETURNS table(account text) 
    as $$
    begin 
        return query select (a."name")::text
        from account a group by a."name" order by a."name"  asc;
    end; 
    $$ language plpgsql;

#### 13. Реализовать функцию получения списка контактов.

    create or replace function  get_contacts(account_id_ text)
    RETURNS table(contact text) as $$
    begin 
        if  account_id_ is null   then
        RAISE INFO 'Выберите контрагента';
        end if; 
        return query select (c.first_name || ' ' || c.last_name  )::text
        from contact c  where c.account_id = account_id_::uuid
        order by c.first_name asc ;
    end; 
    $$ language plpgsql;

#### 14. Реализовать функцию по получению статистики о заявках на курьера


    select ac.id as account_id, ac."name" as account, count(cou.user_id) as count_courier
    ,count(case when cou.status = 'Выполнено' then 1 else null end) as count_complete
    ,count(case when cou.status = 'Отменен' then 1 else null end) as count_canceled
    ,count(cou.from_place) as count_where_place
    ,count(cou.contact_id) as count_contact
    ,array_agg(distinct cou.user_id) filter (where cou.status = 'Отменен') as cansel_user_array	
    from public.account as ac
    join courier as cou on ac.id = cou.account_id
    group by ac.id
