# 1. Can you tell me something about `partition by` keyword and `%rowtype`?

### Partition by:

- the partition by clause is the sub clause of over clause.The partition by clause divedes query result set into two parts.
- the partition cluase does not reduce the number f rows returned.

### %rowtype:

- The %rowtype takes the entire row datatype of columns in asingle variable


# 2. What are the types of exceptions?

There are two types of exceptions

**Predefined exceptions** : There are several types of predefined exceptions:

- no data found
- invalid number
- numeric or value error
- ZERO error
- duplicate val on index
- invalid cursor
- cursor already open
- User defined exceptions
    

# 2. Have you heard about raise_application _error. what is it and when do we use it?

- Raise_application_error is a predefined exception procedure available in dbms_standard package
- In oracle if we want to display user defined exception messages in more descriptive form then only we are using this procedure.If we want to display user_defined exception messages as same as oracle error displayed format then we must use raise_application_error procedure.this procedure is used either in execute section or the exception section of pl sql block


# 3. What is dynamic sql?
- Oracle 7.1 introduced dynamic sql

- It is the combination of sql, pl sql i.e sql statement are executed dynamically with pl sql block using execute immediate clause

- Generally in pl sql block we are not allowed to use ddl,dcl statement,using dynamic sql ddl,dcl statement in pl/sql block

# 4.What is sequence and where do we use it ?

Sequence is a autonumber generate in oracle 

**syntax:**
```
create sequence sequence_name
minvalue 1
maxvalue 99999999
increament by 1
nocache
```

# 5. How to Delete duplicate records using having clause ?

```
select * from emp e where rowid<>(select max(rowid) from emp e1 where e.2mpno=e1.empno)
```

# 6. Difference between `CASE` and `DECODE`:

**CASE**:
- Complies with ANSI SQL.
- Can work with logical operators other than `=`.
- Can work with predicate and searchable queries.
- Needs data consistency.
- `NULL=NULL` returns false.
- Can be used in PL/SQL blocks and SQL statements.
- Can be used in parameters while calling a procedure.

**DECODE**:
- Oracle proprietary.
- Works with only `=` like operator.
- Expressions are scalar values only.
- Data consistency is not needed.
- `NULL IS NULL` returns true.
- Can be used in SQL statements.
- Cannot be used in parameters while calling parameters.

# 7. While explaining about performance tuning you told about stats gathering. So can you explain how to avoid the situation where stats becomes zero after truncating table.

- no answer

# 8. Have you heard about resource busy. How to overcome in such case?

- Follow the below steps to solve
an ORA-00054 truncate error.when trying to perform DDL such as truncate,alter,drop or alter objects that are use by other user,you may encounter the database error ORA-00054 resource busy acquire with NOWAIT specified 


# 9. What are triggers.can you give an example ?
Triggers are also a pl/sql block which is automatically invoked whenever the user is perform any dml operations on the table

- To create consistencies
- Access restriction
- Implement securities
- Auditing purpose

# 10. Suppose I have a target table into which I need to insert or update rows conditionally based on the existence of records.what would you do in such situation ?

- In that situation we are using MERGE statement

# 11. Difference between rank and dense_rank ?

**Rank:**

- rank will gives the order of the rank of a each row specified by order by clause

- `Ex:`select ename,empno,sal,rank()over(order by sal ) as ranking from emp

**Dense_rank:**

- Dense rank is also gives the order of rank specified by order by clause

- `Ex:`select ename,empno,sal,dense_rank()over(order by sal) as ranking from emp.

# 12. What are cursors and where do we use them ?

cursor is private sql area, which is used to process multiple records or record by record process

**syntax:**

- declare cursor
- open cursor
- fetch cursor
- close cursor

# 13. What are packages and why do we use packages ?

- Packages are also named plsql blocks which is used to creating a group of procedures and functions
creating of packages performance improvement 

# 14. What do you know about analytical functions ?

Analytical functions are
- lag()
- lead()
- keep_first()
- keep_last()
- first_value()
- last_value()
- rank()
- dense_rank()

# 15. Can you explain performance tuning ?
- No Answer

# 16. Difference between procedure and function ?

**Procedure:**

- Procedure is a named pl/sql block which accepts soome input and perfrm operation which return may or maynot return a value
- procedure cannot be called from sql statement
- procedure can be called from begin and end statement
- procedure can be stored images

**Function:**

- Function is a named pl/sql block which accepts some input and peform operation must be return a value
- function can be called from sql statement
- functions cannot be stored images

# 17. What are constraints and its types ?

- Constraint is rule per validating the data
- constraints are used for conditional insert

**constraints are three types:**

- entity integrity constraints:
- check,not null
- domain integrity constraints:
- primary key,unique
- referential integrity constraints:
- foreign key


# 18. Difference between unique key, primary key and foreign key ?


**unique key:**

- it will not allow duplicate values

**primary key:**

- it will not allow duplicate and null values
- a table must have only one primaary key

**foreign key:**

- Foreign key is used to build a relationship between two tables




# 19. What is Difference B/w Rowid And Rownum ?

**Rowid:**

- rowid is permanent
- rowid is psuedo column
- it is a hexadecimal number
- rowid is unique
- data retrieval faster

**rownum:**

- Rownum is temparory
- it is a sequential number
- to avoid duplicates

# 20.Wwhat is Difference B/w Lead and Lag ?

- Lead and lag are analytical functions
**lead:** by the use of output lead function will be the result is current row and subsequent row
**lag:** by the use of uotput function the result will be current row and previous row will be displayed

# 21. Query to identify and delete duplicate row from a table ?

**to identify the duplicates:**

```
select * from emp e where rowid<>(select max(rowid) from emp e1 where e.empno=e1.empno)
```


**to delete the duplicates:**

```
delete from emp e where rowid<>(select max(rowid) from emp e1 where e.empno=e1.empno)
```

# 22. Merge Syntax ?

# 23. Get the Previous Year Latest Sunday ?

# 24. PRAGMA EXCEPTION_INIT() ?

# 25. Trigger and Types ?

# 26. Cross join, outer join, left outer join, right outer join.

# 27. Trigger (if updating, if inserting, if deleting clause) ?

# 28. What is dynamic SQL ?

# 29. What is an index and how many types of indexes are there ? 

# 30. How to see how many constraints are referred from a master table ?

# 31. What is a cursor, its attributes, and types ?

# 32. What does TCL do ?

# 33. Order By Clause ?

# 34. What is TKPROF and how is it used  ?

# 35. What is an explain plan and how is it used ?

# 36. What is a mutating table error and how can you get around it ?

# 37. What is an autonomous transaction ? Where do we use it ?

# 38. What is a package ? What do you mean by overloading ?

# 39. What is Bulk Collect ?

# 40. How to insert into multiple tables using PL/SQL constructs ?

# 41. How to update the base tables in a view ?

# 42. What are all the joins available in Oracle ?

# 43. How to restrict the users from modifying the table data ?

# 48. How to add a primary key and check constraint on the table having duplicate records ?

# 49. How to gather statistics ?

# 50. Importing and exporting data from one database to another ?

# 51. What will you consider when you look into the select statement for performance tuning ?

# 52. Why do go for bulk collect ?

# 53. What will you get with an explain plan ?

# 54. Can we declare one ref cursor and use it multiple times for different DML statements ?

# 55. Why can we use a synonym ?

# 57. How can we refresh a materialized view ?














