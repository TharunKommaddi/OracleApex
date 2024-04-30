Can you tell me something about ‘partition by ‘ keyword What is %rowtype

Partition by:

the partition by clause is the sub clause of over clause.The partition by clause divedes query result set into two parts.

the partition cluase does not reduce the number f rows returned.

%rowtype:

The %rowtype takes the entire row datatype of columns in asingle variable


1...........What are the types of exceptions?
there are two types of exceptions
1.predefined exceptions
thre are several types of predefined exceptions
no data found
invalid number
numeric or value error
ZERO error
duplicate val on index
invalid cursor
cursor already open
2.user defined exceptions

Have you heard about raise_application _error.what is it and when do we use it.

Raise_application_error is a predefined exception procedure available in dbms_standard package

-----In oracle if we want to display user defined exception messages in more descriptive form then only we are using this procedure.If we want to display user_defined exception messages as same as oracle error displayed format then we must use raise_application_error procedure.this procedure is used either in execute section or the exception section of pl sql block
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
g --can be used in pl sql blocks and sql statements
--can be used in parameters while calling  a procedure

decode:
--oracle proprietary
--works with only '=' like operator
--Expressions are scalr values only
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

Rank:
rank will gives the order of the rank of a each row specified by order by clause

Ex:select ename,empno,sal,rank()over(order by sal ) as ranking from emp

Dense_rank:
Dense rank is also gives the order of rank specified by order by clause

Ex:select ename,empno,sal,dense_rank()over(order by sal) as ranking from emp.

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
Procedure is a named pl/sql block which accepts soome input and perfrm operation which return may or maynot return a value
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
lag:by the use of uotput function the result will be current row and previous row will be displayed

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

18.          What are the areas where the tuning of the database is needed?
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


 how many columns are ther are in dual 
ANS:only one column that is 'dummy'
only one row is availablr that is 'X'

Q)what is virtual column

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

Q)if a target taable exists and we want to insert a record from child table if it doesnt exist
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

In statement level trigger,trigger body is executed only once for dml statement,where as in row level trigger,trigger bodyis executed by each row for DML statement

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
---cusor declaration,types declaration,procedure declaration,function declaration
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
=>Using indexesoracle locate the records in table fastly
=>Indexes created on columns and that columns is called index key
types of indexes:
BTREE indexes
simple
composite
unique
functtion based

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
=>Aunique index is does't allow duplicate values into column on which index is created
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
=>M.Views improves performnace of queries performing join and group by operations

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
--------------------------------------








 



























