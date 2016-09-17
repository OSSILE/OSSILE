# SQL UDTF Cartridge Info #

A SQL user defined table function to get the details for cartridges in a tape library.

### What is this repository for? ###

* This SQL function will return details of the cartridges in a tape library.

* Parameters:
    + Tape library
    + Cartridge ID (optional)
    + Category name (optional)
    + Category system (optional)

* The following attributes are returned:
    + Cartridge ID
    + Volume ID
    + Tape library name
    + Category
    + Category system
    + Density
    + Changed (timestamp)
    + Referenced (timestamp)
    + Location
    + Location indicator (slot/drive)
    + Volume status
    + Owner ID
    + Write protected (yes/no)
    + Encoding
    + Cartridge ID source
    + In import/export slot (yes/no)
    + Media type


### How do I get set up? ###

* Clone this git repository to a local directory in the IFS, e.g. in your home directory.
* Compile the source using the following CL commands (objects will be placed in the QGPL library):

        CRTRPGMOD MODULE(QGPL/CARTINFO) SRCSTMF('cartinfo.rpgle')
        CRTSRVPGM SRVPGM(QGPL/CARTINFO) EXPORT(*ALL) TEXT('Cartridge Info UDTF')
        RUNSQLSTM SRCSTMF('udtf_Cartridge_Info.sql') DFTRDBCOL(QGPL)

* Call the SQL function like the following

        select * from table(qgpl.cartridge_info( 'TAPMLB01' )) x

    or with selection on cartridge ID: 

        select * from table(qgpl.cartridge_info( 'TAPMLB01', 'ABC*' )) x

    or with selection on cartridge ID and category: 

        select * from table(qgpl.cartridge_info( 'TAPMLB01', 'ABC*', '*INSERT' )) x

    or with selection on cartridge ID and category and category system: 

        select * from table(qgpl.cartridge_info( 'TAPMLB01', 'ABC*', '*NOSHARE', 'SYSNAME' )) x
```

### Documentation ###

[Retrieve Cartridge Information (QTARCTGI) API](http://www.ibm.com/support/knowledgecenter/ssw_ibm_i_71/apis/qtarctgi.htm)