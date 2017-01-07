##Synopsis
A program which shows how to display the recevivers attached to a journal and determine if the detach date is greater than the number of days passed.

##Purpose
Demonstrates how to display a receiver chain and identify those receivers which are older than a number of days. It can be used to clean up a receiver
chain attached to any journal (*LOCAL/*REMOTE) to allow DASD utilization to be managed.  

## Parameters
* Journal 20 character 'JrnName   Library   '
* Days to keep int

##Tests
Call from command line using the format CALL OSSILE/CHKRCVRDLT 'JrnName   Library' 2. this will print out those receivers which are detached and greater
than 2 days old.

##Documentation
See [IBM Knowledge Center](http://www.ibm.com/support/knowledgecenter/ssw_ibm_i) for details of the API's used.

##Contributors
Provided by Chris Hird. You can contact me via Ryver or Linked in should it be necessary.
[Website](http://www.shieldadvanced.com)
   
##Copyright
Copyright (c) Chris Hird 2016 Made available under the terms of the license of the containing project              