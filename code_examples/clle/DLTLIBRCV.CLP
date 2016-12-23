      PGM        PARM(&LIB)
         /* ===================================================================== */
         /* List ALL JRNRCV from a library to delete                              */
         /*  show how to use a USer Space with modern CL syntax                   */
         /* ===================================================================== */
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&QUAL) TYPE(*CHAR) LEN(20) VALUE(*ALL)
             DCL        VAR(&COUNT) TYPE(*INT)
             
             DCL        VAR(&pointeur) TYPE(*PTR)

             DCL        VAR(&ptrinfos) TYPE(*PTR)
             DCL        VAR(&DATA) TYPE(*CHAR) STG(*BASED) LEN(16) +
                          BASPTR(&PTRINFOS) /* like a DS in RPG */
               DCL        VAR(&BEGIN) TYPE(*INT) STG(*DEFINED) DEFVAR(&DATA)
               DCL        VAR(&HOWMANY) TYPE(*INT) STG(*DEFINED)  +
                            DEFVAR(&DATA 9)
               DCL        VAR(&SIZE) TYPE(*INT) STG(*DEFINED)  +
                            DEFVAR(&DATA 13)


             DCL        VAR(&ptrretour) TYPE(*PTR)
             DCL        VAR(&RETOUR) TYPE(*CHAR) STG(*BASED) LEN(30) +
                          BASPTR(&PTRRETOUR) 
               DCL        VAR(&OBJ) TYPE(*CHAR) STG(*DEFINED) LEN(10) +
                            DEFVAR(&RETOUR)
               DCL        VAR(&OBJLIB) TYPE(*CHAR) STG(*DEFINED) LEN(10) +
                            DEFVAR(&RETOUR 11)
               DCL        VAR(&OBJTYPE) TYPE(*CHAR) STG(*DEFINED) LEN(10) +
                            DEFVAR(&RETOUR 21)

          /* fields for message handling    */
             DCL        &MSGID   *CHAR LEN(7)             /* ID MSG  */
             DCL        &MSGDTA  *CHAR LEN(100)           /* DATA    */
             DCL        &MSGF    *CHAR LEN(10)            /* FICHIER */
             DCL        &MSGFLIB *CHAR LEN(10)            /* BIBLI   */
              MONMSG     MSGID(CPF0000) EXEC(GOTO ERREUR)

/* main */
             DLTUSRSPC QTEMP/DLTLIBRCV
              MONMSG     MSGID(CPF2105) EXEC(RCVMSG PGMQ(*SAME) +
                          MSGTYPE(*EXCP))

         /* CREATE USER SPACE */
              CALL       PGM(QUSCRTUS) PARM('DLTLIBRCV QTEMP' /* USRSPC   */ +
                                            '          '      /* ATTRIBUT */ +

                                            X'0000FFFF'       /* SIZE   */ +
                                            X'00'             /* INIT   */ +
                                            '*USE'            /* Auth   */ +
                                            'FOR DLTLIBRCV') /* TEXT   */
         /* LIST ALL OBJETS *JRNRCV  */
             CHGVAR     VAR(%SST(&QUAL 11 10)) VALUE(&LIB)
             CALL QUSLOBJ  PARM('DLTLIBRCV QTEMP'  /* USRSPC   */       +
                                'OBJL0100'         /* FORMAT   */       +
                                &QUAL              /* bib/obj  */       +
                                '*JRNRCV'          /* type     */       +
                               )
         /* USer Space beginning                                */
             CALL       PGM(QUSPTRUS) PARM('DLTLIBRCV QTEMP' &Pointeur)
         /* retreive &DATA, include &BEGIN, &SIZE and &HOWMANY    */
             chgvar     &ptrinfos &pointeur
             CHGVAR     %OFFSET(&ptrinfos) VALUE(%OFFSET(&ptrinfos) + 124)


         /* list beginning (&retour is going IN the User Space) */
             chgvar     &ptrretour &pointeur
             CHGVAR     %OFFSET(&ptrretour) VALUE(%OFFSET(&ptrretour) + +
                          &BEGIN )

            DOFOR      VAR(&COUNT) FROM(1) TO(&HOWMANY) BY(1)

                /* &OBJLIB and &OBJ are parts of &RETOUR  
                DLTJRNRCV  JRNRCV(&OBJLIB/&OBJ)
                  MONMSG     MSGID(CPF7022)


               if         (&count < &howmany) then(do)
                  CHGVAR     %OFFSET(&ptrretour) VALUE(%OFFSET(&ptrretour) +
                               + &SIZE)
               ENDDO
             ENDDO

         
          /* RETURN *COMP MESSAGES IF ENDs NORMALY */
 COMPMSG:
             DLTUSRSPC QTEMP/DLTLIBRCV
             SNDPGMMSG  MSG('Cleanup on journal receivers +
                          done') TOPGMQ(*PRV (*PGMBDY)) +
                          MSGTYPE(*COMP)
             return

                     /* RETURN THE ERROR MESSAGE  */
 ERREUR:
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) MSGFLIB(&MSGFLIB)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) TOPGMQ(*PRV (*PGMBDY)) +
                          MSGTYPE(*ESCAPE)
             ENDPGM