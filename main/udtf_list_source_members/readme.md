# SQL UDTF list source members #

A SQL user defined table function to list all or somes source members in a source file.

### What is this repository for? ###

* This SQL function will return a list af the source members in a source file.

* The following attributes are returned:
    + Member name
    + Source type
    + creation date
    + last change date
    + Source member text    

### How do I get set up? ###

* Clone this git repository to a local directory in the IFS, e.g. in your home directory.
* Compile the source using the following CL commands (objects will be placed in the OSSILE library):

```

CRTBNDRPG CRTBNDRPG PGM(OSSILE/LISTMEMBER) SRCSTMF('listmember.rpgle') TEXT('List source file members')
RUNSQLSTM SRCSTMF('udtf_source_members_Info.sql') DFTRDBCOL(OSSILE)

```
* Call the SQL function like the following
```
SELECT * FROM table(list_source_members('MYLIB' , 'QRPGLESRC', 'UDTF*'))
```
SELECT * FROM table(list_source_members('MYLIB' , 'QRPGLESRC'))
```
