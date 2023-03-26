create OR REPLACE FUNCTION append_trigger() RETURNS trigger as $$
declare
   old_ integer;
   diff integer;
begin 
	   if  (TG_OP = 'INSERT') then 
		   old_ = '0';
		   diff = new.salary ;
		   insert into hr.employee_salary_history values (new.emp_id,  old_, new.salary, diff, new.effective_from);
		   return new;
	  elseif (TG_OP = 'UPDATE') then 
		   old_ = old.salary;
		   diff = new.salary - old_;
		   insert into hr.employee_salary_history values (new.emp_id,  old_, new.salary, diff, new.effective_from);
		   return new;
	   end if;  
end;
$$ LANGUAGE plpgsql;


create OR replace trigger append
  before insert or update on hr.employee_salary
  FOR EACH row
  execute  function append_trigger();
  
 update hr.employee_salary set salary = 77000 where order_id =  5501;
 
 insert into hr.employee_salary values (5501, 2, 44000, '26.03.2023');
 

select * from hr.employee_salary_history esh  

select * from hr.employee_salary where order_id = 5501



DROP TRIGGER IF EXISTS foo on hr."position" 


drop function foo_trigger CASCADE;