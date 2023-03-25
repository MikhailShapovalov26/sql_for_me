select * from projects p ;

select * from projects p where project_id = '500';

insert into projects values (500, 'Инженер', '{2646,1697,1708,2032,2211,1230,2667,1093,102}' , 100000 , 96, '2023-06-28 07:50:34.000');

savepoint netology_save;

delete from projects where project_id = '500';

ROLLBACK TO savepoint netology_save;

commit;

select * from projects p where project_id = '500';