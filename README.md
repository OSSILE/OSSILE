# OSSILE

Welcome to the OSSILE project. This project is to serve three purposes:
  1. This project is to provide, via the open source community, a wide set of utilities for IBM i. They will get built into the OSSILE library.
  2. This project is to provide working examples of various things in ILE languages (RPG, C, C++)
  3. This project is to provide working examples of SQL (while not technically ILE, the examples are included here due to strong affinity and usefulness)

## Currently included in OSSILE
  - Useful UDTF's originally sourced from https://bitbucket.org/christianjorgensen/

    Documentation:
      - [CARTRIDGE_INFO](main/udtf_cartridge_info/README.md)
      - [HISTORY_LOG_INFO](main/udtf_history_log_info/README.md)
      - [IMAGE_CATALOG_DETAILS](main/udtf_image_catalog_details/README.md)
      - [MACHINE_ATTRIBUTES](main/udtf_machine_attrs/README.md)
  - CRTFRMSTMF originally sourced from https://github.com/BrianGarland/

    Documentation:
      - [CRTFRMSTMF](main/crtfrmstmf/README.md)

  - GETIPTF, originally sourced from http://bryandietz.us/getiptf.html

    Documentation:
      - [GETIPTF](main/getiptf/README.md)

  - C program samples originally sourced from [ChrisHird/OSSILE](https://github.com/ChrisHird/OSSILE)

    - BACKUP Program to run backups using BACKUP options and Image Catalogs and copy to remote file server.
    - CHKRCVRDLT Program to clean up receivers based on days since detatched.
    - CHKOSLVL Program to display the current OS level.
    - DSPCSTINF Program to display the constraints attached to a file.
    - DSPTRGINF Program to display the triggers attached to a file.
    - DSPDQINF Prgram to display a data queue attributes
    - DSPUSRIDX Program to display a User Index attributes plus the content (text only).
    - FTPCLNT an alternative FTP Client to the OS command line.
    - JOBLIST Program to display the currently active jobs and some of their attributes.
    - LSTDBRTST Program to display the database relationships for a file.
    - RTVJRNOBJ Program to display the objects currently journalled to a journal.
    - MD5CRC Program to generate a CRC for the content of a DB file.
    - RTVDIRSZ Program to log the content and sizes of a directory plus calculate the total size.
    - SRVPGMCHK Program to check the signatures of a service program and a program to ensure the program can call the Service program.
    - SYSINFO Program to retrieve and display system status.
    - ZLIB ZLIB Open Source for IBM i.

    Documentation
       - [BACKUP](main/c_backup_pgm/README.md)
       - [CHKRCVRDLT](main/c_check_recvr_delete/README.md)
       - [CHKOSLVL](main/c_chk_os_lvl/README.md)
       - [DSPCSTINF](main/c_display_constraints/README.md)
       - [DSPTRGINF](main/c_display_triggers/README.md)
       - [DSPDQINF](main/c_dspdqinf/README.md)
       - [DSPUSRIDX](main/c_dspusridx/README.md)
       - [FTPCLNT](main/c_ftpclnt/README.md)
       - [FTPCLNT Manual](main/c_ftpclnt/FTP_Client_OSS.pdf)
       - [JOBLIST](main/c_joblist/README.md)
       - [LSTDBRTST](main/c_list_dbr/README.md)
       - [RTVJRNOBJ](main/c_list_jrn_objs/README.md)
       - [MD5CRC](main/c_md5crc/README.md)
       - [RTVDIRSZ](main/c_rtvdirsz/README.md)
       - [SRVPGMCHK](main/c_signature_verification/README.md)
       - [SYSINFO](main/c_sysinfo/README.md)
       - [ZLIB](main/c_zlib/README.md)

  - sha256, originally sourced from https://github.com/miguel-r-s/SHA-256
    a re-implementation of SHA256 in C.
    Documentation:
      - [README](main/sha256/readme.md)

  - ArrayList, originally sourced from [RPG Next Gen](http://rpgnextgen.com).
    An ArrayList is a one-dimensional array. It is also a dynamic array which
    means that the size is not set at compile time but at runtime and it can
    grow if required.

    Documentation:
      - [README](main/arraylist/README.md)
      - [API documentation](http://iledocs.sourceforge.net/docs/index.php?program=/QSYS.LIB/SCHMIDTM.LIB/QRPGLESRC.FILE/ARRAYLIST.MBR) at [ILEDocs at Sourceforge.net](http://iledocs.sourceforge.net)

  - SU, originally sourced from [bitbucket.org/cmasseVolubis/volubis](https://bitbucket.org/cmasseVolubis/volubis).
    Like Under Linux, become QSECOFR as needed

    Documentation:
      - [README](main/su/readme.md)

  - Linked List, originally sourced from [RPG Next Gen](http://rpgnextgen.com).
    An array allocates memory for all its elements lumped together as one block 
    of memory. In contrast, a linked list allocates space for each element 
    separately in its own block of memory called a linked list element or node. 
    The list gets is overall structure by using pointers to connect all its 
    nodes together like the links in a chain.
    
    The linked list utilities service program shows how to get data via a list
    instead of using a userspace.
    
    Documentation:
      - [README](main/linkedlist/README.md)
      - [API documentation](http://iledocs.sourceforge.net/docs/index.php?program=/QSYS.LIB/FIST1.LIB/QRPGLESRC.FILE/LLIST.MBR)
      - [API documentation](http://iledocs.sourceforge.net/docs/index.php?program=/QSYS.LIB/FIST1.LIB/QRPGLESRC.FILE/LUTIL.MBR)

  - Update User-Defined Attribute
    Tags a QSYS object with a value. The value is stored in the user-defined
    attribute of the object.
    
    Documentation:
      - [README](main/updusrattr/README.md)

  - Message, originally sourced from [RPGUnit](http://rpgunit.sourceforge.net).
    This service program provides wrappers for the OS message API QMHRCVPM, QMHRSNEM
    and QMHSNDPM. It eases the handling of program and escape messages.
    
    Documentation:
      - [README](main/message/README.md)

# Installing OSSILE on your IBM i
#### Method 1: download the .zip file and compile
1. Download https://github.com/OSSILE/OSSILE/archive/master.zip and place it in IFS
2. From a PASE-capable shell (ssh client, QP2term, etc), run:
  * ``jar xvf OSSILE-master.zip``
  * ``cd OSSILE-master/main && chmod +x ./setup && ./setup``

    To exclude an item from building, remove it from buildlist.txt or comment it out with a preceding '#'

#### Method 2: Download *SAVF
1. Create a save file object on IBM i.
2. Download https://github.com/OSSILE/OSSILE/blob/master/ossile.savfsrc and upload it to the IBM i, replacing the contents of the save file you've created
2. Use the RSTLIB command to restore the OSSILE library from the save file. For example:
  * ``RSTLIB SAVLIB(OSSILE) DEV(*SAVF) SAVF(MYLIB/MYSAVF)``

#### Method 3: Deploy IBM Projects
1. Give execution permision to the init script `chmod +x ./setup_workspace.sh `
2. Execute `./setup_workspace.sh`
3. Open the workspace
4. Go to your project explorer and hit **Scan For Projects**
5. Deploy the project and do the compilation
> For more info about ibm projects check this [Modern IBM i pipeline repo](https://github.com/kraudy/IBM-i-pipeline)

# OSSILE directory structure
These are the main directories within OSSILE:
## ``main/``
 This directory houses complete, buildable code. In other words, it contains all the tools and utilities we list above as "included in OSSILE".
 Each subdirectory represents a separate buildable item.
## ``code_examples/``
 This is where one can find examples of how to accomplish various tasks in ILE languages. They do not need to be working, compilable examples, though that is preferred.
 Inside this directory, there are subdirectories for the various ILE languages. The code examples are located in the appropriate lanuage directory.
## ``sql_examples/``
 This directory houses examples of how to accomplish various tasks using SQL scripts.

# Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md)
