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
  - CRTFRMSTMF originally sourced from https://bitbucket.org/BrianGarland/

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
    - DSPDQINF Prgram to display a data queue attributes
    - DSPTRGINF Program to display the triggers attached to a file.
    - DSPUSRIDX Program to display a User Index attributes plus the content (text only).
    - JOBLIST Program to display the currently active jobs and some of their attributes.
    - LSTDBRTST Program to display the database relationships for a file.
    - MD5CRC Program to generate a CRC for the content of a DB file.
    - RTVJRNOBJ Program to display the objects currently journalled to a journal.
    - RTVDIRSZ Program to log the content and sizes of a directory plus calculate the total size.
    - SRVPGMCHK Program to check the signatures of a service program and a program to ensure the program can call the Service program.
    - SYSINFO Program to retrieve and display system status.

    Documentation
       - [BACKUP](main/c_backup_pgm/README.md)
       - [CHKRCVRDLT](main/c_check_recvr_delete/README.md)
       - [CHKOSLVL](main/c_chk_os_lvl/README.md)
       - [DSPCSTINF](main/c_display_constraints/README.md)
       - [DSPDQINF](main/c_dspdqinf/README.md)
       - [DSPTRGINF](main/c_display_triggers/README.md)
       - [DSPUSRIDX](main/c_dspusridx/README.md)
       - [JOBLIST](main/c_joblist/README.md)
       - [LSTDBRTST](main/c_list_dbr/README.md)
       - [MD5CRC](main/c_md5crc/README.md)
       - [RTVJRNOBJ](main/c_list_jrn_obj/README.md)
       - [RTVDIRSZ](main/c_rtvdirsz/README.md)
       - [SRVPGMCHK](main/c_signature_verification/README.md)
       - [SYSINFO](main/c_sysinfo/README.md)

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

#### Method 3: Installing via Relic Package Manager
Each directory in `/main/` is a seperate item, each are installable seperatly with Relic. The base command is `RELICGET PLOC('https://github.com/OSSILE/OSSILE/archive/master.zip') PDIR('OSSILE-master/main/<ITEM>') PNAME(OSSILE)`, where `<ITEM>` is one of those directories. For example:

* `PDIR('OSSILE-master/main/crtfrmstmf')`
* `PDIR('OSSILE-master/main/udtf_image_catalog_details')`

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
