# CRTFRMSTMF - Create From Stream File #

CRTFRMSTMF is a wrapper over the IBM i CRTxxx compile commands that do not allow a stream file.

Example:
```
CRTFRMSTMF OBJ(*LIBL/MYCLPGM) CMD(CRTBNDCL) STMF('/MyDir/sourcefile.clsrc')
```

For build and setup instructions, refer to the [README.md](../../README.md) for the OSSILE project
