create user	MyUser;

alter user MyUser with password 'secret' valid until '31.03.2023';

grant all PRIVILEGES ON table address, city to MyUser;

revoke all PRIVILEGES ON table address, city from MyUser;

DROP USER MyUser;