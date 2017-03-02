      /if not defined(OS_API_H)
      /define OS_API_H
      
      /if not defined(QUSEC)
      /define QUSEC
      /copy QSYSINC/QRPGLESRC,QUSEC
      /endif

     D listDatabaseRelations...
     D                 PR                  extpgm('QDBLDBR')
     D   userspace                   20A   const
     D   format                       8A   const
     D   filename                    20A   const
     D   member                      10A   const
     D   recordformat                10A   const
     D   error                             likeds(QUSEC)

     D listJobs        PR                  extpgm('QUSLJOB')
     D   userspace                   20A   const
     D   format                       8A   const
     D   qualJobName                 26A   const
     D   status                      10A   const
     D   errorCode                32767A   options(*varsize)
     D   jobType                      1A   const options(*nopass)
     D   numFldsToRtn                10I 0 const options(*nopass)
     D   fldsToRtn                   10I 0 const options(*nopass)

     D listFileMembers...
     D                 PR                  extpgm('QUSLMBR')
     D  userspace                    20A   const
     D  format                        8A   const
     D  filename                     20A   const
     D  member                       10A   const
     D  ovrProcessing                 1A   const
     D  error                              likeds(QUSEC) options(*nopass)

     D listObjects     PR                  extpgm('QUSLOBJ')
     D  userspace                    20A   const
     D  format                        8A   const
     D  objName                      20A   const
     D  objType                      10A   const
     D  apiError                           likeds(QUSEC) options(*nopass)
     D  objAut                       64A   options(*varsize : *nopass)
     D  selOmit                      64A   options(*varsize : *nopass)

     D listRecordFormats...
     D                 PR                  extpgm('QUSLRCD')
     D  userspace                    20A   const
     D  format                        8A   const
     D  filename                     20A   const
     D  ovrProcessing                 1A   const
     D  error                              likeds(QUSEC) options(*nopass)

     D retrieveJobInformation...
     D                 PR                  extpgm('QUSRJOBI')
     D   receiver                 65535A   options(*varsize)
     D   recLength                   10I 0 const
     D   format                       8A   const
     D   qualJobName                 26A   const
     D   intJobId                    16A   const
     D   error                             likeds(QUSEC) options(*nopass)

      /endif
      