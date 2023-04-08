create schema test_fdw;

select * from hr.person p

select *
from pg_catalog.pg_available_extensions 
where installed_version is not null --проверяем установленные модули 

create extension postgres_fdw --устанавливаем модуль postgres_fdw

create server pfdw_ 
foreign data wrapper postgres_fdw --какую обертку будем использовать
options (host '127.0.0.1', port '5433', dbname 'netology')

create user mapping for postgres --какой уч записью будем подключатся 
server pfdw_
options (user 'log', password 'pas')


CREATE foreign table test_fdw.out_person (
	person_id int4,
	first_name varchar(250) ,
	middle_name varchar(250),
	last_name varchar(250),
	taxpayer_number varchar(40) ,
	dob date)
server pfdw_
options (schema_name 'hr', table_name 'person')


SELECT person_id, first_name, middle_name, last_name, taxpayer_number, dob
FROM test_fdw.out_person;

drop server pfdw_ cascade --delete server при ошибках в строке подключения)

select op.first_name, op.middle_name, op.last_name, p.pos_title, p.pos_category, p.grade 
from test_fdw.out_person op
join hr.employee em on em.person_id=op.person_id
join hr."position" p on em.pos_id=p.pos_id
where p.grade is not null
order by  op.first_name desc


