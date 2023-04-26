SELECT table_name,column_name,data_type 
FROM information_schema.columns 
WHERE table_schema NOT IN ('pg_catalog', 'information_schema');

SELECT * FROM pg_available_extensions;

select usename from pg_catalog.pg_user;

CREATE USER netocourier WITH ENCRYPTED PASSWORD 'NetoSQL2022';

GRANT SELECT ON ALL TABLES IN SCHEMA public to netocourier;

GRANT SELECT ON ALL TABLES IN SCHEMA pg_catalog to netocourier;

create table public.account (
     id uuid default uuid_generate_v4 () primary key,
     name varchar(84) not null
 );

select char_length('Общество с ограниченной отвественностью Cургутнефтегаз')

create table public.contact (
 id uuid default uuid_generate_v4 () primary key,
 last_name varchar(30) not null,
 first_name varchar(55),
 account_id uuid references account (id) not null
 );
 
 create table public."user" (
     id uuid default uuid_generate_v4 () primary key,
     last_name varchar(30) not null,
     first_name varchar(55) not null,
     dismissed boolean  default false
 );
 
create type status_type as enum ('В очереди','Выполняется','Выполнено','Отменен')

 create table public.courier (
 id uuid default uuid_generate_v4 () primary key,
 from_place varchar(90) not null,
 where_place varchar(90) not null,
 name varchar(20) not null,
 account_id uuid references account (id) not null,
 contact_id uuid references contact (id) not null,
 description text,
 user_id uuid references "user" (id) not null,
 status status_type default 'В очереди', -- статусы
 created_date date default now()
 );

select char_length('165210, г. Санкт-Петербург Проспект Ветеранов д 800 парадная 10 кв 1000')


###############
Create or replace procedure insert_test_data(value int)
language plpgsql
as $$
declare
begin
    for counter in 1..value loop
    insert into public.account(name) values(
   (SELECT repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*39+1)::integer),(random()*1+1)::integer)));
    end loop;
    for counter in 1..value*2 loop
    insert into public.contact(last_name,first_name,account_id) 
    values(
    (SELECT repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*14+1)::integer),(random()*1+1)::integer)),
    (SELECT repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*25+1)::integer),(random()*1+1)::integer)),
    (select a.id  from account as a order by random() limit 1)
    );
    end loop;
    for user in 1..value loop
    insert into public."user"(last_name,first_name,dismissed)
    values(
    (SELECT repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*14+1)::integer),(random()*1+1)::integer)),
    (SELECT repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*25+1)::integer),(random()*1+1)::integer)),
    (select ('{0,1}'::bool[])[ceil(random()*2)])
    );
    end loop;
    for counter in 1..value*5 loop
        insert into public.courier(from_place,where_place,name,account_id,contact_id,description,user_id,status,created_date) 
        values (
        (SELECT repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*29+1)::integer),(random()*2+1)::integer)),
        (SELECT repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*29+1)::integer),(random()*2+1)::integer)),
        (SELECT repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*9+1)::integer),(random()*1+1)::integer)),
        (select a.id  from account as a order by random() limit 1),
        (select c.id  from contact as c order by random() limit 1),
        (SELECT repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*10+1)::integer),(random()*1+1)::integer)),
        (select us.id  from public."user"  as us order by random() limit 1),
        (select status from unnest(enum_range(NULL::status_type )) status ORDER BY random() LIMIT 1),
        (now() - '1 years'::interval * random())
        );
    end loop;
    commit;
end; $$

SELECT repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*33+1)::integer),(random()*9+1)::integer);

call insert_test_data(10)

create or replace procedure  add_courier(from_place varchar(90), where_place varchar(90), name varchar(84), 
account_id  uuid, contact_id uuid, description text, user_id uuid)
as $$
    begin
        insert into public.courier(from_place,where_place,name,
        account_id,contact_id,description,user_id) 
        values (from_place, where_place, name, 
        account_id, contact_id, description, user_id);
    end; 
$$ language plpgsql; --8

create or replace function  get_courier()
RETURNS table(id uuid, from_place varchar(90), where_place varchar(90),
name varchar(20), account_id uuid, account varchar(84), contact_id uuid, contact text, 
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
$$ language plpgsql;--9

create or replace procedure change_status(status_ status_type, id_ uuid)
as $$
begin 
    update public.courier set status = status_ where id = id_;
end; 
$$ language plpgsql; --10

create or replace function get_users() RETURNS table(user_ text) 
as $$
begin 
    return query select (u.last_name || ' ' || u.first_name)::text
    from "user" u where u.dismissed = false
    order by u.first_name asc;
end; 
$$ language plpgsql; --11 Исправил 

create or replace function  get_accounts() RETURNS table(account text) 
as $$
begin 
    return query select (a."name")::text
    from account a  order by a."name"  asc;
end; 
$$ language plpgsql; --12


create or replace function  get_contacts(uuid)
RETURNS SETOF text
language plpgsql
as $$
begin 
	  IF  $1 IS NULL THEN
          RETURN QUERY SELECT 'Выберите контрагента' as contact;
       else
	    return query select (c.last_name || ' ' || c.first_name )::text as contact
		from contact c  where c.account_id = $1
		order by  c.last_name  asc;
	end if;
return;
end; 
$$; --13


select (c.first_name || ' ' || c.last_name  )::text as contact
    from contact c  where c.account_id = '5dc60d0b-c6f1-40ef-a265-100706014ad4'
    order by c.last_name  asc ;

     
   
CREATE OR REPLACE VIEW public.courier_statistic
AS SELECT ac.id AS account_id,
    ac.name AS account,
    count(cou.user_id) AS count_courier,
    count(
        CASE
            WHEN cou.status = 'Выполнено'::status_type THEN 1
            ELSE NULL::integer
        END) AS count_complete,
    count(
        CASE
            WHEN cou.status = 'Отменен'::status_type THEN 1
            ELSE NULL::integer
        END) AS count_canceled,
    sum(
        CASE
            WHEN to_char(cou.created_date::timestamp with time zone, 'MM-YYYY'::text) = to_char(now(), 'MM-YYYY'::text) THEN 1
            ELSE 0
        END) / NULLIF(sum(
        CASE
            WHEN to_char(cou.created_date::timestamp with time zone, 'MM-YYYY'::text) = to_char(now() - '1 mon'::interval, 'MM-YYYY'::text) THEN 1
            ELSE 0
        END), 0) * 100 AS percent_relative_prev_month,
    count(DISTINCT cou.from_place)  AS count_where_place,
    count(cou.contact_id) filter (where cou.status= 'Выполняется'::status_type),
    array_agg(DISTINCT cou.user_id) FILTER (WHERE cou.status = 'Отменен'::status_type) AS cansel_user_array
   FROM account ac
     JOIN courier cou ON ac.id = cou.account_id
  GROUP BY ac.id;
 










