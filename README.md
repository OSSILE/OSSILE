# OSSILE

Welcome to the OSSILE project. This project is to serve two purposes:
  1. This project is to provide, via the open source community, a wide set of utilities for IBM i. They will get built into the OSSILE library. 
  2. This project is to provide working examples of various things in ILE languages (RPG, C, C++)

## Currently included in OSSILE
  - Useful UDTF's originally sourced from https://bitbucket.org/christianjorgensen/
    Documentation:
      - [CARTRIDGE_INFO](main/udtf_cartridge_info/README.md)
      - [IMAGE_CATALOG_DETAILS](main/udtf_image_catalog_details/README.md)
      - [MACHINE_ATTRIBUTES](main/udtf_machine_attrs/README.md)
  - CRTFRMSTMF originally sourced from https://bitbucket.org/BrianGarland/
    Documentation:
      - [CRTFRMSTMF](main/crtfrmstmf/README.md)
  
  - GETIPTF, originally sourced from http://bryandietz.us/getiptf.html

# Installing OSSILE on your IBM i
1. Download https://github.com/OSSILE/OSSILE/archive/master.zip and place it in IFS
2. Install 5733OPS PTF SI61064 (or latest supercede)
3. From a PASE-capable shell (ssh client, QP2term, etc), run:
  * ``/QOpenSys/QIBM/ProdData/OPS/tools/bin/unzip OSSILE-master.zip``
  * ``cd OSSILE-master/main && chmod +x ./setup && ./setup``
To exclude an item from building, remove it from buildlist.txt

#### Installing via Relic Package Manager
Each directory in `/main/` is a seperate item, each are installable seperatly with Relic. The base command is `RELICGET PLOC('https://github.com/OSSILE/OSSILE/archive/master.zip') PDIR('OSSILE-master/main/<ITEM>') PNAME(OSSILE)`, where `<ITEM>` is one of those directories. For example:

* `PDIR('OSSILE-master/main/crtfrmstmf')`
* `PDIR('OSSILE-master/main/udtf_image_catalog_details')`

# OSSILE directory structure
There are three main directories within OSSILE:
## ``main/``
 This directory houses complete, buildable code. 
 Each subdirectory represents a separate buildable item. 
## ``clle_examples/``
 This directory houses examples of how to accomplish various tasks in ILE CL. They do not need to be working, compilable examples (though that is preferred).
## ``rpg_examples/``
 This directory houses examples of how to accomplish various tasks in ILE RPG. They do not need to be working, compilable examples (though that is preferred).
 ## ``sql_examples/``
 This directory houses examples of how to accomplish various tasks using SQL scripts. 

# Adding a new item to OSSILE
1. Create a new branch for your contributions (preferred but optional)
2. Create a new subdirectory within the "main" directory with a logical name for your build item. By convention, use all lowercase
3. Drop the code into this new directory
4. In this new directory, create a file called "setup". 
5. Put all the build/compilation steps necessary in the "setup" file. It will be invoked as a script. Start with a '#!' line. **The script should build your ILE code into the OSSILE library on IBM i!**
  Please have your script obey the following rules:
    * Write useful information to standard out in cases of build failure (for instance, dependencies missing, etc)
    * Explicitly check that all operations finished successfully. If the build failed, exit with a nonzero return code
6. Update the buildlist.txt file (in the main/ directory) to include your new subdirectory name
7. Test and commit your changes, send us a pull request!
