reate OR REPLACE FUNCTION foo_trigger() RETURNS trigger as $$
 begin 
	 if not exists (select grade from grade_salary where grade = new.grade )
	 then
        RAISE EXCEPTION 'Grade not valid, please add new grade';
    end if;
   return new;
 end;
$$ LANGUAGE plpgsql;


create OR replace trigger add_data
  before  insert or update  on "position"
  FOR EACH row
  when (new.grade IS NOT NULL)
  execute  procedure foo_trigger();

select * from grade_salary gs  where grade =10

select * from "position" p where pos_id = 1505997


insert into "position" (pos_id, pos_title, pos_category, unit_id, grade, address_id, manager_pos_id)  
values (1505997,'Нетолог','Главный', 212 , 20 , 10 ,2)


update "position" set pos_category = 'Самый главный', grade = 20 where pos_id = 1505997
