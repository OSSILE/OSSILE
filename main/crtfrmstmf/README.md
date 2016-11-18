# CRTFRMSTMF - Create From Stream File #

CRTFRMSTMF is a wrapper over the IBM i CRTxxx compile commands that do not allow a stream file.



###How do I get it setup?###

* Clone this git repository to a local directory in the IFS, e.g. in your home directory.
* Compile the source using the following CL commands (objects will be placed in the QGPL library):

```

CRTSRCPF FILE(QTEMP/QSOURCE) RCDLEN(198)
CPYFRMSTMF FROMSTMF('crtfrmstmf.pnlgrp') TOMBR('/QSYS.lib/QTEMP.lib/QSOURCE.file/PNLGRP.mbr') MBROPT(*ADD)
CPYFRMSTMF FROMSTMF('crtfrmstmf.cmd') TOMBR('/QSYS.lib/QTEMP.lib/QSOURCE.file/CMD.mbr') MBROPT(*ADD)

CRTBNDRPG PGM(QGPL/CRTFRMSTMF) SRCSTMF('crtfrmstmf.rpgle') REPLACE(*YES) TEXT('CRTFRMSTMF Program')
CRTPNLGRP PNLGRP(QGPL/CRTFRMSTMF) SRCFILE(QTEMP/QSOURCE) SRCMBR(PNLGRP) REPLACE(*YES) TEXT('CRTFRMSTMF Panel Group')
CRTCMD CMD(QGPL/CRTFRMSTMF) PGM(QGPL/CRTFRMSTMF) SRCFILE(QTEMP/QSOURCE) SRCMBR(CMD) TEXT('CRTFRMSTMF Command') HLPPNLGRP(QGPL/CRTFRMSTMF) HLPID(*CMD) REPLACE(*YES)

DLTOBJ OBJ(QTEMP/QSOURCE) OBJTYPE(*FILE)

```
