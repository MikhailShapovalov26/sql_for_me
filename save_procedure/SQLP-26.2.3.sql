create OR REPLACE FUNCTION append_trigger() RETURNS trigger as $$
declare
   old_ integer;
   diff integer;
begin 
	   if  (TG_OP = 'INSERT') then 
	      if EXISTS  (select emp_id from hr.employee_salary_history where emp_id = new.emp_id ) then
	            old_ = (select t.salary_new  from hr.employee_salary_history t where t.emp_id = new.emp_id order by t.last_update desc limit 1);
		        diff = new.salary - old_;
		        insert into hr.employee_salary_history values (new.emp_id,  old_, new.salary, diff, now());
		    else
		        old_ = '0';
		        diff = new.salary ;
		        insert into hr.employee_salary_history values (new.emp_id,  old_, new.salary, diff,  now()); 
		  end if;
	  elseif (TG_OP = 'UPDATE') then 
		   old_ = old.salary;
		   diff = new.salary - old_;
		   insert into hr.employee_salary_history values (new.emp_id,  old_, new.salary, diff,  now());
	   end if; 
	  return new;
end;
$$ LANGUAGE plpgsql;


create OR replace trigger append
  after insert or update on hr.employee_salary
  FOR EACH row
  execute  function append_trigger();
  
 update hr.employee_salary set salary = 77000 where order_id =  5501;
 
 insert into hr.employee_salary values (5501, 2, 44000, '26.03.2023');
 

select * from hr.employee_salary_history esh  

select * from hr.employee_salary where order_id = 5501



DROP TRIGGER IF EXISTS foo on hr."position" 


drop function foo_trigger CASCADE;

DELETE from hr.employee_salary where order_id = 5503

DELETE from hr.employee_salary_history 