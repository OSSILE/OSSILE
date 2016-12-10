# SQL UDTF History Log Info #

A SQL user defined table function to return information from the history log.

This UDTF is defined like the same function provided by IBM in IBM i 7.3 TR1 and IBM i 7.2 TR5. However, this will work in IBM i 7.1 as well. If you are on 7.2 or 7.3, please use the IBM provided function in QSYS2 instead of this one.

### What does this UDTF do? ###

* This SQL function will return information about the messages in the system history log.

* The following parameters can be specified:

Parameter                          | Data type                     | Description
-----------------------------------|:------------------------------|:------------------------------------------
Starting time (optional)           | timestamp                     | Specifies the starting time for messages to be returned. Default is current date at midnight
Ending time (optional)             | timestamp                     | Specifies the ending time for messages to be returned. Default is current time

* The following attributes are returned:

Attribute                          | Data type                     | Description
-----------------------------------|:------------------------------|:------------------------------------------
Ordinal Position                   | integer                       | A unique number for each row
Message Id                         | varchar(    7 )               | The message ID for this message
Message Type                       | varchar(   13 )               | Type of message
Message Subtype                    | varchar(   22 )               | Subtype of message
Severity                           | smallint                      | The severity assigned to the message
Message Timestamp                  | timestamp                     | The timestamp when the message was sent
From User                          | varchar(   10 )               | The current user of the job when the message was sent
From Job                           | varchar(   28 )               | The qualified job name when the message was sent
From Program                       | varchar(   10 )               | The program that sent the message (always null!)
Message Library                    | varchar(   10 )               | The name of the library containing the message file
Message File                       | varchar(   10 )               | The message file containing the message
Message Tokens                     | varchar( 4096 ) for bit data  | The message token string
Message Text                       | vargraphic( 1024 ) ccsid 1200 | The first level text of the message including tokens, or the impromptu message text
Message Second Level Text          | vargraphic( 4096 ) ccsid 1200 | The second level text of the message including tokens

Please note that attribute From Program is always returned as null! This information is not provided in the API to open history log messages. A RFE has been created for this, but whether the RFE will be accepted is questionable.

### How do I get set up? ###

For build and setup instructions, refer to the [README.md](../../README.md) for the OSSILE project.

### Usage examples ###

* Call the SQL function like the following

        select * from table(OSSILE.history_log_info( timestamp('2016-11-01-07.00.00.000000'), timestamp('2016-11-01-07.30.00.000000') )) hli

    or with only starting timestamp (ending timestamp will be current timestamp):

        select * from table(OSSILE.history_log_info( timestamp('2016-11-01-07.00.00.000000') )) hli

    or with neither starting nor ending timestamp (starting timestamp will be current date from midnight and ending timestamp will be current timestamp):

        select * from table(OSSILE.history_log_info( )) hli


### API Documentation ###

[Open List of History Log Messages (QMHOLHST) API](http://www.ibm.com/support/knowledgecenter/ssw_ibm_i_71/apis/qmholhst.htm)

[DB2 for i - Services - QSYS2.HISTORY_LOG_INFO()](https://www.ibm.com/developerworks/community/wikis/home?lang=en#!/wiki/IBM%20i%20Technology%20Updates/page/QSYS2.HISTORY_LOG_INFO%20UDTF)
