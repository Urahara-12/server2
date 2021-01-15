drop database if exists app;
drop database if exists history;

create database if not exists app;

create database if not exists history;

use app;

drop table if exists course;
drop table if exists professor;
drop table if exists department;

create table if not exists department (
    id serial primary key
    , name varchar(20) unique not null check (name <> '')
    , asof timestamp not null default (current_timestamp)
);

create table if not exists professor (
    id serial primary key
    , name varchar(20) unique not null check (name <> '')
    , department_id bigint unsigned
    , asof timestamp not null default (current_timestamp)
    , foreign key (department_id) references department (id)
      on delete set null on update cascade
);

create table if not exists course (
    id serial primary key
    , name varchar(20) unique not null check (name <> '')
    , description varchar(255) not null check (description <> '')
    , professor_id bigint unsigned
    , asof timestamp not null default (current_timestamp)
    , foreign key (professor_id) references professor (id)
      on delete set null on update cascade
);

use history;

drop table if exists course;
drop table if exists professor;
drop table if exists department;

create table if not exists department (
    id bigint unsigned
    , name varchar(20)
    , asof timestamp
);

create table if not exists professor (
    id bigint unsigned
    , name varchar(20)
    , department_id bigint unsigned
    , asof timestamp
);

create table if not exists course (
    id bigint unsigned
    , name varchar(20)
    , description varchar(255)
    , professor_id bigint unsigned
    , asof timestamp
);

use app;

drop procedure if exists log_department_history;
drop procedure if exists log_professor_history;
drop procedure if exists log_course_history;
drop trigger if exists department_history_insert;
drop trigger if exists professor_history_insert;
drop trigger if exists course_history_insert;
drop trigger if exists department_history_update;
drop trigger if exists professor_history_update;
drop trigger if exists course_history_update;

delimiter |

create procedure if not exists log_department_history(
    in id bigint unsigned
    , in name varchar(20)
    , in asof timestamp
) begin
    insert into history.department (id, name, asof)
    values (id, name, asof);
end;|

create procedure if not exists log_professor_history(
    in id bigint unsigned
    , in name varchar(20)
    , in department_id bigint unsigned
    , in asof timestamp
) begin
    insert into history.professor (id, name, department_id, asof)
    values (id, name, department_id, asof);
end;|

create procedure if not exists log_course_history(
    in id bigint unsigned
    , in name varchar(20)
    , in description varchar(255)
    , in professor_id bigint unsigned
    , in asof timestamp
) begin
    insert into history.course (id, name, description, professor_id, asof)
    values (id, name, description, professor_id, asof);
end;|

create trigger if not exists department_history_insert after insert on department
for each row begin
    call log_department_history(new.id, new.name, new.asof);
end;|

create trigger if not exists department_history_update before update on department
for each row begin
    set new.asof = current_timestamp;
    call log_department_history(new.id, new.name, new.asof);
end;|

create trigger if not exists professor_history_insert after insert on professor
for each row begin
    call log_professor_history(new.id, new.name, new.department_id, new.asof);
end;|

create trigger if not exists professor_history_update before update on professor
for each row begin
    set new.asof = current_timestamp;
    call log_professor_history(new.id, new.name, new.department_id, new.asof);
end;|

create trigger if not exists course_history_insert after insert on course
for each row begin
    call log_course_history(new.id, new.name, new.description, new.professor_id, new.asof);
end;|

create trigger if not exists course_history_update before update on course
for each row begin
    set new.asof = current_timestamp;
    call log_course_history(new.id, new.name, new.description, new.professor_id, new.asof);
end;|

delimiter ;
