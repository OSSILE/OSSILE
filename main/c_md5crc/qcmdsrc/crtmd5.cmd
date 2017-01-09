/*===================================================================*/
/*  COMMAND name :  CRTMD5                                           */
/*  Author name..:  Chris Hird                                       */
/*  Date created :  Dec 2008                                         */
/*                                                                   */
/*                                                                   */
/*  Purpose......:  Create MD5 values for member & file data         */
/*  CPP..........:  CRTMD5                                           */
/*  Revision log.:                                                   */
/*  Date     Author    Revision                                      */
/*                                                                   */
/*===================================================================*/

             CMD        PROMPT('Create a CRC for File data')

             PARM       KWD(FILE) TYPE(QUAL1) MIN(1) PROMPT('File Name')
             PARM       KWD(CRCLVL) TYPE(*CHAR) LEN(5) RSTD(*YES) DFT(*MBR) SPCVAL((*FILE *FILE) (*MBR *MBR)) +
                          PROMPT('Level of CRC generation')
             PARM       KWD(CRYPT) TYPE(*INT2) RSTD(*YES) DFT(*MD5) SPCVAL((*MD5 1) (*SHA1 2) (*SHA256 3) (*SHA384 +
                          4) (*SHA512 5)) PROMPT('Hash key type')
             PARM       KWD(BUFSIZ) TYPE(*INT4) RSTD(*YES) DFT(32K) SPCVAL((32K 32768) (64K 65536) (1MB 1048576) +
                          (4MB 4194304) (16MB 16711568)) PROMPT('Buffer size to use')

 QUAL1:      QUAL       TYPE(*NAME) LEN(10)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) SPCVAL((*LIBL)) PROMPT('Library name:')
             QUAL       TYPE(*NAME) LEN(10)    DFT(*ALL) SPCVAL((*ALL)) PROMPT('Member')
