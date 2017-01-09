             CMD        PROMPT('Zip (compress) file')
 
             /* REQUIRED PARAMETERS */
 
             PARM       KWD(ZIPFILE) TYPE(*PNAME) LEN(128) MIN(1) +
                          EXPR(*YES) CASE(*MIXED) PROMPT('ZIP file +
                          name')
 
             PARM       KWD(FILES) TYPE(*PNAME) LEN(128) MIN(1) +
                          MAX(20) EXPR(*YES) CASE(*MIXED) +
                          PROMPT('Files to add ZIP file')
 
             /* OPTIONAL PARAMETERS */
 
             PARM       KWD(REPLACE) TYPE(*CHAR) LEN(8) RSTD(*YES) +
                          DFT(*REPLACE) VALUES(*REPLACE *APPEND +
                          *PROMPT) EXPR(*YES) PROMPT('Overwrite +
                          existing ZIP file')
 
             PARM       KWD(COMPLVL) TYPE(*CHAR) LEN(1) +
                          DFT(*DEFAULT) RANGE('0' '9') +
                          SPCVAL((*DEFAULT '6')) EXPR(*YES) +
                          PROMPT('Compression level')
 
             /* PMTRQS PARAMETERS */
 
             PARM       KWD(PASSWORD) TYPE(*CHAR) LEN(32) DFT(' ') +
                          EXPR(*YES) CASE(*MIXED) DSPINPUT(*NO) +
                          PMTCTL(*PMTRQS) PROMPT('Password for ZIP +
                          file')
 
