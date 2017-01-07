##Synopsis
A sample solution which reads the content of a file and generates a CRC for the entire content at either the file level or the memeber level. The user
can determine which type of CRC is generated using an option in the command. Help is provided via a *PNLGRP for the command.

##Purpose
Allows the user to generate a CRC for a file and compare that CRC with a copy of the object to ensure they are the same. The programs demonstrate how to
create a ILE program and command using a Binding Directory to bind the module at compile time to the program object.

## Parameters (via the command)
* File Name 30 character 'FileName  Library   Member    '
* CRC Level 5 character (Restricted) '*FILE' || '*MBR '
* CRC to use short int (restricted) 1 through 5.
* Buffer size int (restricted) 32k - 16mb 

##Tests
Add the OSSILE library to the library list and run the command entering the information required. eg: 
* CRTMD5 FILE(CORPDATA/EMPLOYEE) CRYPT(*SHA256) BUFSIZ(16MB)
* output in MD5DETS 'EMPLOYEE  CORPDATA  EMPLOYEE  772dea81fc50683b758158a7e546756941e66735' 

##Documentation
See [IBM Knowledge Center](http://http://www.ibm.com/support/knowledgecenter/ssw_ibm_i) for details of the API's used.

##Contributors
Provided by Chris Hird. You can contact me via Ryver or Linked in should it be necessary.
[Website](http://www.shieldadvanced.com)
   
##Copyright
Copyright (c) Chris Hird 2016 Made available under the terms of the license of the containing project              