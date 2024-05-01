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








































