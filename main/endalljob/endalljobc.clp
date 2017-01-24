PGM        parm(&job)
 DCL        &job *char 10
 DCL        &USR *CHAR 10
 DCL        &NBR *CHAR  6
 DCL        &MSGDTA *CHAR 26
 DCL        &MSGID *CHAR 7
 MONMSG     CPF0000 exec(goto error)


 ENDJOB     JOB(&JOB) OPTION(*IMMED) DUPJOBOPT(*MSG)
  monmsg     cpf1332 exec(do) /* Duplicate Job */
   RCVMSG     PGMQ(*SAME (*)) MSGDTA(&MSGDTA) MSGID(&MSGID)
   DOWHILE    COND(&MSGID *NE 'CPF1332')
     IF         (&MSGID = 'CPF0906') THEN(DO)
       /* User & nbr are in MSGDTA  */
       CHGVAR     &USR %SST(&MSGDTA 11 10)
       CHGVAR     &NBR %SST(&MSGDTA 21 6)
       ENDJOB     JOB(&NBR/&USR/&JOB) OPTION(*IMMED)
         monmsg     CPF1300
     ENDDO

   RCVMSG     PGMQ(*SAME (*)) MSGDTA(&MSGDTA) MSGID(&MSGID)
   ENDDO
  ENDDO
  SNDPGMMSG  MSG('Job(s)' *bcat &job *bcat 'ended') TOPGMQ(*PRV (*)) MSGTYPE(*COMP)   
 return

error:
  SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Unable to end job' *BCAT &job) + 
             TOPGMQ(*PRV (*)) MSGTYPE(*ESCAPE)
ENDPGM
 