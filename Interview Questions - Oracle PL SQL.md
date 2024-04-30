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















