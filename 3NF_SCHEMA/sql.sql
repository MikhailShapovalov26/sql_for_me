create schema normal;

CREATE TABLE fio_employee_of (
   id_employ     BIGSERIAL,
   id_addresses bigint,
   first_name    varchar(40) NOT NULL,
   last_name     varchar(40) NOT NULL,
   email         varchar(40) UNIQUE,
   phone         varchar(11) UNIQUE,
   date_of_birth date NOT null,
   PRIMARY KEY(id_employ),
   CONSTRAINT fk_addresses
   FOREIGN key (id_addresses) 
   REFERENCES addresses(id_addresses) 
);

create table city (
   id_city     bigserial primary key,
   name_city   varchar (30)
);

create table street (
   id_street   bigserial primary key,
   id_city     bigint,
   name_street varchar (30),
   CONSTRAINT fk_city
     FOREIGN KEY(id_city) 
	  REFERENCES city(id_city)
);

create table addresses (
   id_addresses    bigserial primary key,
   id_street       bigint,
   number_house    varchar(10) not null,
   CONSTRAINT fk_street
     FOREIGN key (id_street) 
	  REFERENCES street(id_street)
);

CREATE TABLE history_fio_employee (
    id_employ     bigint,
    first_name    varchar(40) NOT NULL,
    last_name     varchar(40) NOT NULL,
    email         varchar(40),
    phone         varchar(11),
    change_date   date not null
);

CREATE table employee_position (
   id_position    bigserial,
   id_employ      bigint,
   post_employ    varchar(30) NOT NULL,
   id_departament bigint,
   PRIMARY KEY(id_position),
   CONSTRAINT fk_employ
      FOREIGN key (id_employ) 
	   REFERENCES fio_employee_of(id_employ),
   CONSTRAINT fk_departament
      FOREIGN key (id_departament) 
	   REFERENCES department(id_department)
);

CREATE table department (
   id_department   bigserial,
   id_addresses    bigint,
   PRIMARY KEY(id_department),
   CONSTRAINT fk_addresses
      FOREIGN key (id_addresses) 
	   REFERENCES addresses(id_addresses) 
);

CREATE table info_department (
    id_info_depart   bigserial,
    id_department    bigint,
    id_employ         bigint,
    PRIMARY KEY(id_info_depart),
    CONSTRAINT fk_departament
      FOREIGN key (id_department) 
	   REFERENCES department(id_department),
	CONSTRAINT fk_employ
      FOREIGN key (id_employ) 
	   REFERENCES fio_employee_of(id_employ)
);

create table position_at_work (
   id_position_work   bigserial,
   id_employ          bigint,
   id_info_depart     bigint, 
   date_begin         date NOT NULL,
   date_finish        date,
   wages              numeric(10,2) NOT null,
   PRIMARY KEY(id_position_work),
   CONSTRAINT fk_info_depart
      FOREIGN key (id_info_depart) 
	   REFERENCES info_department(id_info_depart),
	CONSTRAINT fk_employ
      FOREIGN key (id_employ) 
	   REFERENCES fio_employee_of(id_employ)
);

