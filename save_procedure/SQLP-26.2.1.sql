select count(*) from vacancy v where vac_title ='стажер' and create_date > '03.08.2017'   and create_date < '03.10.2019' 


create function foo(vac_ text, begin_date date, end_date date) RETURNS int as $$
declare vac_count integer;
	begin 
	  select COUNT(*) into vac_count from vacancy where vac_title =vac_ and create_date > begin_date   and create_date < end_date;  
	  return vac_count;
	end;
$$ LANGUAGE plpgsql;


select foo('стажер','03.08.2017','03.10.2019')


create OR REPLACE FUNCTION foo(vac_ text, begin_date date, end_date date) RETURNS int as $$
declare vac_count integer;
	begin 
	  if begin_date > end_date then
	   return null;
	  else
	     select COUNT(*) into vac_count from vacancy where vac_title =vac_ and create_date > begin_date   and create_date < end_date;  
	     return vac_count;
	  end if;
	end;
$$ LANGUAGE plpgsql;


select foo('стажер','03.10.2019','03.10.2020')
