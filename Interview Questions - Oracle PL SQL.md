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
