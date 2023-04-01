create schema normal;

CREATE TABLE fio_employee_of (
    id_employ     BIGSERIAL,
    first_name    varchar(40) NOT NULL,
    last_name     varchar(40) NOT NULL,
    email         varchar(40) UNIQUE,
    phone         varchar(11) UNIQUE,
    date_of_birth date NOT null,
     PRIMARY KEY(id_employ)
);

CREATE TABLE residential_address_employ (
    id_address_employ bigserial,
    id_employ         bigint,
    addres_emp        varchar(50),
    street_emp        varchar(50),
    house_number_emp  varchar(20),
    primary key (id_address_employ),
    CONSTRAINT fk_employ
      FOREIGN KEY(id_employ) 
	  REFERENCES fio_employee_of(id_employ)
);

CREATE table employee_position (
   id_position       bigserial,
   id_employ         bigint,
   post_employ       varchar(30) NOT NULL,
   id_departament    bigint,
   PRIMARY KEY(id_position),
   CONSTRAINT fk_employ
      FOREIGN key (id_employ) 
	  REFERENCES fio_employee_of(id_employ),
   CONSTRAINT fk_departament
      FOREIGN key (id_departament) 
	  REFERENCES department(id_department)
);

CREATE table department (
   id_department       bigserial,
   addres_depart       varchar(50) NOT NULL,
   street_depart       varchar(40) NOT NULL,
   house_number_depart varchar(20),
   PRIMARY KEY(id_department)
);

CREATE table info_department (
    id_info_depart    bigserial,
    id_department     bigint,
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
   id_position_work    bigserial,
   id_employ           bigint,
   id_info_depart      bigint, 
   date_begin          date NOT NULL,
   date_finish         date,
   wages               numeric(10,2) NOT null,
   PRIMARY KEY(id_position_work),
   CONSTRAINT fk_info_depart
      FOREIGN key (id_info_depart) 
	  REFERENCES info_department(id_info_depart),
	CONSTRAINT fk_employ
      FOREIGN key (id_employ) 
	  REFERENCES fio_employee_of(id_employ)
);
