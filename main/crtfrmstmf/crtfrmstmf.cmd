
/* ====================================================================================== */
/* CRTFRMSTMF - Create Object From Stream File                                            */
/* ====================================================================================== */

             CMD        PROMPT('Create Object From Stream File')

             PARM       KWD(OBJ) TYPE(QUAL1) RSTD(*NO) MIN(1) MAX(1) PROMPT('Object')

             PARM       KWD(CMD) TYPE(*NAME) LEN(10) RSTD(*YES) VALUES(CRTCMD CRTBNDCL CRTCLMOD CRTDSPF CRTPRTF +
                          CRTLF CRTPF CRTMNU CRTPNLGRP CRTQMQRY CRTSRVPGM CRTWSCST) MIN(1) CHOICE(*VALUES) PROMPT('Compile command')

             PARM       KWD(SRCSTMF) TYPE(*PNAME) LEN(5000) MIN(1) VARY(*YES *INT2) CASE(*MIXED) PROMPT('Source +
                          stream file')

             PARM       KWD(PARMS) TYPE(*CHAR) LEN(2000) VARY(*YES *INT2) CASE(*MONO) PROMPT('Additional +
                          parameters')

 QUAL1:      QUAL       TYPE(*NAME) LEN(10) RSTD(*NO) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) RSTD(*NO) DFT(*CURLIB) SPCVAL((*CURLIB)) MIN(0) PROMPT('Library')
