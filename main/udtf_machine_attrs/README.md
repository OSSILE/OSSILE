# SQL UDTF Machine Attributes #

A SQL user defined table function to get machine attributes like system type, system model number etc.

### What is this repository for? ###

* This SQL function will return attributes of the IBM Power machine that it is running on.

* The following attributes are returned:
    + System type
    + System model number
    + Processor group
    + System processor feature
    + System serial number
    + Processor feature
    + Interactive feature
    

### How do I get set up? ###

* Clone this git repository to a local directory in the IFS, e.g. in your home directory.
* Compile the source using the following CL commands (objects will be placed in the QGPL library):

```

CRTRPGMOD MODULE(QGPL/MACHATTR) SRCSTMF('machattr.rpgle')
CRTSRVPGM SRVPGM(QGPL/MACHATTR) EXPORT(*ALL) TEXT('Machine attributes UDTF')
RUNSQLSTM SRCSTMF('udtf_Machine_Attributes.sql') DFTRDBCOL(QGPL)

```
* Call the SQL function like the following
```
select * from table(qgpl.machine_attributes()) ma
```


### Documentation ###

[ MI API Materialize Machine Attributes (MATMATR)](http://www.ibm.com/support/knowledgecenter/en/ssw_ibm_i_71/rzatk/MATMATR.htm)