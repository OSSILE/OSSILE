      /if not defined(USRSPC_H)
      /define USRSPC_H

      /if not defined(QUSEC)
      /define QUSEC
      /copy QSYSINC/QRPGLESRC,QUSEC
      /endif

      *---------------------------------------------------------------
      * datastructure for UserSpace header section with OS/400 API
      *---------------------------------------------------------------
     D userspace_gen   DS                    qualified
     D   userArea                    64A
     D   headerSize                  10I 0
     D   releaseLevel                 4A
     D   formatName                   8A
     D   apiUsed                     10A
     D   dateCreated                 13A
     D   infoStatus                   1A
     D   usSizeUsed                  10I 0
     D   offsetInput                 10I 0
     D   sizeInput                   10I 0
     D   offsetHeader                10I 0
     D   headerSecSiz                10I 0
     D   offsetList                  10I 0
     D   listSecSize                 10I 0
     D   nmbrEntries                 10I 0
     D   entrySize                   10I 0
     D   entryCCSID                  10I 0
     D   regionID                     2A
     D   langID                       3A
     D   subListInd                   1A
     D   us_gen_reser                42A
      *---------------------------------------------------------------
      * datastructure for changing UserSpace attributes
      *---------------------------------------------------------------
     D userspace_attr  DS                  qualified
     D   size                        10I 0 inz(1)
     D   key                         10I 0 inz(3)
     D   dataLength                  10I 0 inz(1)
     D   data                         1A   inz('1')

      *---------------------------------------------------------------
      * Prototypes
      *---------------------------------------------------------------
      *
      * common: userspace = 10A usname + 10A lib name
      *
     D createUserspace...
     D                 PR                  extpgm('QUSCRTUS')
     D   usName                      20A   const
     D   usExtAtt                    10A   const
     D   usSize                      10I 0 const
     D   usInitValue                  1A   const
     D   usAuthority                 10A   const
     D   usDesc                      50A   const
     D   usReplace                   10A   const
     D   usError                           likeds(QUSEC)
      *
     D deleteUserspace...
     D                 PR                  extpgm('QUSDLTUS')
     D   usname                      20A   const
     D   error                             likeds(QUSEC)
      *
     D getUserspaceData...
     D                 PR                  extpgm('QUSRTVUS')
     D   usname                      20A   const
     D   startPos                    10I 0 const
     D   length                      10I 0 const
     D   receiver                  1024A   options(*varsize)
     D   error                             likeds(QUSEC) options(*nopass)
      *
     D changeUserspaceAttr...
     D                 PR                  extpgm('QUSCUSAT')
     D  retLib                       10A
     D  userspace                    20A   const
     D  usAttr                       64A   options(*varsize)
     D  error                              likeds(QUSEC)
      *
     D retrieveUserspacePtr...
     D                 PR                  extpgm('QUSPTRUS')
     D  userspace                    20A   const
     D  pointer                        *
     D  error                              likeds(QUSEC) options(*nopass)
      *
     D changeUserspaceData...
     D                 PR                  extpgm('QUSCHGUS')
     D   userspace                   20A   const
     D   start                       10I 0 const
     D   length                      10I 0 const
     D   data                     65535A   const options(*varsize)
     D   forceChanges                 1A   const
     D   error                             likeds(QUSEC) options(*nopass)
      *
     D retrieveUserspaceData...
     D                 PR                  extpgm('QUSRTVUS')
     D  userspace                    20A   const
     D  start                        10I 0 const
     D  length                       10I 0 const
     D  data                      65535A   options(*varsize)
     D  error                              likeds(QUSEC) options(*nopass)

      /endif
      