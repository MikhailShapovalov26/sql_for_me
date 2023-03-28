select * from employee_salary where effective_from = '2023-03-28' order by  effective_from desc 

select * from employee_salary where order_id = 250777 order by  order_id  desc 

create or replace procedure append_salary(a int, b int, c numeric(12,2), d date) as $$ 
begin
	if d = null then
	d = now();
	end if;
	insert into employee_salary 
	values (a,b,c, d);
end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE function count_() RETURNS integer as $$
declare f int;
begin
  f = (select * from employee_salary);
 return f;
end;
$$
LANGUAGE plpgsql;

call append_salary(250777,1, 8500);