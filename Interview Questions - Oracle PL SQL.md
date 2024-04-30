# SQL and PL/SQL Comprehensive Guide

## Key Concepts and Features

### `PARTITION BY`
- The `PARTITION BY` clause is a subclause of the `OVER` clause. It divides the result set of a query into partitions without reducing the number of rows returned.

### `%ROWTYPE`
- `%ROWTYPE` is used in PL/SQL to declare a variable that can store an entire row of a table or a view or columns selected in the cursor.

## Exception Handling in PL/SQL

### Types of Exceptions
1. **Predefined Exceptions**: Built into Oracle. Examples include:
   - `NO_DATA_FOUND`
   - `INVALID_NUMBER`
   - `NUMERIC_OR_VALUE_ERROR`
   - `ZERO_DIVIDE`
   - `DUP_VAL_ON_INDEX`
   - `INVALID_CURSOR`
   - `CURSOR_ALREADY_OPEN`
2. **User-defined Exceptions**: Defined by the programmer.

### `RAISE_APPLICATION_ERROR`
- A procedure in the `DBMS_STANDARD` package that allows you to issue a user-defined error from a PL/SQL block or subprogram. Useful for displaying descriptive error messages similar to Oracle's standard errors.

## Dynamic SQL in Oracle
- Introduced in Oracle 7.1, Dynamic SQL allows SQL statements to be executed dynamically within a PL/SQL block using `EXECUTE IMMEDIATE`. It enables the execution of DDL and DCL statements within PL/SQL.

## Sequences
- Used to generate unique numeric values. Often used for primary key values.
- **Syntax**:
  ```sql
  CREATE SEQUENCE sequence_name
  START WITH 1
  INCREMENT BY 1
  MAXVALUE 99999999
  NOCACHE;

## How to Delete Duplicate Records Using HAVING Clause

```sql
SELECT * FROM emp e 
WHERE rowid <> (SELECT MAX(rowid) FROM emp e1 WHERE e.empno = e1.empno)
```

## Difference Between CASE and DECODE

### CASE:
- Complies with ANSI SQL.
- Can work with logical operators other than `=`.
- Can work with predicate and searchable queries.
- Needs data consistency.
- `NULL = NULL` returns false.
- Can be used in PL/SQL blocks and SQL statements.
- Can be used in parameters while calling a procedure.

### DECODE:
- Oracle proprietary.
- Works only with the `=` like operator.
- Expressions are scalar values only.
- Data consistency is not needed.
- `NULL = NULL` returns true.
- Can be used in SQL statements.
- Cannot be used in parameters while calling procedures.

## Performance Tuning and Stats Gathering

To avoid statistics becoming zero after truncating a table, consider gathering statistics immediately after truncation or on a scheduled basis to ensure the optimizer has accurate data.

## Resource Busy: Handling ORA-00054 Error

To handle the ORA-00054 error when performing DDL operations like TRUNCATE, ALTER, DROP, or others, and the objects are in use by another user:
- Use `ALTER SYSTEM KILL SESSION` to terminate sessions that are blocking your operations.
- Consider scheduling DDL operations during maintenance windows when fewer users are connected.

## What are Triggers?

Triggers are PL/SQL blocks that automatically execute in response to specific events on a table or view in a database.
- **Purpose**:
  - Create data consistency.
  - Enforce business rules.
  - Extend security policies.
  - Provide auditing.

## Using the MERGE Statement

In situations where you need to insert or update rows conditionally based on the existence of records, the MERGE statement is utilized as follows:

```sql
MERGE INTO target_table USING source_table
ON (condition)
WHEN MATCHED THEN 
    UPDATE SET column1 = value1
WHEN NOT MATCHED THEN 
    INSERT (column1, column2) VALUES (value1, value2)
```

## Difference Between RANK and DENSE_RANK

### RANK:
- Gives a unique rank per row with gaps in ranking for ties.

```sql
SELECT ename, empno, sal, RANK() OVER (ORDER BY sal) AS ranking FROM emp
```

### DENSE_RANK:
- Similar to RANK, but without gaps in ranking for ties.

```sql
SELECT ename, empno, sal, DENSE_RANK() OVER (ORDER BY sal) AS ranking FROM emp
```

## What are Cursors?

Cursors are mechanisms in PL/SQL to process individual rows returned by database queries.
- **Syntax**:
  ```sql
  DECLARE cursor_name CURSOR FOR select_statement;
  OPEN cursor_name;
  FETCH cursor_name INTO variable_list;
  CLOSE cursor_name;
  ```

## What are Packages?

Packages are schema objects in Oracle databases that groups logically related PL/SQL types, items, and subprograms.
- **Purpose**: Enhance functionality, reusability, and performance of databases.

## Analytical Functions Overview

Examples of analytical functions include:
- `LAG()`
- `LEAD()`
- `KEEP_FIRST()`
- `KEEP_LAST()`
- `FIRST_VALUE()`
- `LAST_VALUE()`
- `RANK()`
- `DENSE_RANK()`

## Difference Between Procedure and Function

### Procedure:
- Does not necessarily return a value.
- Cannot be embedded in SQL queries.
- Called using the `CALL` statement or within a PL/SQL block.

### Function:
- Must return a value.
- Can be embedded in SQL queries.
- Used to compute values.

## Constraints and Their Types

### Types of Constraints:
1. **Entity Integrity Constraints**: `CHECK`, `NOT NULL`.
2. **Domain Integrity Constraints**: `PRIMARY KEY`, `UNIQUE`.
3. **Referential Integrity Constraints**: `FOREIGN KEY`.

## Differences Between Unique Key, Primary Key, and Foreign Key

- **Unique Key**: Ensures uniqueness among non-null values.
- **Primary Key**: Uniqueness and non-null.
- **Foreign Key**: Establishes a relationship between two tables, enforcing referential integrity.

## Differences Between RowID and Rownum

- **RowID**: Physical address of a row, permanent and unique.
- **Rownum**: Temporary sequence number assigned to rows as they are returned from a query.

## Differences Between Lead and Lag

- **Lead**: Accesses data from subsequent rows.
- **Lag**: Accesses data from previous rows.

## Deleting Duplicate Rows from a Table

```sql
DELETE FROM emp e
WHERE
 rowid <> (SELECT MAX(rowid) FROM emp e1 WHERE e.empno = e1.empno)
```


### 1. Constraints and Their Types
- **Constraints**: Rules for validating data in SQL tables.
  - **Entity Integrity Constraints**: Enforces data accuracy and integrity (e.g., `CHECK`, `NOT NULL`).
  - **Domain Integrity Constraints**: Ensures the data adheres to a defined domain (e.g., `PRIMARY KEY`, `UNIQUE`).
  - **Referential Integrity Constraints**: Maintains valid and consistent references between two tables (e.g., `FOREIGN KEY`).

### 2. Key Types
- **Unique Key**: Ensures all values in a column are different.
- **Primary Key**: A special kind of unique key, also ensures no null values.
- **Foreign Key**: Used to link two tables together.

### 3. Difference Between ROWID and ROWNUM
- **ROWID**: Represents the physical address of a row in the database, permanent and unique.
- **ROWNUM**: Represents the sequence number of a row returned by a query, temporary and sequential.

### 4. Lead and Lag Functions
- **LEAD**: Accesses data from the next row in the same result set.
- **LAG**: Accesses data from the previous row in the same result set.

### 5. Identifying and Deleting Duplicate Rows
- **Identify Duplicates**: 
  ```sql
  SELECT * FROM emp WHERE rowid != (SELECT MAX(rowid) FROM emp GROUP BY empno);
  ```
- **Delete Duplicates**: 
  ```sql
  DELETE FROM emp WHERE rowid != (SELECT MAX(rowid) FROM emp GROUP BY empno);
  ```

### 6. Merge Syntax
- Used for merging two tables or query results based on a condition.
  ```sql
  MERGE INTO target_table USING source_table ON (condition)
  WHEN MATCHED THEN
    UPDATE SET column1 = value1
  WHEN NOT MATCHED THEN
    INSERT (column1, column2) VALUES (value1, value2);
  ```

### 7. Retrieving Last Sunday of Previous Year
- SQL to find the last Sunday of the previous year.
  ```sql
  SELECT NEXT_DAY(LAST_DAY(ADD_MONTHS(SYSDATE, -12)), 'SUNDAY') FROM DUAL;
  ```

### 8. PRAGMA EXCEPTION_INIT
- Used to associate an exception with a specific Oracle error number.
  ```plsql
  PRAGMA EXCEPTION_INIT(exception_name, -error_number);
  ```

### 9. Understanding Different SQL Commands
- **DML (Data Manipulation Language)**: Commands that modify data. (e.g., `INSERT`, `UPDATE`, `DELETE`)
- **DDL (Data Definition Language)**: Commands that modify schema/structure. (e.g., `CREATE`, `ALTER`, `DROP`)
- **DCL (Data Control Language)**: Commands that control access. (e.g., `GRANT`, `REVOKE`)

### 10. Differences Between SQL Joins
- **INNER JOIN**: Returns rows when there is a match in both tables.
- **LEFT OUTER JOIN**: Returns all rows from the left table, and the matched rows from the right table.
- **RIGHT OUTER JOIN**: Returns all rows from the right table, and the matched rows from the left table.
- **FULL OUTER JOIN**: Returns rows when there is a match in one of the tables.

### 11. Triggers and Their Types
- **Triggers**: Special procedures that are executed in response to changes in the database.
  - **Statement Level Triggers**: Execute once for each transaction.
  - **Row Level Triggers**: Execute once for each row affected.

### 12. Cursors in PL/SQL
- **Cursors**: Tools for iterating over PL/SQL query results.
  - **Implicit Cursors**: Automatically created by SQL statements.
  - **Explicit Cursors**: Defined by the programmer for more control.

### 13. PL/SQL Optimization Techniques
- **Bulk Collect**: For fetching SQL query results into PL/SQL collections.
- **Using Indexes**: To speed up data retrieval.
- **Optimizing Loops**: Using FORALL for bulk DML operations.

### 14. Error Handling and Exception in PL/SQL
- **User-Defined Exceptions**: Allow custom error handling by the programmer.
- **Exception Handling Syntax**: 
  ```plsql
  EXCEPTION
  WHEN exception_name THEN
    -- error handling code
  ```

### 15. Database Views and Materialized Views
- **Views**: Virtual tables created by a query.
- **Materialized Views**: Physical copies of data from a query for performance.

### 16. Using SQL Loader for Data Import
- **SQL Loader**: Utility to load data from external files into Oracle tables.
- **Control File Syntax**: Defines how data is loaded.
  ```ini
  LOAD DATA
  INFILE

 'examples.dat'
  INTO TABLE emp
  FIELDS TERMINATED BY ','
  (empno, ename, job);
  ```
```

### 17. SQL Loader Advanced Usage

- **Skipping Records**: To skip the first 10 records in a data load, use the `SKIP` option.
  ```sql
  SKIP 10
  ```
- **Conditional Loading**: To skip specific columns, specify positions in the control file.
  ```ini
  FIELDS (col1 FILLER, col2 FILLER, col3)
  ```

### 18. Managing Database Constraints and Indexes

- **Adding Constraints on Tables with Duplicates**: 
  - First, remove duplicates or decide how to handle them, then add the primary key or unique constraint.
- **Types of Indexes**: 
  - **B-tree Indexes**: Default and most common, good for high-cardinality data.
  - **Bitmap Indexes**: Efficient for low-cardinality data where column values are repeated extensively.

### 19. Dynamic SQL in PL/SQL

- **Purpose**: Allows the execution of SQL statements dynamically that are not known at compile time.
- **Usage Example**: Using `EXECUTE IMMEDIATE` for building and executing SQL queries dynamically.
  ```plsql
  EXECUTE IMMEDIATE 'CREATE TABLE temp_table (id NUMBER)';
  ```

### 20. Cursor Variables and REF CURSOR

- **REF CURSOR**: A PL/SQL datatype that holds a cursor value in a variable, allowing the cursor to be passed as a parameter to other procedures or stored in a variable.
  ```plsql
  DECLARE
    type ref_cursor is ref cursor;
    cur_var ref_cursor;
  BEGIN
    OPEN cur_var FOR SELECT * FROM employees;
  END;
  ```

### 21. PL/SQL Packages and Overloading

- **Packages**: Collections of related procedures, functions, and other program units that are stored together in the database.
- **Overloading**: Defining multiple procedures or functions with the same name but different parameters.
  ```plsql
  CREATE OR REPLACE PACKAGE emp_actions IS
    PROCEDURE add_emp(emp_id NUMBER, emp_name VARCHAR2);
    PROCEDURE add_emp(emp_id NUMBER, emp_salary NUMBER);
  END;
  ```

### 22. Exception Handling in Advanced Scenarios

- **Pragma EXCEPTION_INIT**: Associates an exception with an Oracle error number, making it identifiable in a PL/SQL block.
  ```plsql
  PRAGMA EXCEPTION_INIT(custom_exception, -20001);
  ```

### 23. SQL Joins and Set Operators

- **Using Set Operators**: `UNION` vs `UNION ALL`, `INTERSECT`, `MINUS`
  - `UNION`: Combines the results of two queries and removes duplicates.
  - `UNION ALL`: Combines the results of two queries, including duplicates.
  - `INTERSECT`: Returns only the rows that exist in both queries.
  - `MINUS`: Returns only the rows from the first query that are not in the second query.

### 24. Performance Tuning Tools and Techniques

- **EXPLAIN PLAN**: Used to understand the access path and efficiency of SQL queries.
- **TKPROF**: A tool to convert SQL trace files into a more readable format, helping to identify performance bottlenecks.
- **SQL Tuning Advisor**: Provides expert advice on how to tune specific SQL queries.

### 25. Data Integrity and Security Measures

- **Implementing Row-Level Security**: For scenarios like a hospital management system, where data access needs to be restricted based on user roles.
- **Using Views and Synonyms for Security and Convenience**: Creating views for sensitive data exposure with limited access and synonyms for easier table access.

### 26. Understanding and Managing PL/SQL Collections

- **Types of Collections**: `Associative Arrays`, `Nested Tables`, and `VARRAYs`.
- **Usage Scenarios**: Storing and manipulating sets of data within PL/SQL memory for faster processing and reduced database interaction.

### 27. Bulk Operations with FORALL and BULK COLLECT

- **BULK COLLECT**: Allows fetching of multiple rows into a PL/SQL collection.
- **FORALL**: Used to perform DML operations on collections, significantly reducing context switches between SQL and PL/SQL.







### 28. Advanced Database Features

- **Materialized Views**: 
  - Used for performance optimization in scenarios involving complex queries over large datasets.
  - Can be refreshed on demand or at regular intervals, making them suitable for read-heavy applications.
  ```sql
  CREATE MATERIALIZED VIEW log_data AS
  SELECT * FROM logs WHERE entry_date >= SYSDATE - 30;
  ```

- **Database Links**:
  - Facilitate queries across different databases. A database link can connect Oracle databases, or Oracle to other databases.
  ```sql
  CREATE DATABASE LINK remote_connect
  CONNECT TO remote_user IDENTIFIED BY password
  USING 'remote_db';
  ```

### 29. PL/SQL Error Handling

- **Custom Error Handling with RAISE_APPLICATION_ERROR**:
  - Used to generate and handle custom error messages, making the error output more readable and specific to the application context.
  ```plsql
  RAISE_APPLICATION_ERROR(-20001, 'Invalid operation on holiday dates');
  ```

### 30. SQL Data Retrieval Techniques

- **Analytical Functions for Advanced Data Analysis**:
  - Functions such as `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()` are crucial for complex analytical queries.
  ```sql
  SELECT employee_id, salary, RANK() OVER (ORDER BY salary DESC) salary_rank
  FROM employees;
  ```

### 31. SQL and PL/SQL Optimization

- **Using SQL Plan Management for Consistent Performance**:
  - SQL plan management helps prevent performance regressions due to execution plan changes in SQL statements, a common issue during database upgrades.

### 32. Managing Database Security and Data Integrity

- **Using Oracle Virtual Private Database (VPD)**:
  - Adds a security layer to control database access at the row and column level, effectively implementing fine-grained access control.

### 33. Advanced Join Techniques

- **Leveraging Full Outer Joins**:
  - Useful when you need to include all records from two datasets, regardless of whether a match exists.
  ```sql
  SELECT a.*, b.*
  FROM table_a a
  FULL OUTER JOIN table_b b ON a.id = b.id;
  ```

### 34. Techniques for Data Import and Export

- **Data Pump for High-Speed Data Movement**:
  - Oracle Data Pump enables high-speed transfer of data and metadata from one database to another, improving on traditional export and import operations.

### 35. Use of Cursors in PL/SQL

- **Implicit vs. Explicit Cursors**:
  - Implicit cursors are automatically created by Oracle for DML and query (SELECT) statements.
  - Explicit cursors are defined by the programmer for more granular control over the fetching of rows.
  ```plsql
  DECLARE
    CURSOR emp_cursor IS SELECT * FROM employees WHERE department_id = 10;
    emp_record emp_cursor%ROWTYPE;
  BEGIN
    OPEN emp_cursor;
    FETCH emp_cursor INTO emp_record;
    CLOSE emp_cursor;
  END;
  ```

### 36. Implementing Business Logic with Triggers

- **Types of Triggers**:
  - Before and after triggers for DML operations such as INSERT, UPDATE, and DELETE.
  - Instead of triggers for performing operations in place of the actual DML operation on views.

### 37. Managing Large Datasets

- **Partitioning Large Tables**:
  - Table partitioning helps manage large tables by dividing them into smaller, more manageable pieces, while improving query performance and simplifying maintenance.
  ```sql
  CREATE TABLE sales_data (
    sale_id NUMBER,
    product_id NUMBER,
    sale_date DATE,
    amount NUMBER
  )
  PARTITION BY RANGE (sale_date) (
    PARTITION p1 VALUES LESS THAN (TO_DATE('2021-01-01', 'YYYY-MM-DD')),
    PARTITION p2 VALUES LESS THAN (TO_DATE('2022-01-01', 'YYYY-MM-DD'))
  );
  ```

### 38. Advanced PL/SQL Features

- **Dynamic SQL for Complex Application Logic**:
  - Essential for scenarios where static SQL does not offer the flexibility needed, such as dynamically constructing SQL queries based on user input or application context.

### 39. Database Performance Tuning

- **Index-Organized Tables for Performance**:
  - Use index-organized tables when the physical order of rows is important, such as when a table is frequently accessed by primary key.



















