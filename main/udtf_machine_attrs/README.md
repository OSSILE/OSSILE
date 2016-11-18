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

For build and setup instructions, refer to the [README.md](../../README.md) for the OSSILE project

### Usage Example ###
* Call the SQL function like the following
```
select * from table(qgpl.machine_attributes()) ma
```


### API Documentation ###

[ MI API Materialize Machine Attributes (MATMATR)](http://www.ibm.com/support/knowledgecenter/en/ssw_ibm_i_71/rzatk/MATMATR.htm)
