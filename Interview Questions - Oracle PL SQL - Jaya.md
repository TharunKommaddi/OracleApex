# 1. Can you tell me something about `partition by` keyword and `%rowtype`?

### Partition by:

- the partition by clause is the sub clause of over clause.The partition by clause divedes query result set into two parts.
- the partition cluase does not reduce the number f rows returned.

### %rowtype:

- The %rowtype takes the entire row datatype of columns in asingle variable

---
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
    
---
# 3. What is dynamic sql?
- Oracle 7.1 introduced dynamic sql

- It is the combination of sql, pl sql i.e sql statement are executed dynamically with pl sql block using execute immediate clause

- Generally in pl sql block we are not allowed to use ddl,dcl statement,using dynamic sql ddl,dcl statement in pl/sql block
---
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
---
# 5. How to Delete duplicate records using having clause ?

```
select * from emp e where rowid<>(select max(rowid) from emp e1 where e.2mpno=e1.empno)
```
---
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
---
# 7. While explaining about performance tuning you told about stats gathering. So can you explain how to avoid the situation where stats becomes zero after truncating table.

- no answer
---
# 8. Have you heard about resource busy. How to overcome in such case?

- Follow the below steps to solve
an ORA-00054 truncate error.when trying to perform DDL such as truncate,alter,drop or alter objects that are use by other user,you may encounter the database error ORA-00054 resource busy acquire with NOWAIT specified 

---
# 9. What are triggers.can you give an example ?
Triggers are also a pl/sql block which is automatically invoked whenever the user is perform any dml operations on the table

- To create consistencies
- Access restriction
- Implement securities
- Auditing purpose
---
# 10. Suppose I have a target table into which I need to insert or update rows conditionally based on the existence of records.what would you do in such situation ?

- In that situation we are using MERGE statement
---
# 11. Difference between rank and dense_rank ?

**Rank:**

- rank will gives the order of the rank of a each row specified by order by clause

- `Ex:`select ename,empno,sal,rank()over(order by sal ) as ranking from emp

**Dense_rank:**

- Dense rank is also gives the order of rank specified by order by clause

- `Ex:`select ename,empno,sal,dense_rank()over(order by sal) as ranking from emp.
---
# 12. What are cursors and where do we use them ?

cursor is private sql area, which is used to process multiple records or record by record process

**syntax:**

- declare cursor
- open cursor
- fetch cursor
- close cursor
---
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

# 58. You change the value for the parameter PLSQL_CODE_TYPE to INTERPRETED from the previously set value of NATIVE. Which two statements would be true in this scenario ? (Choose two.)

# 59. Which statements are true about temporary LOBs ? (Choose all that apply.)

# 60. Examine the structures of the TEXT_TAB1 and TEXT_TAB2 tables.

# 61. In a hospital management system that manages the patient database, a doctor needs access only to information about those patients who are treated by him or her. You need to implement row-level security without major administrative overhead on the system. Which is the best method to implement this strategy ?

# 62. Which two statements are true in the context of executing a Java program from PL/SQL ?

# 63. You receive the following error when executing a PL/SQL procedure that calls an external C program:

```
ERROR at line 1:
ORA-28575: unable to open RPC connection to external procedure agent
ORA-06512: at "OE.CALL_C", line 1
ORA-06512: at "OE.C_OUTPUT", line 6
ORA-06512: at line 1
```

# 64. What could be the reason for the error ?

# 65. What is consistency ?

# 66. What is the difference between syntax error and runtime error ?

# 67. What are the two virtual tables available at the time of database trigger execution ?

# 68. How many types of triggers exist in PL/SQL ?

# 69. What is a trigger in PL/SQL ?

# 70. What is the main reason behind using an index ?

# 71. How is an exception different from an error ?

# 72. Does PL/SQL support CREATE command ?

# 73. How to write a single statement that concatenates the words "Hello" and "World" and assign it in a variable named Greeting ?

# 74. How do you declare a user-defined exception ?

# 75. What is the basic structure of PL/SQL?

```
Declaration section
variables
executable section
statements
exceptional section
statements.
```
- PL/SQL uses BLOCK structure as its basic structure. Each PL/SQL program consists of SQL and PL/SQL statement which form a PL/SQL block.

**PL/SQL block contains 3 sections:**

- The Declaration Section (optional)
- 
- The Execution Section (mandatory)
- 
- The Exception handling Section (optional)

# 76. What are the datatypes available in PL/SQL ?

# 77. What is PL/SQL table? Why it is used ?

# 78. What are the most important characteristics of PL/SQL ?

# 79. What is the purpose of using PL/SQL ?

# 80. What is PL/SQL ?

# 81. Explain three different rules that apply to NULLs when doing comparisons ?

# 82. Mention what PLVcmt and PLVrb does in PL/SQL ?

# 83. Mention what is the use of function “module procedure” in PL/SQL ?

# 84. Why PLVtab is considered as the easiest way to access the PL/SQL table ?

# 85. When you have to use a default “rollback to” savepoint of PLVlog ?

# 86. Mention what is the function that is used to transfer a PL/SQL table log to a database table ?

# 87. Mention what problem one might face while writing log information to a database table in PL/SQL ?

# 88. Explain how exception handling is done in advance PL/SQL ? (PL/SQL provides an effective plugin PLVexc)

# 89. Mention what does PLV msg allows you to do ?

# 90. How would you convert date into Julian date format ?

# 91. What is out parameter used for even though return statement can also be used in PL/SQL ?

# 92. Explain polymorphism in PL/SQL .

# 93. Differentiate between SGA and PGA .

# 94. Explain autonomous transaction .

# 95. Explain the uses of Control File .

# 96. How would you reference column values BEFORE and AFTER you have inserted and deleted triggers ?

# 97. What are sequences ?

# 98. What is an Intersect ?

# 99. What are character functions ?

# 100. Explain TTITLE and BTITLE .

# 101. If a cursor is open, how can we find in a PL/SQL Block ?

# 102. Define Implicit and Explicit Cursors .

# 103. Explain Commit, Rollback and Savepoint .

# 104. Differentiate between Syntax and runtime errors .

# 105. Differentiate between % ROWTYPE and TYPE RECORD .

# 106. What are different methods to trace the PL/SQL code ?

# 107. What is the difference between a Rollback Command and a Commit Command ?

# 108. What is a Statement Level Trigger ?

# 109. What are the different parts of an Explicit Cursor ?

# 110. What is Context Area in PL/SQL ?

# 111. What rules are to be taken care of when doing comparisons using NULL ?

# 112. What is the maximum limit of applying Triggers to a Table ?

# 113. What is a Row Level Trigger ?

# 114. What is an Active Set ?

# 115. What are the different Loop Control Structures used in PL/SQL ?

# 116. Explain the difference between Truncate and Delete ?

# 117. What are the disadvantages of Cursors and is there any alternative to it ?

# 118. What is the method to display messages in Output Files and Log Files ?

# 119. Explain the difference between Varchar and Char ?

# 120. Explain Union, Union All, Intersect and Minus in PL/SQL - give live examples of where have you used it in your projects

# 121. Enlist the packages provided by Oracle for use by the Developers ?

# 122. Enlist the methods to recover from Deadlock

# 123. Enlist the Attributes of a Cursor in PL/SQL.

# 124. Explain about Pragma Exception_Init.

# 125. Enlist various loops in PL/SQL Database.

# 126. Which is the Default Cursor in Oracle PL/SQL ?

# 127. How can you Rollback a particular part of a procedure or any PL/SQL Program ?

# 128. What are the areas where the tuning of the database is needed ?

# 129. What are the tools provided by oracle to assist performance tuning ?

# 130. Explain rule-based optimizer and cost-based optimizer ?

# 131. What is RAISE_APPLICATION_ERROR ?

# 132. What do u mean by overloading ?

# 133. What are SQLCODE and SQLERRM and why are they important ?

# 134. What is a mutating table error and how can you get around it ?

# 135. How can we refresh a snapshot ?

# 136. Attributes Of an Implicit Cursor:

# 137. What are the benefits of PL/SQL packages ?

# 138. Mention what PL/SQL package consists of ?

# 139. Explain the uses of database trigger ?

# 140. What is the method to display messages in Output Files and Log Files ?

# 141. Can you give examples of errors associated with cursors ?

# 142. How do you skip the first 10 records in SQL Loader ?

# 143. While inserting values from a flat file into col1, col2, col3, if you were to skip col1 and col2, how do you do this ?

# 144. How do you define an error limit for SQL Loader - say, of 100 records, 5 records failed. How to determine this ?

# 145. How have you generated or spooled a file from a table - how do you do this ?

# 146. How can you insert values into one table from multiple tables ?

# 147. Suppose a table has 100 child tables connected by foreign keys, then how do we modify the master table without having to drop all the foreign keys ?

# 148. How to see how many constraints are referred from the master table ?

# 149. How to see how many procedures and functions are associated with a particular table ?

# 150. How to add a primary key and check constraint on a table having duplicate records ?

# 151. Importing and Exporting data from one database to another, i.e., how to convert a flat file into tables just using PL/SQL ?

# 152. Can we declare one ref cursor and use it multiple times for different DML statements ?

# 153. Define DML, DD, and TCL commands and differentiate between them .

# 154. Trigger (if updating, if inserting, if deleting clause) .

# 155. What is the LIKE operator ? Also, if I want to extract those names from the emp table which start with "abh" and are only 10 characters long, how would I write the syntax ?

# 156. Explain inline views, nested tables, varrays .

### `SOME MORE KEY ADVANCE CONCEPTS`

# 157. Have you ever used bulk processing? Why ?

# 158. How might you determine to use PL/SQL Native Compilation to speed your code ?

# 159. Name a tracing utility that helps isolate PL/SQL problems and describe what it does.

# 160. Name the two profiler tools and describe what they do.

# 161. What does the PL/SQL Optimizer do ?

# 162. Besides running an EXPLAIN PLAN to view the execution path of a SQL statement, what other means might you use to view explain plans ?

# 163. What is Cursor Variables or REF CURSOR ? Give an example.

# 164. Mention what does PLV msg allows you to do ?

# 165. How many columns are there in DUAL ? **ANS**: Only one column that is 'dummy'. Only one row is available that is 'X'.

# 166. What is a virtual column ?

# 167. What is AUTHID ?

# 168. List of all changes made by a person ?

# 169. Text in the procedure ?

# 170. User_objects ?

# 171. Which is faster, IN or EXISTS ? (EXISTS is faster)

# 172. Bulk collection ?

# 173. Pseudocolumns ?

# 174. Maximum number of triggers (12) ?

# 175. Tablespace created when database is created ?

# 176. Difference between strong cursor and ref cursor ?

# 177. Difference between VARCHAR & CHAR ?

**CHAR**: 

- Char datatype is a fixed datatype. If the datatype size is 10 and we are inserting 5 characters, memory will be released.

**VARCHAR2**:

- Varchar2 is a variable datatype. If the datatype size is 10 and we are inserting 5 characters, it will adjust to that size.

# 178. How can we pop multiple dates without loops ?

# 179. Function overloading ?

# 180. Reset a sequence ?

# 181. Types of indexes ?

# 182. SQL loader ?

# 183. Error limit in SQL loader ?

# 184. Conventional and direct method ?

# 185. View and materialized view difference ?

# 186. How to get the 1st day of the month ?

# 187. Partitions ?

# 188. Why do we use partitions ?

# 189. From the employee table retrieve employees' salary greater than 30000, empid, department name, department id, and deptname ?

**Query:**

```sql
SELECT employeeid, empsal, deptid, deptname 
FROM employee 
WHERE empsal > 30000;
```

# 190. Clustered index ?

# 191. Difference between 11g and 12c ?

# 192. How to delete all the data from all tables ?

# 193. Difference between ALL_TABLES & USER_TABLES ?

# 194. To delete all data from all tables ?

# 195. What is dynamic SQL ?

# 196. Example of static SQL ?

# 197. How to write dynamic delete ?

# 198. Parsing XML cursor (no idea) ?

# 199. XML packages in Oracle ?

# 200. How to find the statements which are using TRUNCATE in packages ?

# 201. How to retrieve the same statement in a table 100 times (i.e., the output should be 100 times even though there is one record) ?

# 202. Find the highest salary of every department ?

# 203. What are DDL and DML statements ?

# 204. Why should I use a function ?

# 205. Find 3rd highest salary ?

**Query:**

```sql
SELECT empno, ename, sal 
FROM emp e 
WHERE 3 = (SELECT COUNT(DISTINCT sal) 
          FROM emp e1 
          WHERE e1.sal >= e.sal);
```

# 206. If a target table exists and we want to insert a record from a child table if it doesn't exist ?

# 207. Can I use WHERE clause with MERGE ?

# 208. Can we insert multiple data into all tables ?

# 209. Triggers ?

# 210. What is a mutating table error ?

# 211. How to overcome this error ?

# 212. Difference between cursor and normal cursor ?

# 213. What is cursor for all ?

# 214. How to delete a CSV file ?

# 215. In SQL Loader, if we want to skip N number of records, how to do that ?

# 216. How to control the error count in SQL Loader ?

# 217. Dynamic SQL ?

# 218. Generate UTL file having table name and number of records in schema ?

# 219. Cursor attributes ?

# 220. How to find text in procedures or packages ?

# 221. Which is faster, IN or EXISTS ?

# 222. Bulk collection ?

# 223. Difference between strong and weak cursor ?

# 224. Load dates in a month without using a loop ?

# 225. What is function overloading ?

# 226. What is the difference between CYCLE and NOCYCLE in sequence ?

# 227. Difference between conventional and direct loading method ?

# 228. How to get the first day of the month ?

# 229. What is partition ?

# 230. What is CONNECT BY PRIOR ?

# 231. Difference between LEAD and LAG ?

# 232. I have a table A, where I am running `SELECT * FROM customer` it returns within a minute, but in the afternoon it takes more minute. Why is that ?

# 233. Compute statistics ?

# 234. I want to see how many employees for a particular department are there ?

**Query:**

```sql
SELECT deptno, COUNT(empno) 
FROM emp 
GROUP BY deptno 
ORDER BY deptno ASC;
```

# 235. Write a query to increase the salary by 10%, but based on department number, it should not go above 20,000 ?

**Query:**

```sql
UPDATE employees
SET salary = LEAST(salary * 1.1, 20000)
WHERE department_id = [Specific Department ID];
```

# 236. How to load data into a table using SQL Loader ?

# 237. What is a discard file ?

# 238. Have you used external tables? Explain.

# 239. What are read-only tables ?

# 240. What is SQL ?

# 241. Difference between DBMS and RDBMS ?

# 242. Data objects in database ?

# 243. There are 3 rows for item with CocaCola and location as Karnataka, MP, and Kerala. Write a query to commonly separated values of location for this item CocaCola.

**Query:**

```sql
SELECT item, LISTAGG(location, ', ') WITHIN GROUP (ORDER BY location) AS locations
FROM table_name
WHERE item = 'CocaCola'
GROUP BY item;
```

# 244. Types of cursors ?

# 245. Difference between a procedure and function ?

# 246. Can we call a procedure in a function ?

**Note:**

- Stored procedures cannot be called from function.
- Functions can be called from a SELECT statement.
- Procedures cannot be called from SELECT/WHERE/HAVING and so on statements.
- EXECUTE/EXEC statement can be used to call/execute stored procedure.

# 247. What is bulk collect ?

# 248. Errors encountered in bulk collect ?

# 249. Difference between FORALL and FOR loop ?

# 250. There is a single record in a table, but you want to populate the data 10 times ?

# 251. Level in Oracle ?

# 252. What is a shell in Unix ?

# 253. How will you load data using SQL Loader ?

# 254. What are the inputs taken by SQL Loader and what are the outputs we get in SQL Loader ?

# 255. Unable to get a stable set of records ?

# 256. What is the merge statement and syntax ?

# 257. How can you update and insert records into multiple tables at the same time ?

# 258. How can you delete all records from two tables at the same time using one single command ?

**Query:**

```sql
DELETE FROM table1;
DELETE FROM table2;
COMMIT;
```

# 259. What is Database link ?

- A database link is a schema object that in one database enables you to access objects on another database
- the other database need not to be a oracle database system
- In sql statements you can refer to a table or view on the other database by appending @dblink to the table or view name.

# 260. What is Materialized View ?

A materialized view is a database object that stores the output of a query, effectively caching precomputed results. This is beneficial for several reasons:

- **Maintaining a local copy of a remote database object**: This helps in scenarios where frequent access to a remote database is necessary, by providing a local snapshot of the data.
  
- **Improving performance**: Especially useful for complex GROUP BY and complex aggregate operations. By storing the result of these operations, the database avoids recalculating them on every query.

**Syntax:**

- To create a materialized view, use the following SQL syntax:

```sql
CREATE MATERIALIZED VIEW <view_name>
AS
SELECT statement;
```

### Characteristics

- If it is a **view**, Oracle only stores the query.
- If it is a **materialized view**, Oracle stores the query's output.

### Data Changes

- Changes in the base table do not automatically reflect in the materialized view. The materialized view's data remains static until it is refreshed.

### Refreshing Materialized Views

A materialized view can be refreshed in several ways:

1. **ON DEMAND**: The user manually triggers a refresh.
2. **ON COMMIT**: The view is refreshed automatically every time a transaction that modifies the data in its base table commits.
3. **Periodically**: Set up to refresh at certain defined intervals.

#### Refresh Command

- To refresh a materialized view manually, execute the following:

```sql
EXECUTE DBMS_MVIEW.REFRESH('mview_name');
```

# 261. What is Index ?

- An index in a database functions similarly to an index in a textbook. Just as a textbook index helps you quickly locate specific information, a database index speeds up the retrieval of data within a database.

**Key Points**

- **Index Key**: An index can be created on one or more columns of a database table, and these columns are referred to as index keys.

**Types of Indexes**

1. **BTREE Indexes**: This is the most common type of index used in databases. It uses a tree-like structure that enables quick searches, inserts, deletes, and updates.

2. **BITMAP Indexes**: These are primarily used in environments where query operations far exceed update operations, such as data warehousing. Bitmap indexes are efficient for columns having a low cardinality of distinct values.

**Syntax of Creating a BTREE Index**

To create a BTREE index, use the following SQL syntax:

```sql
CREATE INDEX index_name ON table_name (column_name);
```

**Viewing the Execution Plan**

To see how a query will be executed, which can show whether an index will be used, you can set the following in SQL environments that support this feature:

```sql
SET AUTOTRACE ON EXPLAIN;
```

This setting displays the execution plan for SQL queries, highlighting how indexes are used to improve query performance.


# 262. What is Cluster ?

- A cluster is a database object that allows storage of data from two or more tables in a single disk space, optimizing data retrieval across these tables. This approach is used to enhance performance by reducing the I/O operations required during queries that join these tables.

**Steps to Create a Cluster**

1. **Create Cluster**: Establish the cluster with a specified name and data type for the key column.
2. **Create Index on Cluster**: Create an index on the cluster to facilitate quick access and efficient data retrieval.
3. **Create Tables within the Cluster**: Define tables that will be part of the cluster, specifying the column(s) that align with the cluster key.

**Syntax**

To create a cluster, use the following SQL command:

```sql
CREATE CLUSTER cluster_name (variable_name datatype);
```

To create an index on the cluster:

```sql
CREATE INDEX index_name ON cluster_name;
```

To create a table associated with the cluster:

```sql
CREATE TABLE table_name (columnname1 datatype, columnname2 datatype) CLUSTER cluster_name (variable);
```

**Data Organization in a Cluster**

If two tables are organized within a cluster using a single column, such as `deptno`, they will be stored at the same disk location. This organization significantly improves the performance of queries that join these tables on the clustered column.

**Verifying Data Storage Location**

To verify that the data from clustered tables is stored in the same memory location, you can examine the `ROWID`. The `ROWID` for rows from different tables but in the same cluster should be the same, indicating that they are stored together on disk.

This approach provides an efficient way to handle frequent join operations on large tables by minimizing disk I/O and thus speeding up query performance.


# 263. What are Locking and Concurrent Access

**Concurrent access**:

- refers to multiple users accessing the same data at the same time. This can lead to conflicts and inconsistencies without proper management mechanisms like locking.

**Types of Locking Modes:**

- **Exclusive Lock Mode**: This type of lock prevents the associated resource from being shared. It is typically obtained to modify data. The first transaction to lock a resource exclusively can alter the resource until the lock is released, blocking other transactions from making changes.

### Oracle Version Features

- Each version of Oracle has introduced different features enhancing functionality and performance:

**Oracle 8i Features**

- Materialized View
- Rollup and Cube
- Autonomous Transactions
- Analytical Functions
- Bulk Bind
- TRIM() Function

**Oracle 9i Features**

- Merge Statement
- Renaming a Column
- ANSI Joins
- Flashback Queries
- Multiple Inserts

**Oracle 10g Features**

- Introduced Recycle Bin
- Flashback Table
- INDICES OF Clause (PL/SQL)
- WM_CONCAT()
- Regular Expressions

**Oracle 11g Features**

- Continue Statement in PL/SQL Loops
- Read-Only Tables
- Virtual Columns
- PIVOT()
- Simple Integer Datatype in PL/SQL
- Compound Triggers
- Sequences used in PL/SQL without using the DUAL Table
- Follow Clause in Triggers
- ENABLE, DISABLE Clauses are used in Trigger Specification
- Named, Mixed Notations are used in a Subprogram Executed by Using SELECT Statement

# 264. What is PRAGMA AUTONOMOUS_TRANSACTION ?

- If we want separate transactions for procedures, create a procedure with `PRAGMA AUTONOMOUS_TRANSACTION`. A commit or rollback command in procedures affects only the transaction started in the procedure but not the main program.

**Example**

```sql
CREATE OR REPLACE PROCEDURE update_sal(e IN NUMBER)
IS
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  UPDATE emp SET sal = sal + 1000 WHERE empno = e;
  ROLLBACK;
END;
```

```sql
SET SERVEROUTPUT ON;
BEGIN
  UPDATE emp SET sal = sal + 1000 WHERE empno = 7369;
  update_sal(7499);
  COMMIT;
END;
```

There are a total of 5 PRAGMAs till Oracle 11g:

- AUTONOMOUS_TRANSACTION
- EXCEPTION_INIT
- SERIALLY_REUSABLE
- RESTRICT_REFERENCES
- INLINE 
- PRAGMA UDF (introduced in 12c)?

**PRAGMA EXCEPTION_INIT**

`PRAGMA EXCEPTION_INIT` links a user-defined exception to an Oracle error code.

**Example**

```sql
DECLARE
  vdno dept.deptno%TYPE;
  child_found EXCEPTION;
  PRAGMA EXCEPTION_INIT(child_found, -02292);
BEGIN
  DELETE FROM dept WHERE deptno = vdno;
EXCEPTION
  WHEN child_found THEN
    DBMS_OUTPUT.PUT_LINE('Child record found');
END;
```

# 265. What is raise application error ?

- using this procedure we can associate an error number with the custom error message

- combining both the error number and the custom error message you can compose an error string, which looks similar to those default error strings which are displayed by oracle engine when an error occurs.


# 266. What are collections ?

- collections is a group of elements of same type

**There are three types of collections**

1. pl/sql table or index by table

2. varray

3. nested table


# 267. if we want to use pl sql table first ?

1. declare type

2. declare variable 

**syntax:**

```sql
type name is table of data type index by datatype; 
```

# 268. Record type or pl sql record ?

- It is one of the user defined temparory data type which is used to store more than one table data or to assign more than one column datatypes

- they must atleast contain one element

- pinpoint of data is not possible


# 269. DECODE ?

- Decode compares expression to each search value one by one,if expression is equal to a search,then oracle database returns the corresponding result

- if no match is found then oracle returns default.if default is omitted then oracle returns null.

# 270. Difference Between ROWID and ROWNUM

| Feature | ROWID | ROWNUM |
|---------|-------|--------|
| **1** | Physical address of the row | ROWNUM is the sequential number, allocated to each returned row during query execution |
| **2** | ROWID is permanent | ROWNUM is temporary |
| **3** | ROWID is a 16-bit hexadecimal value | ROWNUM is numeric |
| **4** | ROWID gives the address of the rows or records | ROWNUM gives a count of records |
| **5** | ROWID is automatically generated unique ID of a row and is generated at the time of insertion of the row | ROWNUM is a dynamic value, automatically assigned |
| **6** | ROWID is the fastest means of accessing data | It represents the sequential order in which Oracle has retrieved the row |

**Key Points**

- **ROWID**: Represents the physical storage position of a row and is useful for quickly accessing rows as it points to the exact location of the data on the disk.
- **ROWNUM**: A pseudo-column that assigns a temporary sequence number to each row as Oracle retrieves it during a query, but it does not necessarily represent the order of the rows in the database.


# 271. What is a Trigger ?

- A Trigger is similar to a stored procedure in that it is automatically invoked in response to certain events, specifically DML operations performed on a table or view.

**Types of Triggers Supported by PL/SQL**

1. **Statement Level Trigger**
   - The trigger body is executed only once for the entire DML statement.

2. **Row Level Trigger**
   - The trigger body is executed for each row affected by the DML statement.

**Syntax**

Basic syntax for creating a trigger:

```sql
CREATE OR REPLACE TRIGGER trigger_name
BEFORE/AFTER INSERT/UPDATE/DELETE ON table_name
[FOR EACH ROW]
[WHEN (condition)]
[DECLARE]
  variable_declaration;
  cursors;
  user_defined_exceptions;
BEGIN
  -- Trigger logic here
[EXCEPTION]
  -- Exception handling here
END;
```

**Row Level Trigger Syntax**

In row level triggers, you can use qualifiers to access before and after values of the row being manipulated:

- `:OLD.column_name` to access the old value of the column
- `:NEW.column_name` to access the new value of the column

**Row Level Trigger Application**

**Auditing a Column**

- Auditing is a common application for triggers in all database systems. When a column's data is modified, the transaction details can be automatically stored in another table, which is known as auditing.

**Implementing Auditing in Oracle**

- In Oracle, you can implement auditing on a column by using the `UPDATE OF` clause in the trigger specification.

```sql
CREATE OR REPLACE TRIGGER audit_trigger
AFTER UPDATE OF column_name ON table_name
FOR EACH ROW
BEGIN
  INSERT INTO audit_table (column_names, old_value, new_value, change_date)
  VALUES (:OLD.column_name, :NEW.column_name, SYSDATE);
END;
```

This example illustrates how to create a trigger that logs changes to a specified column by inserting records into an audit table whenever the column is updated.


# 272. Oracle PL/SQL Packages

- A **package** is a database object that encapsulates global variables, constants, cursors, procedures, and functions into a single unit. 
- Packages improve the performance of applications because, when a package's subprogram is called for the first time, the entire package is loaded into memory.

**Components of a Package**
- **Packages consist of two parts:**
    1. Package Specification
    2. Package Body

**Package Specification**

The package specification is like a header section; it declares the types, variables, constants, exceptions, procedures, and functions that can be accessed from outside the package.

**Syntax:**

```sql
CREATE OR REPLACE PACKAGE package_name IS/AS
  -- Global variable declarations, constant declarations
  -- Cursor declarations, types declarations
  -- Procedure declarations, function declarations
END package_name;
```

**Package Body**

The package body contains the implementation of the procedures and functions defined in the package specification. It's where the actual code of the procedures and functions is written.

**Syntax:**

```sql
CREATE OR REPLACE PACKAGE BODY package_name IS/AS
  -- Procedures implementation
  -- Function implementation
END package_name;
```

# Executing Package Subprograms

- ## 1. Calling Package Procedures

#### Method 1:

**Syntax:**

```sql
EXEC package_name.procedure_name(actual_parameters);
```

#### Method 2:

**Syntax:**

```sql
BEGIN
  package_name.procedure_name(actual_parameters);
END;
```

- ### 2. Calling Package Functions

#### Method 1:
Using a SELECT statement:

```sql
SELECT package_name.function_name(actual_parameters) FROM dual;
```

#### Method 2:
Using an anonymous block:

```sql
BEGIN
  var_name := package_name.function_name(actual_parameters);
END;
```

**Notes**

- Generally, packages do not accept parameters at the package level.
- Packages cannot be nested.
- Packages cannot be invoked directly.




# 272. What are Overloading Procedures ?

- Overloading refers to the use of the same name for different purposes within the same programmatic scope in Oracle. This allows functions or procedures to be defined with the same name but different parameters or parameter types, enabling them to perform different tasks based on their input signatures. This is typically implemented through packages.

### Purpose of Overloading

- Overloading allows multiple procedures or functions to share the same name but handle different data types or numbers of arguments. This feature helps in simplifying the codebase by grouping related functionalities under a single name, enhancing both readability and maintainability.

### Syntax for Overloading Procedures

Here's an example of how to declare overloaded procedures within a package:

```sql
CREATE OR REPLACE PACKAGE pz1 IS
  -- First procedure: accepts two numbers
  PROCEDURE p1(a NUMBER, b NUMBER);

  -- Overloaded procedure: same name, different parameter types
  PROCEDURE p1(x NUMBER, y NUMBER);
END pz1;
```


# 273. State of the Global Variable

- In Oracle, if we want to maintain the state of the global variable or state of the cursor, then we must use `PRAGMA SERIALLY_REUSABLE` in the package.

**Syntax**

```sql
PRAGMA SERIALLY_REUSABLE;
```

# 273. Types Used in Packages 

- In Oracle, we create our own datatype by using the `TYPE` keyword. Creating user-defined types involves a two-step process:

   1. First, we create our own user-defined datatype using the appropriate syntax.
   2. Then, we create a variable from that user-defined type.

PL/SQL supports the following user-defined types:
1. PL/SQL record
2. Index by table or PL/SQL table or associative array
3. Nested table
4. Varray
5. Refcursor

# 274. Difference Between WHERE Clause and HAVING Clause

**Where:**
1. The WHERE clause is used to select specific rows.
2. Conditions are applied before the GROUP BY operation.
3. Use the WHERE clause if the condition does not contain group functions.

**Having:**
1. The HAVING clause is used to select specific groups.
2. Conditions are applied after the GROUP BY operation.
3. Use the HAVING clause if the condition contains group functions.

# 275. Constraints

**Novalidate**

- If a constraint is added with novalidate, Oracle doesn't validate existing data. It only validates new data.

**Delete Rules**

There are three rules:
- ON DELETE NO ACTION
- ON DELETE CASCADE
- ON DELETE SET NULL

These rules specify how child rows are affected if the parent row is deleted. These rules are declared with a foreign key.

- **ON DELETE NO ACTION**: The parent record cannot be deleted if it is associated with child records.
- **ON DELETE CASCADE**: If the parent row is deleted, then it is deleted along with child rows.
- **ON DELETE SET NULL**: If the parent row is deleted, then it is deleted without deleting child rows, but the foreign key is set to null value.


# 276. Locking

When data is accessed concurrently, users may encounter problems such as:

- Dirty read
- Phantom read
- Lost update
- Non-repeatable mode

To overcome these issues, every database system provides a mechanism called the **locking mechanism**.

**Types of Locks**
- **Shared Lock**: Allows multiple transactions to read (but not modify) the same resource.
- **Exclusive Lock**: Allows one transaction to both read and modify the resource, preventing other transactions from accessing it during the lock period.

**Deadlock**
- A deadlock is a situation where two transactions are mutually waiting for one another to release locks. When a deadlock occurs, Oracle throws an exception so that one transaction can be canceled to continue with another.

----------------------------------------------------------------------------------------

# 277. Sequences

- A sequence is a database object used to generate values, typically for primary key columns. Primary key values cannot be manually entered and must be generated by Oracle.

**Syntax**

```sql
CREATE SEQUENCE sequence_name
START WITH value
INCREMENT BY value
MAXVALUE value
MINVALUE value
[cycle | no cycle]
[CACHE size]
```

**Sequence Pseudo Values**

1. **CURRVAL**: Current value of the sequence.
2. **NEXTVAL**: Next value of the sequence.

**Options**

- **NOCYCLE**: Starts with the minimum value and generates up to the maximum value. When it reaches the max value, it stops.
- **CYCLE**: Starts with the minimum value and generates up to the maximum value. Once it reaches the max value, it resets to the minimum value.

**Cache**

- **CACHE 100**: Oracle server reallocates the next 100 values in cache memory, improving performance.
- Default cache size is 20.
- Cache size must be less than one cycle.

**User Sequences**

- **USER_SEQUENCES**: Stores information about sequences created by the user.

----------------------------------------------------------------------------------------

# 288. View

- A view is a virtual table or a subset of a table, representing a SQL query.

**Reasons for Creating Views**

1. **For Security**: By creating views, specific columns and rows can be granted to users.
2. **To Reduce Complexity**: Helps in managing and presenting simplified data.

**Characteristics**
- A view is called virtual because it does not store data or occupy memory. It always derives data from its base table(s).

----------------------------------------------------------------------------------------

# 289. Synonym

A synonym is another name or an alternative name for a table or view.

**Reasons for Creating Synonyms**

1. If the table name is lengthy.
2. To access the table without including the owner's name.

**Syntax**

```sql
CREATE SYNONYM synonym_name FOR table_name;
```

----------------------------------------------------------------------------------------

# 290. ALIAS vs SYNONYM

**Alias**

1. The scope of an alias is limited to the query only; it cannot be accessed outside the query.
2. Aliases are not stored in the database.

**Synonym**

1. A synonym can be accessed in any query.
2. Synonyms are stored in the database.

-------------------------------------------------------------------------

# 291. Indexes

- An index is a database object that makes data retrieval faster. Using indexes, Oracle can locate records in a table quickly. Indexes are created on columns, and those columns are called index keys.

**Types of Indexes:**
- **BTREE Indexes**: 
  - Simple
  - Composite
  - Unique
  - Function-based

**Syntax**

```sql
CREATE INDEX index_name ON table_name (column_name);
```

**Time Taken by Oracle to Run Query**

```sql
SET TIMING ON
```

**To See Execution Plan:**

```sql
SET AUTOTRACE ON EXPLAIN
```

**Composite Index**

- If the index is based on two or more columns, then create a composite index:

```sql
CREATE INDEX index_name ON table_name (column1, column2);
```

**Unique Index**

- A unique index does not allow duplicate values into the column on which the index is created. Primary key columns and unique columns are automatically indexed by Oracle:

```sql
CREATE UNIQUE INDEX index_name ON table_name (column_name);
```
-------------------------------------------------------------------------

# 292. Difference Between BTREE and BITMAP Indexes

**BTREE:**

1. Created on high cardinality columns.
2. Stores index keys.
3. Stores rowids.

**BITMAP:**

1. Created on low cardinality columns.
2. Stores bits.
3. Does not store rowids.

---------------------------------------------------------

# 293. Materialized Views

- Materialized Views (MVs) are database objects that store the result of a query or a precomputed result. 
- They are particularly useful in very large databases, such as Data Warehouses (DWH), because they improve the performance of queries that perform joins and group by operations.

**Syntax for Creating a Materialized View**

```sql
CREATE MATERIALIZED VIEW view_name AS
SELECT statement;
```

**Example**

```sql
CREATE MATERIALIZED VIEW mv1 AS
SELECT deptno, SUM(sal) AS sumsal
FROM emp
GROUP BY deptno;
```

**Refreshing Materialized Views**

By default, a materialized view is not updated when the base table changes.

**Methods to Update Materialized Views**

1. **Manually**
2. **Automatically**

**Manually Refreshing**
```sql
EXECUTE DBMS_MVIEW.REFRESH('materialized_view_name');
```

**Automatically Refreshing**

- **Refresh on Commit**: Refreshes the materialized view every time a transaction that modifies the data in its base tables commits.
- **Refresh Based on Time Interval**: Refreshes the materialized view at specified time intervals.

**Example of Automatic Refresh on Commit**

```sql
CREATE MATERIALIZED VIEW mv2
REFRESH ON COMMIT AS
SELECT deptno, SUM(sal) AS sumsal
FROM emp
GROUP BY deptno;
```
--------------------------------------


# 294. Have you heard about raise_application _error. what is it and when do we use it?

- Raise_application_error is a predefined exception procedure available in dbms_standard package
- In oracle if we want to display user defined exception messages in more descriptive form then only we are using this procedure.If we want to display user_defined exception messages as same as oracle error displayed format then we must use raise_application_error procedure.this procedure is used either in execute section or the exception section of pl sql block

---





















