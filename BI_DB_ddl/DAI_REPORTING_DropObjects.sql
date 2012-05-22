/*
select tablespace_name, table_name, status, dependencies, segment_created,
       last_analyzed, num_rows, empty_blocks
from user_tables

select * from user_constraints

select 'alter table '||table_name||' drop constraint '||constraint_name||';'
from user_constraints
--where constraint_type = 'R'  ---> First
--where constraint_type = 'U'   --> Second
where constraint_type = 'C'   --> Third
*/

---==================================================================
--- First, Drop Reference (Foreign Key) constraints:
begin
 for X in (select TABLE_NAME, CONSTRAINT_NAME
           from USER_CONSTRAINTS
           where CONSTRAINT_TYPE = 'R')
 LOOP
   execute immediate 'alter table '||X.TABLE_NAME||' drop constraint '||X.CONSTRAINT_NAME;
 end LOOP;
end;
/

--- Second, Drop Unique constraints:
begin
 for X in (select TABLE_NAME, CONSTRAINT_NAME
           from USER_CONSTRAINTS
          where CONSTRAINT_TYPE = 'U')
 LOOP
   execute immediate 'alter table '||X.TABLE_NAME||' drop constraint '||X.CONSTRAINT_NAME;
 end LOOP;
end;
/

--- Third, Drop Check constraints:
begin
 for X in (select TABLE_NAME, CONSTRAINT_NAME
           from USER_CONSTRAINTS
          where CONSTRAINT_TYPE = 'C')
 LOOP
   execute immediate 'alter table '||X.TABLE_NAME||' drop constraint '||X.CONSTRAINT_NAME;
 end LOOP;
end;
/


--- Next, Drop Primary Key constraints:
begin
 for X in (select TABLE_NAME, CONSTRAINT_NAME from USER_CONSTRAINTS)
 LOOP
   execute immediate 'alter table '||X.TABLE_NAME||' drop constraint '||X.CONSTRAINT_NAME;
 end LOOP;
end;
/
---==================================================================

/*
--- Drop User Sequences:
begin
 for X in (select SEQUENCE_NAME from USER_SEQUENCES)
  LOOP
    execute immediate 'drop sequence '||X.SEQUENCE_NAME;
  end LOOP;
end;
/


--- Drop User Tables:
begin
 for X in (select table_name from USER_tables)
  LOOP
    execute immediate 'drop table '||X.table_NAME||' purge';
  end LOOP;
end;
/
*/

