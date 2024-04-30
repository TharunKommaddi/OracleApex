

Ref cursor:

It is a plsql datatype using which you can declare a special type 
of variable called cursor variable.

A single cursor variable can be associated with multiple select statements
in single pl/sql block.

In oracle database cursor variables exist in the form of ref cursors.

alter table tablename add constraint con_name primary key(column name);--pk syntax


alter table tablen

Bulk collect:

It is used to reduce the context switching between plsql engine to sql engine

Bulk collect is nothing but select the data


For all :

Bulk bind means processing the data


declare

TYPE RT IS TABLE OF TABLE_NAME1%ROWTYPE;
VT RT;

BEGIN
SELECT * BULK COLLECT INTO VT FROM TABLE_NAME1;
FOR ALL 1 IN 1..VT.COUNT
INSERT INTO TABLE_NAME2 VALUES VT(I);
COMMIT;
END;



 Ref cursor:

A single REF CURSOR  variable can be associated with multiple select
statement in a single plsql block.
while a static cursor can only access single statement at a time.

ref cursor is pl sql datatype

we just declare and open it 

in normal cursor
declare-->open>fetch-->close


there are 2 types of ref cursor
-->Strong ref cursor(which do have a return type)
-->Weak ref cursor(which don't have any return type)

 syntax of strong ref cursor:

declare
TYPE ref_cur_name is ref cursor
return return_type;

syntax of weak ref cursor:1e
declare 
type ref_cur_name is ref cursor


Oracle provides a special type of data type for cursor
-- Sys_RefCursor


create or replace procedure p_emp(p_dept number,
p_cur out Sys_RefCursor)
is
begin
open p_cur for select empno,ename,sal from emp where deptno=p_dept;
end;


create or replace function get_rep(p_deptno in number)
return sys_refcursor
as
c_rep sys_refcursor;
begin
open c_rep for
select empno,ename,sal from emp where deptno=p_deptno;

return c_rep;
end;


Apex collections:

Apex collections are the temporary storage for the current session.
in which we can add the data ,access the data.


apex_collection.create_collection('collection_name');

if not apex_collection.collection_exists('collection_name') then

apex_collection.create_collection('collection_name');
else
apex_collection.truncate_collection('employee_collection');
end if;


declare
cursor c1 is select empno,ename,sal from emp;
begin
if not apex_collection.collection_exists('cnam1') then
apex_collection.create_collection('cnam1');
else
apex_collection.truncate_collection('cnam1');
end if;
for i in c1 loop
apex_collection.add_member
(p_collection => 'cnam1',
p_c001 ==>c1.empno,
p_c002 ==>c1.ename,
p_c003 ==>c1.sal);
end loop;
end;


we need to create the collection in before region position.

we can create a interactive report with a collection.

select c001,c002,c003 from apex_collections
where collection_name='cnam1';



Collections in plsql:

Collection is a group of elements of same datatype.

there are three types of collections:

1.pl/sql table or index by table
2.varray
3.nested table

declare type
declare variable

type tname is table of datatype index by datatype;


1.varrays

arrays
predefined size
cannot delete elements

2.nested Table
list
varaible size
index start with 1

3.Associative Arrays / Index by table

index can be done with strings
Map 


declare 
type t_arr is varray(10) of number;
l_emp_id t_arr;
begin
select empno bulk collect into t_arr from emp;
dbms_output.put_line( l_emp_id (1));
dbms_output.put_line( l_emp_id (2));
dbms_output.put_line( l_emp_id (3));
dbms_output.put_line( l_emp_id (4));
dbms_output.put_line( l_emp_id (5));--upto 10 we can print but after 10 it will give the erro because the the size is fixed
end;



declare 

type t_table is table of number;
t_em t_table;
begin
select empno bulkcollect into t_emp from emp;
dbms_output.put_line(t_emp (1));
dbms_output.put_line(t_emp (2));
dbms_output.put_line(t_emp (3));
dbms_output.put_line(t_emp (4));--the size is not fixed
end;



declare
type emp_rec is record(
l_empno emp.empno%type;
l_ename emp.ename%type;
l_sal emp.sal%type;
)
type t_table is table of emp_rec;
t_emp t_table;
begin
select bulk collect into t_emp from emp;
dbms_output.put_line(t_emp(1));
dbms_output.put_line(t_emp(2));
dbms_output.put_line(t_emp(3));
dbms_output.put_line(t_emp(4));
dbms_output.put_line(t_emp(5));
dbms_output.put_line(t_emp(6));
end;

ame add constraint con_name foreign key(column name)
references tablename(columnname);


alter table tablename rename to new_table_name;



What is an instead of trigger in oracle?

That allows you to update data in tables via their view 
which cannot be modified direclty through DML statements.


in oracle you can create instead of trigger for view only 
we cannot create instead of trigger for table.


Syntax:

CREATE OR REPLACE TRIGGER trigger_name
instead of {insert | update | delete}
on view_name
for each row
begin
exception
-----
end;



Insert the data in log table whenever insert or update/delete
operations performed against the table.

create or replace trigger triggername
before insert or delete on emp
for each row
begin
if inserting then
insert into logs(col1,col2)values(:new.col1,:new.col2);
else
insert into logs(col1,col2) values(:new.col1,:new.col2);
end if;
end;

CREATE OR REPLACE EDITIONABLE TRIGGER  "EMP_LOG" BEFORE
  INSERT 
  ON "EMP"
  REFERENCING NEW AS NEW OLD AS OLD
  FOR EACH ROW
  DECLARE
 --V_EMPNO NUMBER;
  BEGIN
  INSERT INTO EMPSIVA
  (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO)
  VALUES
  (:NEW.EMPNO,
  :NEW.ENAME,
  :NEW.JOB,
  :NEW.MGR,
  :NEW.HIREDATE,
  :NEW.SAL,
  :NEW.COMM,
  :NEW.DEPTNO);
  END;




What is call by value call by reference?
Call By Value. Call By Reference. 
While calling a function, we pass values of variables to it. Such functions are known as “Call By Values”. 
While calling a function, instead of passing the values of variables, we pass address of variables(location of variables) to the function known as “Call By References"



write a query to find the Nth salary ?


SELECT * FROM
(
SELECT ENAME,EMPNO,SAL,DENSE_RANK()OVER(ORDER BY SAL DESC) R FROM EMP)
WHERE R=:N;


check constraint syntax:

alter table table_name
add
constraint con_name check(columnname condition) [DISABLE]



Overloading:

We can define two or more procedures or functions with same name with diffrent parameters


function/procedure name is same but the parameters are different.


Forward Declaration:

If we need to declare a procedure/function or package before invoking.


example:

we have created package with two procedures:

if we call the second procedure in first procedure.

when we execute the package with first procedure
it will give us error

that is the reason we need to declare a 2nd procedure in top of the package;



write a query to display even number records?

select * from(select emp.*,row_number()over(order by empno) as rd from emp)
where mod(rd,2)=0;



how to find duplicates?

select empno,count(*) from emp
group by emp
having count(*)>1;


Write a query to find the second highest salary?


select * from emp where sal<(select max(sal) from emp);


How to change column datatype in oracle?

ALTER TABLE table_name
MODIFY COLUMN column_name datatype;


WHat is view?

A view is a database object that is created using select query with complex logic


simple view-->without where conditions,group by etc


create view view_name
select * from tablename

Complex view:

with where conditions,group by


inline view:

A subquery is also called as inline view if and only if called from clause of select query


Trigger:

It is automatically invoked whenever the DMl operations performed against the table

1.Implement securities
2.Restrict access
3.Auditing purpose
4.to create consistencies


What is deadlock?

It is an unwanted situation where two or more transactions are waiting indefinitely
for one another to release the locks.


State the case manipulation functions in sql?
LOWER
UPPER
INITCAP


write a query to display top 3 max salaries from emp?

select distinct sal from emp a
where 3 >= (select count(distinct sal) from emp where a.sal<b.sal)
order by a.sal desc;

what are the set operators in sql?

union

it will combine all the data from two or more tables with distinct values

union all

it will combine all the data from two or more tables with duplicate values

intersect

it will return only common values




TYPE <type_name> IS VARRAY (<SIZE>) OF <DATA_TYPE>;

TYPE <type name> IS TABLE OF <DATA TYPE>;


TYPE <type_name> IS TABLE OF <DATA_TYPE> INDEX BY VARCHAR2 (10);

pk fk
replace==replace word by word
translate==replaces the character by character
merge statement==selects the data from one or more source tables updates or insert into target table

MERGE INTO target_table 
USING source_table 
ON search_condition
    WHEN MATCHED THEN
        UPDATE SET col1 = value1, col2 = value2,...
        WHERE <update_condition>
        [DELETE WHERE <delete_condition>]
    WHEN NOT MATCHED THEN
        INSERT (col1,col2,...)
        values(value1,value2,...)
        WHERE <insert_condition>;


view ==>
subset of a query 
it will stores the query
if the base tables data updated then view also updated

if we update the view then automatically the base table also updated if the view based on the single table.otherwise it will not update



 mv==>
mv is stores the query output
once the base table updated the mv will not be updated
we need to refresh the mv
execute dbms_mview.refresh('mv');

indexes
data retrival faster
to improve the performance
while creating primary key automatically index will create

set operators union union all

refcursor==>
A refcursor is a variable,defined as cursor type,which will point to,or reference a cursor result
the advantage that a ref cursor has over a plain cursor
is that is can be passed a variable to procedure or a functiton
the refcursor can be assigned to other ref cursor variables

joins
equi join

self join
cross join
outer join
left outer join
full outer join
right outerr join


duplicate rows=======
select empno,count(*) from emp
group by empno
having count(*)>1;

2nd highest

select * from emp where sal<(
select max(sal) from emp);


rank,dense rank

procedure====>
it is a named plsql block
may not return the value
it will store images
function====>
it is also name plsql block
it will return values
it will not store images

cursor========>
row by row process
attributes
Implicit cursors
Explicit cursors

exceptions:
predefined
userdefined exceptions
too_many_rows
zero_divide
invalid_number
dup_val_on_index
invalid_cursor
cursor_already_open

triggers==>
to create consistencies
access restirction
to implement securities
audit log purpose
the trigger will fire any dml operations performed against the table


packages
plsql block
package specification
package body


=======forward declaration=====

index by table
varray
nested

bulk collect

============


Pragma autonomous_transaction

changes the way subprogram works within a transaction
in the subprogram we can do operations commit,rolback without commiting or rollbacking the main transaction


========================

collections are most useful things when a large data of same type need to be processed or manipulated.

Varrays
nested tables
index by table


Varrays:

Varray is a collection method in which the size of the array fixed

the size of array cannot exceeds than fixed value

the subscript of the varray is of a numeric value

type <type_name> is varray (<size>) of <data_type>


Nested Tables:

Nested table is a collection method in which the size of the array is not fixed

Since the upper size limit is not fixed,the memory needs to be extended each time before we use it.

we can extend the collection using EXTEND 

TYPE <type name> is table of<DATA TYPE>


Index by table:

index by table is a collection in which the array size is not fixed

it cannot be created as a database object,
it can only be created inside the subprogram,which can be used only in that program.

BULK COLLECT cannot be used in this collection type as the 

subscript should be given explicitly for each record in the collection

TYPE <type_name> IS TABLE OF <DATA_TYPE> INDEX BY VARCHAR2(10);


DATA TYPE can be either simple or complex type

the subscript/index variable is given as VARCHAR2 type with

maximum size as 10




 


alter table tname
add constraint constraint name primary key (column_name)

alter table tname
add constraint constraint name foreign key(column name) references tablename(column name)


1.PLUGINS:

Plugins enable developers to enhance the existing built in functionality with new item types,region types,
process types and dynamic actions to enhance and customize their application

or

plugins are enable you extend your applications with custom functionality that 	is not available in native in the platform

there are several types of plugins are available:

1.Item plugins:icon picker,print now
2.Region plugin:Year PLanned calender,Google Organization charts
3.Dynamic action plugin:Text area enlarger,Floating scrollbar
4.Authentication Plugin:Facebook authentication plugin,Google authentication plugin
5.Authorization plugin:LDAP Group authorization


2.Name some apex applications you know?
1.Universal theme sample applications
2.P-Track
3.Sample REST Services
4.Sample database applications
5.Apex appication Archieve

3.Apex application builder?
AN appication is a collection of a database driven web pages linked together using tabs,buttons or hypertext links.
the pages within an applicationshare a common session state definition and authentication method.
Applicationn builder is the tool you to build the pages that comprise an application


4.What is the URL of the application?

https://apex.oracle.com/pls/apex/f?p=4750:50:105905810151901::NO

apex.oracle.com===>It is the basic url
4750=>application number
50=>page number
105905810151901=>session number


5.What is the building blocks/components or apex applications?

pages,items,regions,dynamic actions,validations,computations,authentication,authorization,shared components,lists,themes etc

6.How will you define page cache?
Enabling region caching is an effective way improve the performance of static regions such as regions containing lists that do not use conditions or regions containing static HTML.
The Application Express engine only renders a region from cache if it meets the defined condition. Additionally, regions can be cached specific to a user or cached independent of a user.

7.How a page is rendered?

Show page and accept page process

8.Where will you add logout or custom links?

Goto shared components add in navigation bar list

Or

user interface attributes

9.How will you pass value of one item from one page to another?

Passing bind variable 

10.How will you code dynamic PL/SQL regions?

begin
htp.p(<html statements with escape special characters>)
end;

11.What are different caching methods available?
page
for item
for session
for application

12.How will you use AJAX?

ON DEMAND Process

13.What are the uses of Application level processes or how will you create an application level processes? 

In shared components application proccess can be created

Application process run PLSQL logic at specific points for each page in an application or as defined by the conditions under which they are set to fire.
note that "Ajax Callback" process fire only when from ajax or by "Ajax call back" process defined for pages

14.What are available options available to develop list of values?
1.static
2.Dynamic
3.From shared components

15.How will you use lists which can be shared across applications?
shared components

16.How will you create tree list?
in shared components lists options available 
create list 
under that create list entries and make sure that the list entry will be under list
 
17.How will you show default value for an item?

By click on that item
Right side some properties are available in that default option available
there is dropdown will be available
1.static
2.Item
3.sql query
4.sql query returning colon delimited list
5.PLSQL expression
6.PLSQL Function body
7.Sequence

18.How are items named and referenced?

19.How will you process multiple items or array of items?

20.How will you add javascript function to item?

21.Why / How will you use PL/SQL dynamic content?

22.How will you add validations to an item?
In Process we can add validations
1.item is null
2.item is not null
3.item=value
4.item!=value
5.PLSQL expression
6.plsql function body(returning boolean) etc

23.What are the various reports possible?
a)Interactive report
b)Classic report

24.HOw will you use RTF/PDF report options?

25.How will you create parameterized reports?

26.How will you create editable column link? or “Link Column”.
In reports region we can create link to the column or seperately we can create links
For column
Click on that column right properties are available 
identification---type--link

IN report region attribute option available
the link option available:
1.Link to single row view
2.Link to custom target
3.Exclude LInk column

27.How will you add CHECK BOX option as a column in report? 
APEX_ITEM.CHECKBOX

28.what are different kinds of forms available?
a)Form
b)Editable Interactive grid
c)Report with form
d)List view with from
e)Form on local procedure
f)tabular form

29.What are the various charts available?
Area,bar,box plot,bubble,combination,donut,funnel,gantt,line,line with area,pie,polar,pyramid,radar,range,scatter,stock


Can you tell me something about ‘partition by ‘ keyword What is %rowtype

Partition by:

the partition by clause is the sub clause of over clause.
The partition by clause divides query result set into two parts.

the partition clause does not reduce the number of rows returned.

%rowtype:

The %rowtype takes the entire row datatype of columns in a single variable


1...........What are the types of exceptions?
there are two types of exceptions
1.predefined exceptions
there are several types of predefined exceptions
no data found
invalid number
numeric or value error
ZERO error
duplicate val on index
invalid cursor
cursor already open
2.user defined exceptions

Have you heard about raise_application_error.what is it and when do we use it.

Raise_application_error is a predefined exception procedure available in dbms_standard package

-----In oracle if we want to display user defined exception messages in more descriptive form then only we are using this procedure.
If we want to display user_defined exception messages as same as oracle error displayed format then we must use raise_application_error procedure.
this procedure is used either in execute section or the exception section of pl sql block
What is dynamic sql
---Oracle 7.1 introduced dynamic sql
--It is the combination of sql,pl sql i.e sql statement are executed dynamically with pl sql block using execute immediate clause
--Generally in pl sql block we are not allowed to use ddl,dcl statement,using dynamic sql ddl,dcl statement in pl/sql block
------what is sequence and where do we use it
sequence is a autonumber generate in oracle 
syntax:
create sequence sequence_name
minvalue 1
maxvalue 99999999
increament by 1
nocache
How to Delete duplicate records using having clause?

select * from emp e where rowid<>(select max(rowid) from emp e1 where e.2mpno=e1.empno)


Difference between case and decode

case:
--complies with ansi sql
--can work with logical operators other then =
--can work with predicate and searchable queries
--needs data consistency
--null=null return false
 --can be used in pl sql blocks and sql statements
--can be used in parameters while calling  a procedure

decode:
--oracle proprietary
--works with only '=' like operator
--Expressions are scalar values only
--data consistency is not needed
--null is null return true
--can be used in sql statements
--cannot be used parameters while calling parameters

While explaining about performance tuning you told about stats gathering.so can you explain how to avoid the situation where stats becomes zero after truncating table.

Have you heard about resource busy. How to overcome in such case?
Ans:
Follow the below steps to solve
an ORA-00054 truncate error.when trying to perform DDL such as truncate,alter,drop or alter objects that are use by other user,you may encounter the database error ORA-00054 resource busy acquire with NOWAIT specified 

What are triggers.can you give an example.
Triggers are also a pl/sql block which is automatically invoked whenever the user is perform any dml operations on the table

----To create consistencies
-----Access restriction
----Implement securities
---Auditing purpose

Suppose I have a target table into which I need to insert or update rows conditionally based on the existence of records.what would you do in such situation


Ans:In that situation we are using MERGE statement


Difference between rank and dense_rank

Rank:(skip the order of the rank)
rank will gives the order of the rank of a each row specified by order by clause

Ex:select ename,empno,sal,rank()over(order by sal desc) as ranking from emp

Dense_rank:(it will not skip the order of the rank)
Dense rank is also gives the order of rank specified by order by clause

Ex:select ename,empno,sal,dense_rank()over(order by sal desc) as ranking from emp.

What are cursors and where do we use them?
Ans:cursor is private sql area
which is used to process multiple records or record by record process
syntax:
declare cursor
open cursor
fetch cursor
close cursor

What are packages and why do we use packages ?
Ans::
Packages are also named plsql blocks which is used to creating a group of procedures and functions
creating of packages performance improvement 

What do you know about analytical functions?
Ans::
Analytical functions are
lag()
lead()
keep_first()
keep_last()
first_value()
last_value()
rank()
dense_rank()

Can you explain performance tuning


Difference between procedure and function
Ans:
Procedure:
Procedure is a named pl/sql block which accepts some input and perform operation which return may or maynot return a value
procedure cannot be called from sql statement
procedure can be called from begin and end statement
procedure can be stored images

Function:
Function is a named pl/sql block which accepts some input and peform operation must be return a value
function can be called from sql statement
functions cannot be stored images





1)What are constraints and its types?
Constraint is rule per validating the data
constraints are used for conditional insert
constraints are three types:
entity integrity constraints:
check,not null
domain integrity constraints:
primary key,unique
referential integrity constraints:
foreign key

2)Difference between unique key,primary key and foreign key ?
unique key:
it will not allow duplicate values
primary key:
it will not allow duplicate and null values
a table must have only one primaary key
foreign key:
Foreign key is used to build a relationship between two tables

3)what is Difference B/w Rowid And Rownum?
Rowid:
rowid is permanent
rowid is psuedo column
it is a hexadecimal number
rowid is unique
data retrieval faster
rownum:
Rownum is temparory
it is a sequential number
to avoid duplicates

4)what is Difference B/w Lead and Lag?
Lead and lag are analytical functions
lead:by the use of output lead function will be the result is current row and subsequent row
lag:by the use of output function the result will be current row and previous row will be displayed

5)Query to identify and delete duplicate row from a table.
Ans:
to identify the duplicates:
select * from emp e where rowid<>(select max(rowid) from emp e1 where e.empno=e1.empno)
to delete the duplicates:
delete from emp e where rowid<>(select max(rowid) from emp e1 where e.empno=e1.empno)



13)merge syntax.

14)get the previous year latest Sunday.

15)Prgma Exception_init().
16)trigger and types.

1. What is difference between DML and DDL commands? 
2. What is the difference between delete and trucate? 
3. What is the like operator? 
4. Define DDL, DML, DCL? 
5. What is difference between view and materialized view? 
6. What is difference between union and union all? 

8. What is dynamic sql? 
9. What is external table? 
10. What is ref cursor 
11. Sql loader
12. Instr substr regexp 
13. If we remove header from sql loader 
14. DML command in procedures 
15. What is left outer join 
16. Merge table 

1. how to see how many procedure and function associated with a particular table.
2. how to see deleted record.
3. how to email_id from string.

6. cross join,outer join,left outer join,right outer join.

8. trigger(if updating,if inserting,if deleting clause).
9. What is dynamic sql.
10. what is index how many types of indexes are there.
11. how see how many constraint are refered from master table.

12)What is a cursor its attribute and types?
13)What TCL do
14)Order By Class?

16)What is tkprof and how is it used?
17)What is explain plan and how is it used?
18)What is a mutating table error and how can you get around it?
19)What is Autonomous transaction ? Where do we use it?
20)What is a package? What do u mean by overloading?
21)What Is Bulk Collect?



1. How to insert into multiple tables with using PL/SQL constructs? 
2. How to update the base tables in a view? 
3. What are all the joins available in Oracle? 
4. How to restricts the users from modifying the table data? 

8. How to add primary key and check constraint on the table having duplicate records? 
9. How to gather Statistics? 
10. Importing and Exporting data from one database to another? 
11. What will you consider when you look into the select statement for performance tuning? 
12. Why do go for bulk collect? 
13. What will you get with a explan plan? 
14. Can we declare one refcursor and use it multiple times for different DML statements? 




3)why we can use synonym?

5)How can we refresh a Mv?



You change the value for the parameter PLSQL_CODE_TYPE to INTERPRETED from the previously set value of NATIVE. Which two statements would be true in this scenario? 

(Choose two.)
Which statements are true about temporary LOBs? (Choose all that apply.)
Examine the structures of the TEXT_TAB1 and TEXT_TAB2 tables.
In a hospital management system that manages the patient database, a doctor needs access only to information about those patients who are treated by him or her. You 

need to implement row-level security without major administrative overhead on the system. Which is the best method to implement this strategy?
Which two statements are true in the context of executing a Java program from PL/SQL?
You receive the following error when executing a PL/SQL procedure that calls an external C program:

ERROR at line 1:
ORA-28575: unable to open RPC connection to external procedure agent 
ORA-06512: at "OE.CALL_C", line 1 
ORA-06512: at "OE.C_OUTPUT", line 6 
ORA-06512: at line 1

What could be the reason for the error?

What is consistency?
What is the difference between syntax error and runtime error?
what are the two virtual tables available at the time of database trigger execution?

OLD and NEW are two virtual tables available during database trigger execution.


How many types of triggers exist in PL/SQL?
What is a trigger in PL/SQL?

What is the main reason behind using an index?
How exception is different from error?

Does PL/SQL support CREATE command?
How to write a single statement that concatenates the words ?Hello? and ?World? and assign it in a variable named Greeting?

How do you declare a user-defined exception?

6) What is the basic structure of PL/SQL?
ANS:Declaration section
variables
executable section
statements
exceptional section
statements


PL/SQL uses BLOCK structure as its basic structure. Each PL/SQL program consists of SQL and PL/SQL statement which form a PL/SQL block.

PL/SQL block contains 3 sections.

The Declaration Section (optional)
The Execution Section (mandatory)
The Exception handling Section (optional)

What are the datatypes available in PL/SQL?
What is PL/SQL table? Why it is used?
What are the most important characteristics of PL/SQL?
What is the purpose of using PL/SQL?
What is PL/SQL?
Explain three different rules that apply to NULLs when doing comparisons?
Mention what PLVcmt and PLVrb does in PL/SQL?
Mention what is the use of function “module procedure” in PL/SQL?
Why PLVtab is considered as the easiest way to access the PL/SQL table?
When you have to use a default “rollback to” savepoint of PLVlog?
Mention what is the function that is used to transfer a PL/SQL table log to a database table?
Mention what problem one might face while writing log information to a data-base table in PL/SQL?
Explain how exception handling is done in advance PL/SQL?
(PL/SQl provides an effective plugin PLVexc)
Mention what does PLV msg allows you to do?
How would you convert date into Julian date format?
What is out parameter used for eventhough return statement can also be used in pl/sql?
Explain polymorphism in PL SQL.
Differentiate between SGA and PGA.
Explain autonomous transaction.
Explain the uses of Control File.
How would you reference column values BEFORE and AFTER you have inserted and deleted triggers?
What are sequences?
What is an Intersect?
What are character functions?
Explain TTITLE and BTITLE.
If a cursor is open, how can we find in a PL SQL Block?
Define Implicit and Explicit Cursors.
Explain Commit, Rollback and Savepoint.
Differentiate between Syntax and runtime errors.
Differentiate between % ROWTYPE and TYPE RECORD.
What are different methods to trace the PL/SQL code?

Q13. What is the difference between a Rollback Command and a Commit Command?
Q14. What is a Statement Level Trigger?
Q15. What are the different parts of an Explicit Cursor?
Q20. What is Context Area in PL/SQL?
Q25. What rules are to be taken care of when doing comparisons using NULL?
Q29. What is the maximum limit of applying Triggers to a Table?
Q31. What is a Row Level Trigger?
Q32. What is an Active Set?
Q33. What are the different Loop Control Structures used in PL/SQL?
Q36. Explain the difference between Truncate and Delete?
Q38. What are the disadvantages of Cursors and is there any alternative to it?
Q39. What is the method to display messages in Output Files and Log Files?
Q43. Explain the difference between Varchar and Char?
Q44. Explain Union, Union All, Intersect and Minus in PL/SQL.- give live examples of where have you used it in your projects
Q47. Enlist the packages provided by the Oracle for use by the Developers?
Q51. Enlist the methods to recover from Deadlock
Q41. Enlist the Attributes of a Cursor in PL/SQL.
Explain about Pragma Exception_Init.
Enlist various loops in PL/SQL Database.
Which is the Default Cursor in Oracle PL/SQL?
20. How can you Rollback a particular part of a procedure or any PL/SQL Program?

18.What are the areas where the tuning of the database is needed?
17.What are the tools provided by oracle to assist performance tuning?
16. Explain rule-based optimizer and cost-based optimizer.?

13. What is RAISE_APPLICATION_ERROR ?
12. What do u mean by overloading?
11. What are SQLCODE and SQLERRM and why are they important?
10. What is a mutating table error and how can you get around it?

7. How can we refresh a snapshot?
6. Attributes Of a Implicit Cursor:
4. What are the benefits of PL/SQL packages?
3.  Mention what PL/SQL package consists of?
1. Explain the uses of database trigger?
2. What is the method to display messages in Output Files and Log Files?



Can you give examples of errors associated with cursors
how do you skip the first 10 records in sql loader
while inserting values from flat file into col 1 col 2 col3 if you were to skip col1 and col 2 how do you do this?
how do you define error limit for sql loader - say of 100 records 5 records failed how to determine have your generated or spooled file from a table - how do you do 

this?
how can you insert values into one table from multiple tables
suppose a table has 100 child tables connected by foreign key then how do we modify the master table without having to drop all the foreign keys??
how to see how many constraint are refered from master table 
how to see how many procedure and function associated with a particular table


How to add primary key and check constraint on the table having duplicate records?
Importing and Exporting data from one database to another? i.e he asked how toconvert flat file into tables just using plsql
Can we declare one refcursor and use it multiple times for different DML statements?
define dml,dd,and tcl commands anddifferentiate btwn them
trigger(if updating,if inserting,if deleting clause).
What is the like operator? also if i want to extract those names frm emp table which start with abh and are only 10 characters long how wud i write tje syntax??

Can you give examples of errors associated with cursors
explain inline views,nested tables,varrays

Some more ket advance concepts
Have you ever used bulk processing? Why?
8. How might you determine to use PL/SQL Native Compilation to speed your code?
7. Name a tracing utility that helps isolate PL/SQL problems and describe what it does.
6. Name the two profiler tools and describe what they do.
5. What does the PL/SQL Optimizer do?
4. Besides running an EXAPLAIN PLAN to view the execution path of a SQL statement, what other means might you use to view explain plans?
What is Cursor Variables or REF CURSOR ? give an example
Mention what does PLV msg allows you to do?


10.how many columns are ther are in dual 
ANS:only one column that is 'dummy'
only one row is available that is 'X'

Q)what is virtual column


A virtual column is a table column whose values are calculated automatically using other column values, or another deterministic expression.


Q)authid
Q)list of all changes made by a person?
Q)text in the procedure
Q)user_objects
Q)which is faster in or exists(exist is faster)
Q)bulk collection
Q)pseudocolumns
Q)max number of triggers(12)
Q)Tablespace created when database is created
Q)diff between strong cursor and refcursor
Q)diff between varchar & char
char:
char datatype is a fixed datatype
if the datatype size is 10 and we are inserting 5 characters it will be memory will be released
Varchar2:
Varchar2 is a variable datatype
if the datatype size is 10 and we are inserting 5 characters it will be adjustment to that size

Q)how can we pop multiple dates without loops
Q)Function overloading
Q)reset a sequence
Q)types of indexes
Q)Sql loader
Q)error limit in sql loader
Q)conventional and direct method
Q0view and materialized view diff
Q)how to get 1st day of the month
Q)partitions
Q)why do we use partitions
Q)from employee table reteive employees salry greater than 30000,empid,department name
department id and deptname
employeeid empsal deptid
Q)clustered index
Q)differnce between 11g and 12c
Q)how to delete allthe data from all tables
Q)all_tables & user_tables difference
Q) to delete all data from all tables
Q)what is dynamic sql
Q)example of static sql
Q) how to write dynamic delete
Q)parsing xml_cursor(no idea)
Q)xml packages in oracle
Q)how to find the statements whichare using truncate in packages
Q)how to retrieve same statement in a table 100 times(i.e., the o/p shld be 100 times even though there is one record)
Q)find highest sal of every department
Q)what are ddl and dml statements

Q)why should i use function

Q)find 3rd highest sal
Ans:
select empno,ename,sal from emp e where 3=(select count(sal) from emp e1 where e.empno<=e1.empno)

Q)if a target table exists and we want to insert a record from child table if it doesnt exist
Q)can i use where clause with merge
Q)cqn we insert multiple data into all tables
Q)triggers
Q)What is mutating table error
Q)how to overcome this error
Q)diff between cursor and normal cursor
Q)what is cursor for all	
Q)how to delete a csv file 
Q)in sql loader if we want to skip n number of records how to do dat
Q)how to control the error count in sql loader
Q)dynamic sql
Q)generate utl file having table name and number of records in schema

Q)cursor attributes
Q)how to find text in a procedures or packages
Q)which is faster in or exists
Q)bulk collection
Q)diff between strong and weak cursor

Q)load dates in a month without using loop
Q)what is function overloading
Q)what is the difference between cycle and nocyccle in sequence
Q)diff between conventional and direct loading method
Q)how to get first day of the month
Q)what is partition
Q)what is connect by prior 
Q) difference between lead and lag
Q)i have a table a,where i am running select * from customer it returns within  a minute,but in a afternoon it takes more minute y is dat
Q)compute statistics
Q)i want to see how many employees for a paticular department are there
ANS:
select deptno,count(empno) from emp
group by deptno
order by deptno asc

Q)write a aquery to increase the sal 10% but basing on department number it should not go above 20,000
Q)how to load data into a table using sql loader
Q)what is discard file
Q)have u used external tables explain
Q)what is read only tables
Q)what is sql
Q)differnece between dbms and rdbms

Q)dataobjects in database
--
Q)item and location 2 columns are presnt in a table.There are 3 rows for item with cocacola and location as karnataka,mp and kerala.Write a query to commanly separated values of location for this item cocacola
Q)types of cursors
Q)diff between a procedure and function
Q)can we call a procedure in a function
---Stored procedures cannot be called from function
---Functions can be called from select statement
---Procedures cannot be called from select/where/having and so on statements 
---Execute/exec statement can be used to call/execute stored procedure
Q)what is bulk collect
Q)errors encountered in bulk collect
Q)differnce between forall and for loop
Q)there is a 1 single record in a table but u wannt to populate the data 10times
Q)level in oracle
Q) what is  a shell in unix
Q)how will u a load data using sql loader
Q) what are the inputs taken by sqlloader and what are the outputs we get in sql loader
Q)unable to get stable set of records
what is merge statement and syntax
how can you upate and insert records into multiple tables at a same time
====>how can you delete all records from two tables at a same time using one single command?


Database link:

A database link is a schema object that in one database enables you to access objects on another database

the other database need not to be a oracle database system

In sql statements you can refer to a table or view on the other database by appending @dblink to the table or view name.
  Materialized View:

A materialized view is a database object that stores query output and precomputed output

To maintain local copy of remote database object

To improve the performance of complex group by and complex aggregate operations

syntax:

create materialized view <view>
as
select statement;


If it is a view oracle stores query

If it a materialized view oracle stores query output



If the base table data is changed the materialzed view data will not be changed



the updating the materialized view by

A materialized view can be refreshed in many ways

1.ON demand

2.ON commit

3.periodically


refresh matarialized view

execute dbms_mview.refresh(mview name);


INDEX:

Index is a database object that makes the data retrival faster

==> A db index works the same way as an index in text book.in text book using index a particular topic is located fastly,using db index a record can be located fastly

==>index can be created on columns and that column is called as index key

types of indexes:

1.BTREE indexes
2.BITMAP indexes

syntax of btree index:

create index indexname on <table name<column name>>

to show the execution plan

set autotrace on explain


Cluster:

cluster is database object that stores data related to two or more tables in a single disk space 

steps to create a cluster:

1.create cluster

2.create index on cluster

3.create tables

syntax:

create cluster cluster_name(variable_name datatype);


create index index_name on cluster cluster_name;

create table(columnname1 datatype,columnname2 datatype)cluster clustername(variable)


if we are create the two tables by organizing the cluster with single column i.e deptno it will strored into the single memory location


how to see it will be stored in a single memory location by using rowid same rowid will be allocated to both tables



Locking:

concurrent access:

Accesing same data by number of users at the same time

types of modes in locking:

exclusive lock mode:

prevents the associates resource from being shared.this lock is to obtained to modify the data.the first transaction to lock aresouce exclusively is the only transaction that can alter the resource until the exclucive lock is released

Oracle 8i:

----Materialized view
---rollup and cube
---Autonomous transactions
---Analytical functions
---bulk bind
---trim() function

Oracle 9i:

---Merge statement
---renaming a column
---9i joins or ansi joins
---Flashback queries
---Multiple inserts


Oracle 10g:

--Introduced to recylcle bin
--Falshback table
---indices of clause(pl sql)
--wm_concat()
---regular expressions


Oracle 11g:

---introduce to continue statement in pl sql loops
--read only tables
--virtual columns
--pivot()
--simple integer datatype in pl sql
--compound triggers
--sequence are used in pl sql without using dual table
--Follow clause in triggers
--enable,disable clauses are used in trigger specification
--named,mixed notations are used in a subprogram executed by using select statement

pragma autonomous transaction:

if we want seperate trasactions for procedures create procedure with pragma autonomous transaction
A commit or rollback command in procedures effects only transaction started in procedure
but not effect in main program



create or replace procedure update_sal(e in number)
is
pragma autonomous_transaction;
begin
update emp set sal = sal+ 1000 where empno =e;
rollback;
end;


set serveroutput on
begin
update emp set sal=sal+1000 where empno=7369;
update_sal(7499);
commit;
end;


There are total 5 pragmas till 11g
Autonomous_transaction
Exception_init
Serially_reusable
Restrict_references
Inline 
Pragma UDF (12c)?

Pragma exception_init:

pragma_exception_init(user defined exception,error code);


declare
vdno dept.deptno%type;
child_found exception;
pragma exception_init(child_found,-02292);
begin
delete from dept where deptno=:vdno;
exception
when child_found then
dbms_output.put_line('child record found');
end;


raise application error:

using this procedure we can associate an error number with the custom error message

combining both the error number and the custom error message you can compose an error string

which looks similar to those default error strings which are displayed by oracle engine when an error occurs.

collections:

collections is a group of elements of same type

there are three types of collections

1.pl/sql table or index by table

2.varray

3.nested table


if we want to use pl sql table first 

1 declare type

2 declare variable 

syntax:

type name is table of data type index by datatype; 

Record type or pl sql record:

It is one of the user defined temparory data type which is used to store more than one table data or to assign more than one column datatypes

they must atleast contain one element

pinpoint of data is not possible

DECODE:

Decode compares expression to each search value one by one,if expression is equal to a search,then oracle database returns the corresponding result,
if no match is found then oracle returns default.if default is omitted then oracle returns null.


difference between rowid and rownum:

Rowid                                                  Rownum
======                                                =========

1.Physical address of the row                 1.Rownum is the sequential number,allocated to each returned row during query execution

2.Rowid is permanent                          2.Rownum is temporary

3.Rowis is 16 bit hexa decimal                3.rownum is numeric

4.Rowid gives address of the rows or records  4.Rownum gives count of records

5.Rowid is automatically generated unique id
of a row and its generated at the time insertion of row 5.Rownum is an dynamic value automatically

6.Rowid is the fastest means of  accessing data  6.it represents the sequential order in which oracle has retrieve the row

 Trigger:

Trigger is also same as stored procedure and it also it will automatically invoked whenever dml operation performed  against the table or view.

there are two types of triggers supported by pl/sql

1.statement leveltrigger

2.row level trigger

In statement level trigger,trigger body is executed only once for dml statement,
where as in row level trigger,trigger bodyis executed by each row for DML statement

syntax:

create or replace trigger trigername
before/after  insert/update/delete on tablename
[for each row]
[when condition]
[declare]

varaible declaration,cursors,userdefined exceptions;

begin

[excepton]

end;

row level trigger:

qualifiers are used in trigger specification,trigger body

syntax:
:old.columnname

syntax:
:new.columnname



Row level trigger application:

1.Auditing a column:
In all databases whenever we are modifying column data then,those transaction are automatically stored in another table is called auditing a column.

in oracle we are implementing auditing a column by using update of clause in trigger specification

syntax:
update of column name

package is database objects which encapsulates global variables,constraints,cursors,procedure,
functions into a single unit...

generally packages also used to improves performance of the the applications
because whenever we are calling packages subprogram first time then automatically the total package
load into memory area


package also having two parts--

1.package specification

2.package body

syntax:

package specification

create or replace package packagename
is/as
--global variable declaration,constant declarations
---cursor declaration,types declaration,procedure declaration,function declaration
end;


package body:

create or replace package body packagename
is/as
procedures implementation;
funtion implementation;
end {package name}

executing package subprograms:

1.calling package procedure:

method1:

syntax:

exec
package.procedurename(actual parameters);


method 2:

begin
packagename.procedurename(actual parameters);
end;


calling package functions:

method1:
using select statement

select packagename.functionname(actual parameters) from dual;


method 2:using anonymous block

begin
varname:=packagename.functionname(actual parameters);
end;

note:

generally packages doesn't accept parameters and also packages can't nested and also can't invoked directly.



overloading procedures:
-------------------------

overload is refers to same name can be used for different purpose in oracle, we can also implement overloading implement overloading procedure through package.

overloading procedure having same name with diffrent type or different no of parameters

syntax:
create or replace package pz1
is
procedure p1(a number,b number);
procedure p1(x number,y number);
end;

-----------------------------

state of the global variable===>

in oracle if we want to maintain the state of the global variable or state of the cursor then we must use pragma serially_reusable in package.


syntax:
pragma serially_reusable;



types used in packages:

--In oracle we are creating our own datatype by using type keyword 

--In oracle we are creating user define types in two step process i.e first we are creating our own userdefine datatype from appropriate syntax
then only we are creating a variable from that user define type

pl/sql having following userdefine types:

1.pl/sql record
2.index by table or pl/sql table or associative array
3.nested table
4.varray
5.refcursor
----------------------------------------------
Difference between where clause and having clause:

Where:                                                                             
1.where clause is used to select specific rows
2.Conditions applied before group by
3.Use where clause if condition doesnot contain group functions

Having:
1.Having clause is used to select specific groups
2.condition applied after group by
3.use having clause if condition contain group functions

-------------------------------------------------
Constraints:

Novalidate:
If constraint is added with novalidate.oracle doesn't validate existing data.it validates only new data
Delete rules:
There are 3 rules 
ON DELETE NO ACTION
ON DELETE CASCADE
ON DELETE SET NULL

These rules specifies how child rows are affected if parent row is deleted
these rules are declared with foreignkey

ON DELETE NO ACTION:
Parent record cannot be deleted if it is associated with child records

ON DELETE CASCADE:

If parent row is deleted then it is deleted along with child rows


ON DELETE SET NULL:
if parent row is deleted then it is deleted without deleting child rows
but foreign key set to null value
------------------------------------------------------------------------------
Locking:
when the user encounters the following problems when the data is accessed concurrently

--Dirty read
--Phantom read
--lost update
--Non repeatable mode

to overcome these problems every database system provides a mechanism called locking mechanism

locks are two types:
--shared lock
--Exclusive lock

Dead lock is the situation where two transctions are mutually waiting for one another to release locks.
when dead lock occurs oracle throws exception so that one transaction can be cancel and continue with another

----------------------------------------------------------------------------------------

Sequences:
sequence is database object used to generate values for primary key columns
primary key values can't be entered by user must be generated by oracle

Syntax:
CREATE SEQUENCE <sequence name>
start with<value>
increament by <value>
max value<value>
min value<value>
[cycle/no cycle]
[cache<size>]


sequence has two psuedo values
1.currval--current value
2.nextval--next value

nocycle:
it start with min value and  generates upto max value
when reached to max value it stops

cycle:
it starts with min value and generates upto max value
once reaches to max value it will reset to min value

cache 100:
oracle server reallocates next 100 values in cache memory 
so accessing cache memory must be faster than these
so this improves performance
--default cache size 20
--cache size must be less than one cycle


user_sequences:
stores information about sequences created by user

-------------------------------------------------
View:
=>a view is a subset of table or virtual table or representation of query
=>Views are created for two reasons
1.For security
2.To reduce complexity

by creating view we can grant specific columns and specific rows to users

A view is called virtual because it doesn't store data and does't occupy memory it is always derives data from table


----------------------------------------------------
SYNONYM:
Another name or alternative name for table/view
==>
synonyms are created if
1.If the table name is lengthy
2.To access the table without ownername

Syntax:
create synonym<synonym name>for<tabname> 
-------------------------------------------------------------------
ALIAS  VS SYNONYM

Alias:
1.scope of alias upto that query only can't access outside query
2.Not stored in database
Synonym:
1.Synonym can be accessed in any query
2.Synonym stored in database

-------------------------------------------------------------------------
Indexes
=>Index is a databse object that makes the data retrieval faster
=>Using indexes oracle locate the records in table fastly
=>Indexes created on columns and that columns is called index key
types of indexes:
BTREE indexes
simple
composite
unique
function based

syntax:
create index <indexname>on<tablename(columnname)>

time taken by oracle to run query
SET TIMING ON

To see execution plan:
SET AUTOTRACE ON EXPLAIN

Composite index:
if the index is based on two or more columns then create composite index

create index<indexname>on <tablename(column1,column2)>

Unique index:
=>A unique index is does't allow duplicate values into column on which index is created
=>Primary key columns and unique columns are automatically indexed by oracle
create unique index<index name>on<tablename(columnname)>

Difference between BTREE and BITMAP indexes:
BTREE:
1.created on highcardinality columns
2.stores index keys
3.stores rowids
BITMAP:
1.created on low cardinality columns
2.stores bits
3.doesn't store rowid's

---------------------------------------------------------
Materialized Views:
=>it is also called as database object that stores the query reslut or precomputed result
=>MV are widely used in very large database means DWH
=>M.Views improves performance of queries performing join and group by operations

Syntax:
create materialized view<name>
as
select statement

EX:
create materialized view mv1
as
select deptno,sum(sal) as sumsal
from emp
group by deptno


if the base table is updated then the mv is not updated
Refreshing mv:
=>BY default mv is not updated
=>MV is updated in two ways
1.Manually
2.Automatically
Manually:
EXECUTE DBMS_MVIEW.REFRESH(materializedview name)

Automatically:
1.Refresh on commit
2.Refresh based on timeinterval

Create materialized view mv2
refresh on commit
as
select deptno,sum(sal) as sumsal
from emp
group by deptno;
-------------------------------------

userdefined exceptions:

Plsql user defined exception to make our own exception.

create a variable in declare section

the raise the exception.

example:

declare
myex exception;
i number;
begin
for i in(select * from emp) loop
   if i.empno=7788 then
    raise myex;
   end if;
end loop;
exception 
when myex then
dbms_output.put_line('EMployee number does not exist');
end ;


 


triggers==>

to implement securities
audit log purpose
access restriction
the trigger will fire any dml operations performed against the table


packages
plsql block
package specification
package body


=======forward declaration=====

index by table
varray
nested

bulk collect

============


Pragma autonomous_transaction

changes the way subprogram works within a transaction
in the subprogram we can do operations commit,rolback without commiting or rollbacking the main transaction


========================

collections are most useful things when a large data of same type need to be processed or manipulated.

Varrays
nested tables
index by table


Varrays:

Varray is a collection method in which the size of the array fixed

the size of array cannot exceeds than fixed value

the subscript of the varray is of a numeric value

type <type_name> is varray (<size>) of <data_type>


Nested Tables:

Nested table is a collection method in which the size of the array is not fixed

Since the upper size limit is not fixed,the memory needs to be extended each time before we use it.

we can extend the collectioon using EXTEND 

TYPE <type name> is table of<DATA TYPE>


Index by table:

index by table is a collection in which the array size is not fixed

it cannot be created as a database object,
it can only be created inside the subprogram,which can be used only in that program.

BULK COLLECT cannot be used in this collection type as the 

subscript should be given explicitly for each record in the collection

TYPE <type_name> IS TABLE OF <DATA_TYPE> INDEX BY VARCHAR2(10);


DATA TYPE can be either simple or complex type

the subscript/index variable is given as VARCHAR2 type with

maximum size as 10


Difference between correlated queries and non correlated queries in oracle?


correlated queries:

execute the outer first then sub query execute next

example:

select * from dept d where deptno in
(select deptno from emp e where e.deptno=d.deptno)

but in non correlated query execute the inner query first then outer query next.

select * from dept 
where deptno in(select deptno from emp);



Oracle apex uses 3 tier architecture which comprises of the browser,web server and database.

So whenever we are submitting a page the browser sends the request through the middle to the ORDS

and then it traces back thorugh the middle layer and then to the browser again.

So this combined technology stack is called the Oracle RAD Stack


the R stands for rest data serevices
it's ORDS whic means oracle rest data services 
it bridges the HTTPS oracle database
it submits java applications and provide restful APIs
the second is A for the apex

D is for Database
which integrated with oracle apex and manages the backend part

oracle apex also uses a metadata driven architecture.
which is integrated with oracle apex and manages the backend part.
which means whenever you're trying to create or extend an application or a page,
the oracle apex will try read the metadata from table and displaces it in the web page.


COALSCE:

This function returns the first not null expression
if all the expressions evaluates nul the coalsce function will return null

syntax:

select coalsce(1,2,3) from dual;


Can you create a primary key the column is having duplicate values?

Yes we can create.

First we need to create a index

create index index_name 
on tablename(colname);

then wee need to create a primary key;

alter table tname 
add constarint c_name primary key (colname) using index ind_name enable novalidate;



undertsanding the url of the oracle apex:

https://apex.somewhere.com/pls/apex/f?p=4350:1:220883407765693447


apex.somewhere.com is the URL of the server.

pls is the indicator to use mod_plsql catridge.

apex is the database access descriptor (DAD) 
the DAD describes how http server connects to the database server so that is can fullfill an http request
the defaut value is apex

f?p prefix used by oracle apex

4350 is application being called
1 page nunmber 

23923237371 session number

 What is a Dual Table?
The dual table is owned by the user SYS and can be accessed by all users.
 It contains one columnDummy and one row with the value X. The Dual Table is useful when you want to return a value only once. 
The value can be a constant, pseudocolumn, or expression that is not derived from a table with user data.



NVL: Converts a null value to an actual value. NVL (exp1, exp2) .If exp1 is null then the NVL function returns the value of exp2.

NVL2: If exp1 is not null, nvl2 returns exp2, if exp1 is null, nvl2 returns exp3. The argument exp1 can have any data type. NVL2 (exp1, exp2, exp3)

NULLIF: Compares two expressions and returns null if they are equal or the first expression if they are not equal. NULLIF (exp1, exp2).


What is the use of Double Ampersand (&&) in SQL Queries? Give an example?

Use “&&” if you want to reuse the variable value without prompting the user each time.

For ex: Select empno, ename, &&column_name from employee order by &column_name;


what are the apex views?

apex_applications
apex_application_all_auth
apex_application_auth
apex_application_authorization
apex_application_items
apex_application_groups
apex_application_lists
apex_application_list_entries
APEX_APPLICATION_PAGES