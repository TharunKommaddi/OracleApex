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

- Ex:select ename,empno,sal,rank()over(order by sal ) as ranking from emp

**Dense_rank:**
- Dense rank is also gives the order of rank specified by order by clause

- Ex:select ename,empno,sal,dense_rank()over(order by sal) as ranking from emp.
































