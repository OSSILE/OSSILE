##Synopsis
A program which shows the signatures of a service program and then verifies that the signature for the service program relates to the signature 
in a program. This ensures that a call to a function from the program to the service program will work.

##Purpose
Verifies that the program will be able to call the service program functions without a signature violation.

## Parameters
* Service Program Name 20 character 'SrvPgm    Library   '
* Program Name 20 character 'PgmName   Library   ' 

##Tests
call from command line using the format CALL OSSILE/SRVPGMCHK 'SrvPgm    Library' 'PgmName   Library   '

##Documentation
See [IBM Knowledge Center](http://www.ibm.com/support/knowledgecenter/ssw_ibm_i) for details of the API's used.

##Contributors
Provided by Chris Hird. You can contact me via Ryver or Linked in should it be necessary.
[Website](http://www.shieldadvanced.com)
   
##Copyright
Copyright (c) Chris Hird 2016 Made available under the terms of the license of the containing project              