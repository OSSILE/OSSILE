##Synopsis
A program which walks through the directory passed and creates a log of the objects found plus their size.

##Purpose
Shows how to use the API's available to retrieve the contents and subdirectories of a passed in directory and log each entry to a log file in the IFS.
It will also sum the total number of objects and total size of the objects found.


## Parameters
* Provided by command

Example:
```
RTVDIRSZ PATH('/home')
```

##Tests
Use Command provided to prompt for directory and verify the results. The log will be in the directory '/home/rtvdirsz/log', in that directory will be a file
which is named using the data and time the command was run.

##Documentation
See [IBM Knowledge Center](http://http://www.ibm.com/support/knowledgecenter/ssw_ibm_i) for details of the API's used.

##Contributors
Provided by Chris Hird. You can contact me via Ryver or Linked in should it be necessary.
[Website](http://www.shieldadvanced.com)
   
##Copyright
Copyright (c) Chris Hird 2016 Made available under the terms of the license of the containing project              