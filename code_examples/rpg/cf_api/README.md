##Synopsis
A number of sample programs supplied by Carsten Flensburg which demonstrate how to use various API's. These are all code
samples originally posted to iProdeveloper as part of the Using API's articles. Some of the samples are a collection of commands
and programs which require a special build file for them to be created, the setup script will call the cbx---m.clp if found in the 
directory.

##Purpose
Provide a number of code examples which can be used as utilities on IBM i. The code demonstrates the use of a number of API's.

## Utilities
* 100 - Sample of QDBRTVFD
* ... - More utilities/samples
* 976 - RTVJOBITPS,CHGJOBITPS Retrieve/Change Job Interrupt Status
* 977 - WRKJOBS Work with Jobs
* 978 - RTVCMDINF Retrieve Command Information
* 979 - Query Govenor Exit program. Note: Requires CBX980 Service Program.
* 980 - CBX980 Service program used in xxxUSRQRYA command processing programs.
* 982 - Work with User Query Attributes. Note: requires Service Program CBX980 to be built.
* 983 - SETUSRQRYA Set User Query Attributes. Note: menu CMDUSRQRYA requires additional utilities to be built. 
* 984 - UIM Menu CMDSFWAGR. Note: Requires CHKSFWAGR,ACPSFWAGR and ALCLICSPC commands to be built.
* 985 - RMVPNDJOBL Remove Pending Job Log
* 986 - WRKSVRSSN Work with Server Session
* 987 - ENDSVRSSN End Server Session
* 988 - PRTPWDAUD Print Password Audit Report
* 989 - RTVQRYA Retrieve Query Attributes
* 990 - UPDUSRAUD Update User Auditing
* 991 - ADDUSRAUD,RMVUSRAUD Add/Remove User Auditing
* 993 - SETQRYPRFO Set Query Profile Options
* 994 - WRKQRYPRFO Work with Query Profile Opts
* 998 - WRKSBSE Work with Subsystem Entries
* 999 - WRKRMTOUTQ Work with Remote OUTQ's
* 9811 - ADDUSRQRYA Add User Query Attributes
* 9812 - CHGUSRQRYA Change User Query Attributes
* 9813 - RMVUSRQRYA Remove User Query Attributes
* 9841 - CHKSFWAGR Check Software Agreement
* 9842 - ACPSFWAGR Accept Software Agreement
* 9843 - ALCLICSPC Allocate License Space
* 9951 - WRKRTGE Work with Routing Entries
* 9952 - WRKJOBQE Work job Queue Entries
* 9953 - WRKJOBQJOB Work with Job Queue jobs
* 9961 - WRKPJE Work with Prestart Job Entries
* 9962 - WRKAJE Work with Autostart job Entries
* 9963 - SBMJOBDJOB Submit Job Description Job
* 9971 - WRKCMNE Work with Communication Entries
* 9972 - WRKWSE Work with Workstation Entries
* 9973 - Work with Workstation entries.
* 99A - Query Governor Exit Program Setup

##Build
run the shell script setup in QP2TERM ./code_examples/rpg/cf_api/setup '999'. Note: Some of the utilities require additional
utilities to be built to run correctly.

##Documentation
See [IBM Knowledge Center](http://www.ibm.com/support/knowledgecenter/ssw_ibm_i) for details of the API's used.

##Contributors
* Original code by Carsten Flensburg. [Website](https://spaces.hightail.com/space/00SJA)
* updates and formatting for OSSILE Chris Hird. [Website](http://www.shieldadvanced.com)
   
##Copyright
Copyright (c) OSSILE 2016 Made available under the terms of the license of the containing project   