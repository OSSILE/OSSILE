# SQL UDTF list source members #

A SQL user defined table function to list all or somes source members in a source file.

### What is this UDTF do ? ###

* This SQL function will return a list of source members in a source file

* You can use *LIBL for the library and an OVRDBF commande before.

* The following attributes will be returned:
    + Member name
    + Source type
    + creation date
    + last change date
    + Source member text    

### How do I get set up? ###

For build and setup instructions, refer to the [README.md](../../README.md) for the OSSILE project.

### Usage examples ###

* Call the SQL function like the following (you can use OVRDBF before)

        select * from table(OSSILE.list_source_members('QGPL', 'QCLSRC' , 'CL*') ) as s

    or without a member name (*ALL) :

        select * from table(OSSILE.list-source_membres('QGPL' , QCLSRC') ) as s

    or with only a file name (*LIBL) :

        select * from table(OSSILE.lis_source_members('QCLSRC') ) as s

