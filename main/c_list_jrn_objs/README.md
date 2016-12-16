##Synopsis
A program which shows how to display the objects journalled to a journal.

##Purpose
Allows the user to display all of the objects journalled to a journal. It can be filtered by type such as *LIB, *DTAQ, *DTAARA, *FILE, *STMF.
Special value of *ALL will display all object types. The *STMF request will use the API to extract the actual path of the object to display using its JID.

## Parameters
* Journal 20 character 'JrnName   Library   '
* Object type to display character 10 

##Tests
call from command line using the format CALL OSSILE/RTVJRNOBJ 'JrnName   Library' '*ALL      '

##Documentation
See [IBM Knowledge Center](http://http://www.ibm.com/support/knowledgecenter/ssw_ibm_i) for details of the API's used.

##Contributors
Provided by Chris Hird. You can contact me via Ryver or Linked in should it be necessary.
[Website](http://www.shieldadvanced.com)
   
##Copyright
Copyright (c) Chris Hird 2016 Made available under the terms of the license of the containing project              