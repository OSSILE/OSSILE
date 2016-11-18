# CRTFRMSTMF - Create From Stream File #

CRTFRMSTMF is a wrapper over the IBM i CRTxxx compile commands that do not allow a stream file.

Examples:
```
CRTFRMSTMF OBJ(*LIBL/MYCLPGM) CMD(CRTBNDCL) STMF('/MyDir/sourcefile.clsrc')
```
