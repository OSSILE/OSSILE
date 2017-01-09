##Synopsis
The purpose of this program is to use the IBM supplied backup process to save objects to an image catalog entry and then copy that image catalog entry to a
remote file server. It can be used via the jobscheduler (shipped with every IBM i system) to create a back up process that will run automatically every
night and carry out the required save process (use *SCHED). 

## Virtual Device and image Catalogue
You will first need to set up the Image Catalogue and Virtual device. We suggest that you create a virtual Tape device and add image catalogue entries of 
sufficient size to contain the backups you will capture. The IMGSIZE parameter will set the maximum size of the IMGCLGE, set the initial size to *MIN to allow
the save to only take up as much DASD as you need. It is important atht the Volume Names match those set up in the BACKUP options.

###Sample Commands to create above

* `CRTDEVTAP DEVD(VRTTAP01) RSRCNAME(*VRT) ASSIGN(*YES)` 
* `CRTIMGCLG IMGCLG(MYBACKUP) DIR('/mybackup') TYPE(*TAP)` 
* `ADDIMGCLGE IMGCLG(MYBACKUP) FROMFILE(*new) TOFILE(daya01) IMGSIZ(10000) TEXT('Daily save') VOLNAM(DAYA01)`  
* `ADDIMGCLGE IMGCLG(MYBACKUP) FROMFILE(*new) TOFILE(weka01) IMGSIZ(10000) TEXT('Daily save') VOLNAM(WEKA01)`   
* `ADDIMGCLGE IMGCLG(MYBACKUP) FROMFILE(*new) TOFILE(mtha01) IMGSIZ(10000) TEXT('Daily save') VOLNAM(MTHA01)` 

## Setup the backup
Before you run the program you will need to set up your BACKUP settings via menu **BACKUP** (GO BACKUP) option 10. This program will use the settings 
you have entered to carry out the backup to a virtual tape Image Catalog. Ensure you set the _Tape sets to rotate_ parameter matches the above Volume Name
ie **DAYA** matches up with **DAYA01** for the daily backup.

##Purpose
The daily save is developed so that it carries out a daily save and stores each nights save into a seperate directory on the file server. 
The same IMGCLGE is used for each save. The reason for removing the image catalog each time is to keep the size of the images to a minimum, 
you could add additional checks to initialize the image catalog but doing so would not reduce the size of the image each time.
It is provided as a basis for developing your own specific back up process and may not work as it is defined here. Setting up our NAS was carried out 
using NFS but can be any file system mount that you desire.

## Parameters
Backup type `*SCHED,*DAILY,*WEEKLY,*MONTHLY` 
*SCHED uses the current date to determine type, it is what should be used when using via the job scheduler. The other parameters allow you to call
the program from a command line and automatically start a backup of the desired type.

##Tests
Run a test of the settings using the command line and entering `CALL OSSILE/BACKUP '*DAILY'` this will cause the back up to use the daily settings entered
in the Daily backup options.

##Documentation
See [IBM Knowledge Center](http://www.ibm.com/support/knowledgecenter/ssw_ibm_i) for details of the API's used.

##Contributors
Provided by Chris Hird. You can contact me via Ryver or Linked in should it be necessary.
[Website](http://www.shieldadvanced.com)
   
##Copyright
Copyright (c) Chris Hird 2016 Made available under the terms of the license of the containing project              