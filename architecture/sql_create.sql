create schema flowers;

create table flowers.city (
   pk_city_id   bigserial primary key,
   name_city    varchar (30)
);

create table flowers.street (
   pk_street_id   bigserial primary key,
   fk_city_id     bigint,
   name_street    varchar (30),
   CONSTRAINT fk_city
      FOREIGN KEY(fk_city_id) 
	  REFERENCES city(pk_city_id)
);

create table flowers.addresses (
   pk_addresses_id bigserial primary key,
   fk_street_id    bigint,
   number_house    varchar(10) not null,
   CONSTRAINT fk_street
      FOREIGN key (fk_street_id) 
	  REFERENCES street(pk_street_id)
);

create table flowers.suppliers (
   pk_suppliers_id    bigint primary key,
   name_suppliers     varchar(50),
   phone_suppliers    varchar(11),
   details_suppliers  varchar(100)
);--поставщик

create table flowers.stores (
   pk_stories_id     bigint primary key,
   adress_stories    varchar(35),
   storage_volumes   varchar(25)
); -- склад

create table flowers.products (
   pk_products_id    bigint PRIMARY key,
   fk_suppliers_id   bigint,
   fk_stories_id     bigint,
   price_notax       numeric(6,2),
   price_result      numeric(6,2),
   quantity          int,
   data_delivery     date,
   type_products     varchar,
   CONSTRAINT fk_suppliers
      FOREIGN KEY(fk_suppliers_id) 
	  REFERENCES suppliers(pk_suppliers_id),
   CONSTRAINT fk_stories
      FOREIGN KEY(fk_stories_id) 
	  REFERENCES stores(pk_stories_id)
); -- товар

alter table flowers.products rename column data_delivery to data_goods_delivery

alter table flowers.products add column nomenclature varchar(30);

alter table flowers.products add column expiration_date time;

create table flowers.customers (
   pk_customers_id   bigint PRIMARY key,
   fio_customer      varchar(20),
   phone_customer    varchar(11) unique,
   payment_method    varchar(20)
);-- клиент


create table flowers.staff (
   pk_staff_id     bigint PRIMARY key,
   fk_addresses_id bigint,
   fio_staff       varchar(20),
   phone_staff     varchar(11) unique,
   post_staff      varchar(20),
   salary_staff    numeric(7,2),
   CONSTRAINT fk_addresses
      FOREIGN key (fk_addresses_id) 
	  REFERENCES addresses(pk_addresses_id) 
);--сотрудники

create table flowers.courier_service (
  pk_service      bigint primary key,
  fk_staff_id     bigint,
  fk_stories_id   bigint,
  delivery_method varchar(20), --метод доставки цветов(тип курьера)
  CONSTRAINT fk_stories
    FOREIGN KEY(fk_stories_id) 
    REFERENCES stores(pk_stories_id),
  CONSTRAINT fk_staff
    FOREIGN KEY(fk_staff_id) 
	REFERENCES staff(pk_staff_id)
); -- курьерская служба достатки цветов

create table flowers.bonus_for_delivery (
   pk_bonus_id             bigint primary key,
   fk_orders_id            bigint, 
   fk_service_id           bigint,
   status_delivery         varchar(10),
   estimation_for_delivery varchar(10), --оценка за заказ
   execution_time          time,  --время исполнения заказа
   CONSTRAINT fk_service
      FOREIGN KEY(fk_service_id) 
      REFERENCES courier_service(pk_service),
   CONSTRAINT fk_orders
      FOREIGN KEY(fk_orders_id) 
      REFERENCES orders(pk_orders_id)
); --бонус, статус доставки 

create  table flowers.orders (
   pk_orders_id      bigint primary key,
   fk_customers_id   bigint,
   fk_source_sale_id bigint,
   data_orders       date,
   fk_addresses_id   bigint,  --адрес доставки цветов
   comment_orders    varchar(50),
   CONSTRAINT fk_customers
     FOREIGN KEY(fk_customers_id) 
     REFERENCES customers(pk_customers_id),
   CONSTRAINT fk_source_sale
     FOREIGN KEY(fk_source_sale_id) 
     REFERENCES source_sale(pk_source_sale_id),
   CONSTRAINT fk_addresses
      FOREIGN key (fk_addresses_id) 
	  REFERENCES addresses(pk_addresses_id) 
);--заказ

create table flowers.sale(
    pk_sale_id     bigint primary key,
    fk_orders_id   bigint,
    fk_products_id bigint,
    number_sale    int, --количество товара
    price_sale     numeric(6,2),
    CONSTRAINT fk_orders
      FOREIGN KEY(fk_orders_id) 
      REFERENCES orders(pk_orders_id),
    CONSTRAINT fk_products_id
      FOREIGN KEY(fk_products_id) 
      REFERENCES products(pk_products_id)
); --сама продажа

create table flowers.source_sale (
    pk_source_sale_id bigint primary key,
    name_source_sale  varchar(20)
); --источники продаж