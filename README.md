# OSSILE

Welcome to the OSSILE project. This project is to serve two purposes:
  1. This project is to provide, via the open source community, a wide set of utilities for IBM i. They will get built into the OSSILE library. 
  2. This project is to provide working examples of various things in ILE languages (RPG, C, C++)

## Currently included in OSSILE
  - Useful UDTF's originally sourced from https://bitbucket.org/christianjorgensen/

# Installing OSSILE on your IBM i
1. Download https://github.com/OSSILE/OSSILE/archive/master.zip and place it in IFS
2. Install 5733OPS PTF SI61064 (or latest supercede)
3. From a PASE-capable shell (ssh client, QP2term, etc), run:
  * ``/QOpenSys/QIBM/ProdData/OPS/tools/bin/unzip OSSILE-master.zip``
  * ``cd OSSILE-master/main && ./setup``
To exclude an item from building, remove it from buildlist.txt


# OSSILE directory structure
There are three main directories within OSSILE:
## ``main/``
 This directory houses complete, buildable code. 
 Each subdirectory represents a separate buildable item. 
## ``clle_examples/``
 This directory houses examples of how to accomplish various tasks in ILE CL. They do not need to be working, compilable examples (though that is preferred).
## ``rpg_examples/``
 This directory houses examples of how to accomplish various tasks in ILE RPG. They do not need to be working, compilable examples (though that is preferred).

# Adding a new item to OSSILE
1. Create a new subdirectory within the "main" directory with a logical name for your build item. By convention, use all lowercase
2. Drop the code into this new directory
3. In this new directory, create a file called "setup". 
4. Put all the build/compilation steps necessary in the "setup" file. It will be invoked as a script. Start with a '#!' line. **The script should build your ILE code into the OSSILE library on IBM i!**
5. Update the buildlist.txt file (in the main/ directory) to include your new subdirectory name
6. Test and commit your changes!
