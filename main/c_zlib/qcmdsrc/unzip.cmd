             CMD        PROMPT('Unpack Zipped File')
 
             /* REQUIRED PARAMETERS */
 
             PARM       KWD(ZIPFILE) TYPE(*PNAME) LEN(128) MIN(1) +
                          EXPR(*YES) CASE(*MIXED) PROMPT('ZIP file +
                          name')
 
             /* OPTIONAL PARAMETERS */
 
             PARM       KWD(FILE) TYPE(*PNAME) LEN(128) DFT(*ALL) +
                          SPCVAL((*ALL)) EXPR(*YES) CASE(*MIXED) +
                          PROMPT('File to extract from ZIP file')
 
             PARM       KWD(ADDPATH) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*YES *NO) EXPR(*YES) +
                          PROMPT('Extract with pathname')
 
             PARM       KWD(REPLACE) TYPE(*CHAR) LEN(7) RSTD(*YES) +
                          DFT(*YES) VALUES(*YES *PROMPT) EXPR(*YES) +
                          PROMPT('Overwrite existing file')
 
             /* PMTRQS PARAMETERS */
 
             PARM       KWD(PASSWORD) TYPE(*CHAR) LEN(32) DFT(' ') +
                          EXPR(*YES) CASE(*MIXED) DSPINPUT(*NO) +
                          PMTCTL(*PMTRQS) PROMPT('Password for ZIP +
                          file')
 
