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

This markdown documentation provides detailed explanations and SQL/PL/SQL code examples, ready for integration into your project or learning resources.
```





















