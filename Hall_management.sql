drop table hall_employee;
drop table teacher;
drop table students;
drop table hall;

create table hall(
	hall_name varchar(20),
	building_no integer ,
	no_of_students integer,
	no_of_employee integer,
	no_of_teachers integer,
	primary key (hall_name,building_no)
);

create table students(
	name varchar(20),
	std_roll integer unique,
	department varchar(10) not null,
	border_no varchar(20),
	birth_date date,
	hall_name varchar(20),
	building_no integer,
	primary key(border_no),
	foreign key (hall_name,building_no) references hall (hall_name,building_no)
);

create table teacher(
	teacher_id number(28) not null,	
	teacher_name varchar(30),
	t_department varchar(10),
	position varchar(20),
	hall_name varchar(20),
	building_no integer,
	primary key (teacher_id),
	foreign key (hall_name,building_no) references hall (hall_name,building_no)
);

create table hall_employee(
	emp_id integer,
	emp_name varchar(20),
	emp_age number(3),
	emp_sex integer,
	hall_name varchar(20),
	building_no integer
);

					--alter operation--

--add column
alter table hall_employee add emp_salary number(10);
--modify column
alter table hall_employee modify emp_sex varchar(10);
--add column
alter table hall_employee add new_col number(10);
--rename column
alter table hall_employee rename column new_col to new_column;
--drop column
alter table hall_employee drop column new_column;

				--primary key and foreign key set by alter command
				
alter table hall_employee add primary key (emp_id);
alter table hall_employee add foreign key (hall_name,building_no) references hall (hall_name,building_no);
				
describe students;
describe teacher;
describe hall_employee;
describe hall;

commit;

CREATE OR REPLACE TRIGGER check_emp_salary BEFORE INSERT OR UPDATE ON hall_employee
FOR EACH ROW
DECLARE
   salary_min constant number(10) := 1000;
   salary_max constant number(10) := 50000;
BEGIN
  IF :new.emp_salary > salary_max OR :new.emp_salary < salary_min THEN
  RAISE_APPLICATION_ERROR(-20000,'New salary is too small or large');
END IF;
END;
/


--insert into hall table
insert into hall values ('BSMRH',01,600,50,3);
insert into hall values ('LSH',02,350,30,2);
insert into hall values ('FHH',03,300,50,2);
insert into hall values ('AEH',04,550,30,3);
insert into hall values ('MARH',05,250,50,2);
insert into hall values ('KJH',06,200,30,2);
insert into hall values ('RH',07,400,50,2);

--insert into students table
insert into students values('fattah',1207059,'cse','w-209','02-NOV-93','BSMRH',01);
insert into students values('masum',1207012,'cse','w-210','12-AUG-95','LSH',02);
insert into students values('alamin',1207050,'cse','w-211','24-AUG-94','BSMRH',01);
insert into students values('rubel',1207060,'cse','w-212','25-AUG-93','AEH',04);
insert into students values('prince',1207056,'cse','w-213','25-JUL-92','FHH',03);
insert into students values('aziz',1207001,'cse','w-214','03-SEP-95','MARH',05);
insert into students values('pial',1207051,'cse','w-215','27-JUL-93','KJH',06);
insert into students values('mahir',1207047,'cse','w-217','12-FEB-90','BSMRH',01);
insert into students values('sazol',1207052,'cse','w-218','10-NOV-93','LSH',02);
insert into students values('emon',1209015,'ece','w-219','12-FEB-90','BSMRH',01);

--insert into teacher table
insert into teacher values(01,'Mr. Sobhan Mia','me','provost','BSMRH',01);
insert into teacher values(02,'Mr. Suvro','ece','assistant-provost','BSMRH',01);
insert into teacher values(03,'Mr. Abc','ce','assistant-provost','BSMRH',01);
insert into teacher values(04,'Mr. Motin','ece','provost','LSH',02);
insert into teacher values(05,'Mr. karim','me','assistant-provost','LSH',02);
insert into teacher values(06,'Mr. Xyz','cse','provost','AEH',04);
insert into teacher values(07,'Mrs. AAA','cse','provost','RH',07);

--insert into hall_employee table
insert into hall_employee values(1001,'emp1',20,'male','BSMRH',01,5000);
insert into hall_employee values(1002,'emp2',20,'male','BSMRH',01,4000);
insert into hall_employee values(1003,'emp3',20,'male','BSMRH',01,5000);
insert into hall_employee values(2001,'emp4',20,'male','LSH',02,4000);
insert into hall_employee values(2002,'emp5',20,'male','LSH',02,2000);
insert into hall_employee values(2003,'emp6',20,'female','LSH',02,3000);

--this data will not be inserted because salary is too low which will be detected by trigger
insert into hall_employee values(2003,'emp6',20,'male','LSH',02,500);

			--update operation
update hall_employee set emp_salary=emp_salary+1000 where hall_name='BSMRH';
update hall_employee set emp_name='new_emp' where emp_id=1003;


			--delete operation
delete from hall_employee where emp_name='emp5';

--select operation
select * from students;
select * from teacher;
select * from hall_employee;
select * from hall;

commit;

				--select operation
				
select name,std_roll from students;
			
			--group by operation
--find max salary of hall_employee of every hall
select hall_name,max(emp_salary) as "highest_salary of employee" from hall_employee group by hall_name;
--find total_emp_salary of every hall
select hall_name,sum(emp_salary) from hall_employee group by hall_name;
--find number of employees of every hall
select hall_name,count(*) as "Number of employee" from hall_employee group by hall_name;

			--order by operation
select emp_id,emp_name from hall_employee order by emp_id;
select emp_id,emp_name from hall_employee order by emp_id desc;

			--having clause
select hall_name,min(emp_salary) from hall_employee group by hall_name having min(emp_salary)>=2000;
select hall_name,count(*) as "number of employee" from hall_employee group by hall_name having count(*)>2;
			
			--distinct
select distinct (birth_date) from students;

SELECT (emp_salary/2) AS salary_divide_by_two FROM hall_employee;


select emp_id,emp_salary from hall_employee where emp_salary between 4000 and 10000;
select emp_id,emp_salary from hall_employee where emp_salary not between 4000 and 10000;

select name from students where department LIKE '%cse%';

--calculate the age of all students of Bangobondhu hall(BSMRH);
select floor(months_between(sysdate,birth_date)/12) as "age" from students where hall_name='BSMRH';

select name,std_roll from students where name in('fattah','sazol');

commit;

			--join operation

SELECT h.hall_name, s.name
	FROM hall h cross JOIN students s;	

SELECT distinct(hall_name)
	FROM hall NATURAL JOIN students;

--find the names of all students and hall_name whose provost name is 'Mr. Sobhan Mia'
SELECT s.name,h.hall_name
	FROM hall h JOIN students s
	on h.hall_name=s.hall_name and h.building_no=s.building_no
	and s.hall_name in (select hall_name from teacher where teacher_name='Mr. Sobhan Mia');
				--left outer join
--show students name,hall_name and their provost name(if exists cz i didn't insert data for all provost) 
select s.name,s.hall_name,t.teacher_name as "provost" from students s left outer join teacher t 
	on s.hall_name= t.hall_name and t.position='provost';
				--right outer join
--show students name,hall_name and their provost name(if exists cz i didn't insert data for all provost)
select s.name,s.hall_name,t.teacher_name as "provost" from teacher t right outer join students s 
	on s.hall_name= t.hall_name and t.position='provost';

				--full outer join
--find all students name and provost name
select s.name,t.teacher_name from students s full outer join
	(select hall_name,teacher_name from teacher where position='provost') t 
	on s.hall_name=t.hall_name;

				--self join;
	
--find the name of employee who earn more than employee named 'emp1'
select e.emp_name from hall_employee e join hall_employee e1 
	on e1.emp_name='emp1' and e1.emp_salary>e.emp_salary;
	
commit;
			
			--sub query operation

--find all students of bangobandhu hall
select name,std_roll from students where hall_name
	in (select hall_name from hall  where hall_name='BSMRH');

--find the provost and assistant-provost of student named 'fattah'
select teacher_name,position from teacher where hall_name 
	in (select h.hall_name from hall h,students s where s.name='fattah' and s.hall_name=h.hall_name);

--find all students under provost named 'Mr. Sobhan Mia' sir;
select name from students where hall_name 
	in(select h.hall_name from hall h,teacher t 
	where t.teacher_name='Mr. Sobhan Mia' and t.hall_name=h.hall_name);

				--union operation
--find all students of BSMRH and LSH
select hall_name,name from students where hall_name='BSMRH' 
	union select hall_name,name from students where hall_name='LSH';
				
				--intersect operation
--find all student of cse department in bangobandhu hall
select hall_name,name from students where hall_name='BSMRH' 
	intersect select hall_name,name from students where department='cse';
--above operation can be simply done by
select hall_name,name from students where hall_name='BSMRH' and department='cse';
				
				--minus operation
--find all students of cse department who don't live in BSMRH
select hall_name,name from students where department='cse'
	minus select hall_name,name from students where hall_name='BSMRH';

commit;

				--pl_sql operation

--find the maximum salary of employee
SET  SERVEROUTPUT ON
declare
	max_salary hall_employee.emp_salary%type;
begin
	select max(emp_salary) into max_salary from hall_employee;
	DBMS_OUTPUT.PUT_LINE('The maximum salary of employee is : ' || max_salary);
end;
/

--find the provost name of student 'fattah'
DECLARE
  std_name students.name%type :='fattah';
  t_name teacher.teacher_name%type;
  h_name students.hall_name%type;
BEGIN 
	select t.teacher_name,s.hall_name into t_name,h_name from students s join teacher t 
	on s.hall_name=t.hall_name and t.position='provost' and s.name=std_name;
	DBMS_OUTPUT.PUT_LINE('Std_name : ' || std_name);
	DBMS_OUTPUT.PUT_LINE('Hall: '|| h_name );
	DBMS_OUTPUT.PUT_LINE('Provost: '||t_name);
END;
/

				--cursor operation

--find age(year,month,day) of all students
declare
	cursor age_calculation is select std_roll,birth_date from students;
	current_age age_calculation%rowtype;
	y number(5);
	m number(2);
	d number(2);
	y1 number(5);
	m1 number(2);
	d1 number(2);
	c number(3);
	s_name varchar2(10);
begin
	select count(std_roll) into c from students;
	select extract(year from sysdate),extract(month from sysdate),
		extract(day from sysdate) into y,m,d from dual;
open age_calculation;
	loop
		fetch age_calculation into current_age;
			select name,extract(year from birth_date),extract(month from birth_date),
				extract(day from birth_date) into s_name,y1,m1,d1 from students where std_roll=current_age.std_roll;	
			y1:=y-y1;
			if d < d1 then
				d1 := 30-d1+d;
				if m <= m1 then
					m1 := 12-m1+m-1;
				else 
					m1 := m-m1;
				end if;
			else 
				d1:=d-d1;
				if m < m1 then
					m1 := 12-m1+m;
				else 
					m1 := m-m1;
				end if;
			end if;
			DBMS_OUTPUT.PUT_LINE('Name: '||s_name||' __ year: '||y1||' __ month: '||m1||' __ day: '||d1);
		exit when age_calculation%rowcount >= c;
	end loop; 
close age_calculation;
end;
/

			--procedure

--this procedure find the hall_name of a student named 'fattah'
CREATE OR REPLACE PROCEDURE getHall_name IS 
	s_name students.name%type;
	h_name students.hall_name%type;
BEGIN
    s_name:='fattah';
    SELECT hall_name INTO h_name
    FROM students
    WHERE name=s_name;
    DBMS_OUTPUT.PUT_LINE('Student: '||s_name||' Hall_name: '||h_name);
END;
/
SHOW ERRORS;

BEGIN
   getHall_name;
END;
/

			--procedure with parameter
--this procedure calculate the age of call student
create or replace procedure getAge(s_name students.name%type) is
	age number(3);
	b_date date;
begin
	select birth_date into b_date from students where name=s_name;
	age:= floor(months_between(sysdate,b_date)/12);
	DBMS_OUTPUT.PUT_LINE('Age of '||s_name||' is : '||age);
end;
/
show errors;
begin
	getAge('fattah');
	getAge('masum');
end;
/

			--function

--this function returns the total_salary of all employee
create or replace function total_salary return number is
	t_salary hall_employee.emp_salary%type;
begin
	select sum(emp_salary) into t_salary from hall_employee;
	return t_salary;
end;
/
begin
	DBMS_OUTPUT.PUT_LINE('total_salary of employee is : '||total_salary);
end;
/


				--function with parameter
--this function returns the hall_name of called student
create or replace function hall_name_return(s_name in students.name%type) return varchar2 is
	h_name students.hall_name%type;
begin
	select hall_name into h_name from students where name=s_name;
	return h_name;
end hall_name_return;
/
show errors;

begin
	DBMS_OUTPUT.PUT_LINE('The hall_name of fattah is : '||hall_name_return('fattah'));
end;
/
--function call
select name,hall_name_return(name) "hall_name" from students;

commit;

--increase salary 25% if salary<5000 otherwise 50% when insert into employee table
create trigger upgrade_salary before update or insert on hall_employee
for each row
declare
salary number(10);
begin
	salary:= :new.emp_salary;
	if :new.emp_salary<5000 then
		:new.emp_salary:= salary+(salary*.25);
	elsif :new.emp_salary>=5000 then
		:new.emp_salary := salary+(salary*.5);
	end if;
end upgrade_salary;
/
show errors;
insert into hall_employee values(2004,'emp7',21,'male','LSH',02,6000);
--newly inserted salary is 6000 but due to trigger effect inserted salary will be 9000
select emp_salary,emp_name from hall_employee;
commit;
			
			--rollback operation
insert into hall_employee values(2005,'emp7',21,'male','LSH',02,6000);
insert into hall_employee values(2006,'emp8',21,'male','AEH',04,4000);
select emp_salary,emp_name from hall_employee;
--after this line last row inserted in hall_employee will be deleted
rollback;
select emp_salary,emp_name from hall_employee;
commit;

			--save point
insert into students values('foysal',1209017,'ece','w-220','12-JUN-94','BSMRH',01);
savepoint sp1;
insert into students values('rakib',1209018,'ece','w-221','12-FEB-90','BSMRH',01);
savepoint sp2;
select name,std_roll from students;
--after this line last row inserted in students will be deleted
rollback to sp1;
select name,std_roll from students;
commit;

