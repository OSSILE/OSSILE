# OSSILE

Welcome to the OSSILE project. This project is to serve two purposes:
  1. This project is to provide, via the open source community, a wide set of utilities for IBM i. They will get built into the OSSILE library. 
  2. This project is to provide working examples of various things in ILE languages (RPG, C, C++)

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

 - UDTF list_source_members originally sourced from http://www.volubis.fr/freeware/SQLUDTF.html
    
    Documentation:
      - [LIST_SOURCE_MEMBERS](main/udtf_list_source_members/README.md)
      
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
## ``c_examples/``
 This directory houses examples of how to accomplish various tasks in ILE C. They do not need to be working, compilable examples (though that is preferred).
## ``clle_examples/``
 This directory houses examples of how to accomplish various tasks in ILE CL. They do not need to be working, compilable examples (though that is preferred).
## ``rpg_examples/``
 This directory houses examples of how to accomplish various tasks in ILE RPG. They do not need to be working, compilable examples (though that is preferred).
## ``sql_examples/``
 This directory houses examples of how to accomplish various tasks using SQL scripts. 

# Contributing 
See [CONTRIBUTING.md](CONTRIBUTING.md)
