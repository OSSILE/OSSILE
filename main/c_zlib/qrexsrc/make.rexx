/* ILE-C compile REXX proc */
SAY " "
SAY "Start ZLIB compilation."
SAY " You must have authority to exec CRTCMOD and CRTPGM."
SAY " "
SAY "    * * * * * * * * * * * * * * * * * * * * * * "
SAY " "
/* SAY "Input object library name."    */
/* PULL OLIB                           */
OLIB = 'OSSZLIB'
/* PULL SRCLIB                         */
SRCLIB = 'OSSILE'
SAY " "
OUTPUT = '*PRINT'
OPTIMIZE = '10'
/* OPTIMIZE = '40' */
DEBUG = '*ALL'
/* DEBUG = '*NONE'*/
/* SYSIFCOPT = '*IFSIO' */
SYSIFCOPT = '*IFS64IO'
/* TGTRLS = '*CURRENT' */
TGTRLS = '*CURRENT'

/* defs */
D1 = 'AS400'
D2 = 'HAVE_MEMCPY'
D3 = 'unix'
D4 = 'OS400'
D5 = 'NODOBANNER'
D6 = 'FPRINT2SNDMSG'
D7 = 'CASESENSITIVITYDEFAULT_NO'

/* zlib modules */
MO.1 = 'adler32'
MO.2 = 'compress'
MO.3 = 'crc32'
MO.4 = 'deflate'
MO.5 = 'gzio'
MO.6 = 'infback'
MO.7 = 'inffast'
MO.8 = 'inflate'
MO.9 = 'inftrees'
MO.10 = 'ioapi'
MO.11 = 'trees'
MO.12 = 'uncompr'
MO.13 = 'zutil'
/* Sample programs (not used) */
MO.14 = 'example'
MO.15 = 'minigzip'
/* 'maketreee' This program is included in the distribution for completeness. */
/* minizip */
MO.16 = 'miniunz'
MO.17 = 'minizip'
MO.18 = 'zip'
MO.19 = 'unzip'
MO.20 = 'ebcdic'
/* OS/400 interface */
MO.21 = 'DSPZIP'
MO.22 = 'UNZIP'
MO.23 = 'ZIP'

SAY 'Change JOBCCSID to 37 temporarily.'
SAY 'Remember to set correct JOBCCSID after compilation if necessary.'
SAY ' '
'CHGJOB CCSID(37)'

SAY 'Create program library for ZLIB..'
'CRTLIB LIB(ZLIB)'
SAY 'Start creating modules for ZLIB...'
DO I = 1 TO 13
  SAY '  creating module 'MO.I'...'
  'CRTCMOD MODULE(&SRCLIB/'MO.I') SRCFILE(&SRCLIB/QCSRC) ',
  'OUTPUT(&OUTPUT) OPTIMIZE(&OPTIMIZE) DBGVIEW(&DEBUG) ',
  'DEFINE(&D1 &D2 &D4) ',
  'SYSIFCOPT(&SYSIFCOPT) TGTRLS(&TGTRLS)'
  SAY "  result->" RC
END
SAY 'Creating service program ZLIB...'
'CRTSRVPGM SRVPGM(&OLIB/ZLIB) MODULE(',
'&SRCLIB/'MO.1' &SRCLIB/'MO.2' &SRCLIB/'MO.3' &SRCLIB/'MO.4' &SRCLIB/'MO.5' ',
'&SRCLIB/'MO.6' &SRCLIB/'MO.7' &SRCLIB/'MO.8' &SRCLIB/'MO.9' &SRCLIB/'MO.10' ',
'&SRCLIB/'MO.11' &SRCLIB/'MO.12' &SRCLIB/'MO.13') ',
'EXPORT(*ALL) TGTRLS(&TGTRLS) TEXT(''zlib 1.2.1 *SRVPGM for OS/400'')'
  SAY "  result->" RC
SAY " "

SAY 'Start creating program and modules miniunz/minizip for OS/400...'
DO I = 16 TO 20
  SAY '  creating module 'MO.I'400...'
  'CRTCMOD MODULE(&SRCLIB/'MO.I'400) SRCFILE(&SRCLIB/QCSRC) SRCMBR('MO.I') ',
  'OUTPUT(&OUTPUT) OPTIMIZE(&OPTIMIZE) DBGVIEW(&DEBUG) ',
  'DEFINE(&D1 &D3 &D5 &D6 &D7) ',
  'SYSIFCOPT(&SYSIFCOPT) TGTRLS(&TGTRLS)'
  SAY "  result->" RC
END
  SAY '  creating program MINIUNZ400...'
  'CRTPGM PGM(&OLIB/MINIUNZ400) ',
  'MODULE(&SRCLIB/MINIUNZ400 &SRCLIB/UNZIP400 &SRCLIB/EBCDIC400) ',
  'BNDSRVPGM(&OLIB/ZLIB) DETAIL(*BASIC) TGTRLS(&TGTRLS) ',
  "TEXT('miniunz for OS/400')"
  SAY "  result->" RC
  SAY '  creating program MINIZIP400...'
  'CRTPGM PGM(&OLIB/MINIZIP400) ',
  'MODULE(&SRCLIB/MINIZIP400 &SRCLIB/ZIP400 &SRCLIB/EBCDIC400) ',
  'BNDSRVPGM(&OLIB/ZLIB) DETAIL(*BASIC) TGTRLS(&TGTRLS) ',
  "TEXT('minizip for OS/400')"
  SAY "  result->" RC

SAY 'Start creating program and modules miniunz/minizip for Qshell...'
DO I = 16 TO 20
  SAY '  creating module 'MO.I'...'
  'CRTCMOD MODULE(&SRCLIB/'MO.I') SRCFILE(&SRCLIB/QCSRC) ',
  'OUTPUT(&OUTPUT) OPTIMIZE(&OPTIMIZE) DBGVIEW(&DEBUG) ',
  'DEFINE(&D1 &D3) ',
  'SYSIFCOPT(&SYSIFCOPT) TGTRLS(&TGTRLS)'
  SAY "  result->" RC
END
  SAY '  creating program MINIUNZ...'
  'CRTPGM PGM(&OLIB/MINIUNZ) ',
  'MODULE(&SRCLIB/MINIUNZ &SRCLIB/UNZIP &SRCLIB/EBCDIC) ',
  'BNDSRVPGM(&OLIB/ZLIB) DETAIL(*BASIC) TGTRLS(&TGTRLS) ',
  "TEXT('miniunz for Qshell')"
  SAY "  result->" RC
  SAY '  creating program MINIZIP...'
  'CRTPGM PGM(&OLIB/MINIZIP) ',
  'MODULE(&SRCLIB/MINIZIP &SRCLIB/ZIP &SRCLIB/EBCDIC) ',
  'BNDSRVPGM(&OLIB/ZLIB) DETAIL(*BASIC) TGTRLS(&TGTRLS) ',
  "TEXT('minizip for Qshell')"
  SAY "  result->" RC

SAY " "
SAY 'Remove/add symbolic link...'
SAY ' (ignore "no such link error" for the first compilation...)'
  "QSH CMD('rm /usr/bin/minizip')"
  "QSH CMD('ln -s /qsys.lib/zlib.lib/minizip.pgm /usr/bin/minizip')"
  SAY "  result->" RC
  "QSH CMD('rm /usr/bin/miniunz')"
  "QSH CMD('ln -s /qsys.lib/zlib.lib/miniunz.pgm /usr/bin/miniunz')"
  SAY "  result->" RC

SAY " "
SAY 'Creating OS/400 command interface...'
DO I = 21 TO 23
  SAY '  creating CL module 'MO.I'CLP...'
  'CRTCLMOD MODULE(&SRCLIB/'MO.I'CLP) ',
  'SRCFILE(&SRCLIB/QCLSRC) TGTRLS(&TGTRLS) ',
  'DBGVIEW(&DEBUG)'
  SAY "  result->" RC
  SAY '  creating CL program 'MO.I'CLP...'
  'CRTPGM PGM(&OLIB/'MO.I'CLP) MODULE(&SRCLIB/'MO.I'CLP) TGTRLS(&TGTRLS) ',
  'BNDSRVPGM(QHTTPSVR/QZHBCGI)'
  SAY "  result->" RC
  SAY '  creating PLNGRP for 'MO.I'...'
  'CRTPNLGRP PNLGRP(&OLIB/'MO.I'HLP) SRCFILE(&SRCLIB/QCMDSRC) CHRID(37 37)'
  SAY "  result->" RC
  SAY '  creating OS/400 CMD for 'MO.I'...'
  'CRTCMD CMD(&OLIB/'MO.I') PGM(&OLIB/'MO.I'CLP) SRCFILE(&SRCLIB/QCMDSRC) ',
  'HLPPNLGRP(&OLIB/'MO.I'HLP) HLPID(*CMD)'
  SAY "  result->" RC
END

SAY " "
SAY "Compile finished. Confirm error(s) if exists."
SAY " "
