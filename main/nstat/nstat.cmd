/*  Netstat command with *OUTPUT   */
             CMD        PROMPT('NStat - OutPut for NetStat')
             PARM       KWD(LISTEN) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('Include +
                          Listening Ports?' 1)
             PARM       KWD(OUTPUT) TYPE(*CHAR) LEN(6) RSTD(*YES) +
                          DFT(*PRINT) VALUES(*PRINT *FILE) +
                          PROMPT('Output' 2)
             PARM       KWD(FILE) TYPE(FILE) PMTCTL(ISFILE) +
                          PROMPT('File Name' 3)
             PARM       KWD(FILEOPT) TYPE(*NAME) LEN(8) DFT(*ADD) +
                          SPCVAL((*ADD) (*REPLACE)) PMTCTL(ISFILE) +
                          PROMPT('File Option' 4)
 FILE:       QUAL       TYPE(*NAME) LEN(10)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library')
 ISFILE:     PMTCTL     CTL(OUTPUT) COND((*EQ '*FILE'))
