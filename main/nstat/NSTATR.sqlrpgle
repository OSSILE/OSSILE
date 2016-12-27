      *  Many thanks to Carsten Flensburg for the skeleton API
     **-- Header specifications:  --------------------------------------------**
     H Option( *SrcStmt )
     H dftactgrp( *no ) bnddir( 'QC2LE' )
     **-- File specifications:  ----------------------------------------------**
     FQsysprt   o    f  132        Printer OfLind(*inof)
     F                                     Usropn
     F                                     Formlen(66)
     F                                     Formofl(61)
     **-- Global declarations:  ----------------------------------------------**
     D Idx             s             10u 0
     D PxUsrSpc        c                   'NSTATUSPC QTEMP'
     **-- Api error data structure:  -----------------------------------------**
     D ApiError        Ds
     D  AeBytPro                     10i 0 Inz( %Size( ApiError ))
     D  AeBytAvl                     10i 0 Inz
     D  AeMsgId                       7a
     D                                1a
     D  AeMsgDta                    128a
     **-- API Header information:  -------------------------------------------**
     D HdrInf          Ds                  Based( pHdrInf )
     D  HiUsrSpcNamSp                10a
     D  HiUsrSpcLibSp                10a
     **-- User space generic header:  ---------- -----------------------------**
     D UsrSpc          Ds                  Based( pUsrSpc )
     D  UsOfsHdr                     10i 0 Overlay( UsrSpc: 117 )
     D  UsOfsLst                     10i 0 Overlay( UsrSpc: 125 )
     D  UsNumLstEnt                  10i 0 Overlay( UsrSpc: 133 )
     D  UsSizLstEnt                  10i 0 Overlay( UsrSpc: 137 )
     **-- User space pointers:  ----------------------------------------------**
     D pUsrSpc         s               *   Inz( *Null )
     D pHdrInf         s               *   Inz( *Null )
     D pLstEnt         s               *   Inz( *Null )
     **-- Connection list qualifier:  ----------------------------------------**
     D NCLQ0100        Ds
     D  N1NetCnnTyp                  10a   Inz( '*ALL' )
     D* N1NetCnnTyp                  10a   Inz( '*ALL' )
     D* N1LstRqsTyp                  10a   Inz( '*ALL' )
     D  N1LstRqsTyp                  10a   Inz( '*ALL   ' )
     D                               12a   Inz( *Allx'00' )
     D  N1LocAdrLow                  10i 0 Inz( 0 )
     D  N1LocAdrUpr                  10i 0 Inz( 0 )
     D* N1LocPortLow                 10i 0 Inz( 0 )
     D* N1LocPortUpr                 10i 0 Inz( 0 )
     D  N1LocPortLow                 10i 0 Inz( 0 )
     D  N1LocPortUpr                 10i 0 Inz( 0 )
     D  N1RmtAdrLow                  10i 0 Inz( 0 )
     D  N1RmtAdrUpr                  10i 0 Inz( 0 )
     D* N1RmtAdrLow                  10i 0 Inz( 0 )
     D* N1RmtAdrUpr                  10i 0 Inz( 0 )
     D  N1RmtPortLow                 10i 0 Inz( 0 )
     D  N1RmmPortUpr                 10i 0 Inz( 0 )
     **-- Connection list entry:  --------------------------------------------**
     D NCNN0100        Ds                  Based( pLstEnt )
     D  C1RmtAdr                     15a
     D                                1a
     D  C1RmtAdrBin                  10i 0
     D  C1LocAdr                     15a
     D                                1a
     D  C1LocAdrBin                  10i 0
     D  C1RmtPort                    10i 0
     D  C1LocPort                    10i 0
     D  C1TcpState                   10i 0
     D  C1IdlTimMs                   10i 0
     D  C1BytIn                      20i 0
     D  C1BytOut                     20i 0
     D  C1ConOpnTyp                  10i 0
     D  C1NetCnnTyp                  10a
     D                                2a
     D  C1UserPrf                    10a                                        *new
     D                                2a                                        *new
     **-- Create user space: -------------------------------------------------**
     D CrtUsrSpc       Pr                  ExtPgm( 'QUSCRTUS' )
     D  CsSpcNamQ                    20a   Const
     D  CsExtAtr                     10a   Const
     D  CsInzSiz                     10i 0 Const
     D  CsInzVal                      1a   Const
     D  CsPubAut                     10a   Const
     D  CsText                       50a   Const
     **-- Optional 1:
     D  CsReplace                    10a   Const Options( *NoPass )
     D  CsError                   32767a         Options( *NoPass: *VarSize )
     **-- Optional 2:
     D  CsDomain                     10a   Const Options( *NoPass )
     **-- Delete user space: -------------------------------------------------**
     D DltUsrSpc       Pr                  ExtPgm( 'QUSDLTUS' )
     D  DsSpcNamQ                    20a   Const
     D  DsError                   32767a         Options( *VarSize )
     **-- Retrieve pointer to user space: ------------------------------------**
     D RtvPtrSpc       Pr                  ExtPgm( 'QUSPTRUS' )
     D  RpSpcNamQ                    20a   Const
     D  RpPointer                      *
     D  RpError                   32767a         Options( *NoPass: *VarSize )
     **-- List network connections:  -----------------------------------------**
     D LstNetCnn       Pr                  ExtProc( 'QtocLstNetCnn' )
     D  LcSpcNamQ                    20a   Const
     D  LcFmtNam                      8a   Const
     D  LcCnnQual                    64a   Const
     D  LcCnnQualSiz                 10i 0 Const
     D  LcCnnQualFmt                  8a   Const
     D  LcError                   32767a         Options( *VarSize )
     **
     D InetAddr        Pr            10U 0 ExtProc('inet_addr')
     D                                 *   Value
     D InetNtoa        Pr              *   ExtProc('inet_ntoa')
     D                               10U 0 Value
      *---------Network attributes-------------
     d/copy qsysinc/qrpglesrc,qwcrneta

     d rcv             ds           256
     d  number                 1      4b 0
     d  off1                   5      8b 0
     D*
     d misc            ds
     d  rcvsiz                 1      4b 0 inz(256)
     d  nbr                    5      8b 0 inz(1)
     d  neta                   9     18    inz('SYSNAME')
      *
     d off             s              3  0
     d sysnam          s              8
      *-----------------------------------
     D sqlstm          s            500
     D sqlstm1         s            500
     D tick            s              1    Inz('''')
     D HHMMSS          s              6  0
     D CnnStat         s             11
     D bytein          s             12  0
     D byteout         s             12  0
     D IdleTime        S               t   timfmt(*hms)
     D #idle           S               t
     D Idle            S             10  0
     D ZeroTime        S               t   inz
     D rmtport         S              6  0
     D lclport         S              6  0
     D Idleh           S              3  0
     D Idlem           S              2  0
     D Idles           S              2  0
     D Idled           S              2  0
     D Idlemr          S             10 10
     D Idlesr          S             10 10

     D  WORK_SECS      s             29P 2
     D  WORK_MINS      s             29P 5
     D  WORK_HRS       s             29P 5
     D  WORK_DAYS      s             29P 5

     D  DURR_MINS      s              3U 0
     D  DURR_HRS       s              3U 0
     D  DURR_DAYS      s              5U 0
     D  DURR_SECS      s             27P 0

     DOutFile          DS
     D ##file                        10a
     D ##lib                         10a

     **
     **-- Mainline:  ---------------------------------------------------------**
     **
     C     *Entry        Plist
     c                   Parm                    include           1
     c                   Parm                    OutPut            6
      *                                               OutPut(*Print *File)
     c                   Parm                    OutFile
      *                                               OutPutFile and Library
     c                   Parm                    FileOpt           8
      *                                               File Option(*REPLACE -or- *ADD)

     c     loop          tag
     **
     C                   CallP     CrtUsrSpc( PxUsrSpc
     C                                      : *Blanks
     C                                      : 65535
     C                                      : x'00'
     C                                      : '*CHANGE'
     C                                      : *Blanks
     C                                      : '*YES'
     C                                      : ApiError
     C                                      )
     **
     C                   CallP     LstNetCnn( PxUsrSpc
     C                                      : 'NCNN0100'
     C                                      : NCLQ0100
     C                                      : %Size( NCLQ0100 )
     C                                      : 'NCLQ0100'
     C                                      : ApiError
     C                                      )
     **
     C                   If        AeBytAvl    = *Zero
     C                   ExSr      PrcLstEnt
     C                   EndIf
     **
     C                   CallP     DltUsrSpc( PxUsrSpc
     C                                      : ApiError
     C                                      )
     **
     C                   eval      *INLR = *ON
     c                   return
     **
     **-- Process list entry:  -----------------------------------------------**
     C     PrcLstEnt     BegSr
     **
     C                   CallP     RtvPtrSpc( PxUsrSpc
     C                                      : pUsrSpc
     C                                      )
     **
     C                   Eval      pHdrInf     = pUsrSpc + UsOfsHdr
     C                   Eval      pLstEnt     = pUsrSpc + UsOfsLst
     **
     C                   For       Idx         = 1  to UsNumLstEnt
     **
     c                   if        C1IdlTimMs < 0
     c                   eval      IdleH = 999
     c                   eval      IdleM = 99
     c                   eval      IdleS = 99
     c                   eval      IdleD = 99
     c                   else
     **
     c                   Eval      work_secs = C1IdlTimMs / 1000
     C     Work_Secs     DIV       60            Work_Mins
     C     Work_Mins     DIV       60            Work_Hrs
     C     Work_Hrs      DIV       24            Work_Days
     C
     C                   Z-ADD     Work_Days     Durr_Days
     C                   EVAL      Durr_Hrs   = (Work_Days * 24) -
     C                                          (Durr_Days * 24)
     C                   EVAL      Durr_Mins  =  Work_Mins -
     C                               (((Durr_Days * 24) * 60) + (Durr_Hrs * 60))
     C                   Z-ADD     Work_Mins     Durr_Secs
     C                   eval      Durr_Secs  =  (Work_Mins - Durr_Secs) *60

     C                   if        Durr_Mins = 60
     C                   add       01            Durr_Hrs
     C                   clear                   Durr_Mins
     C                   endif
     c                   eval      IdleH = Durr_Hrs + (Durr_Days * 24)
     c                   eval      IdleM = Durr_Mins
     c                   eval      IdleS = Durr_Secs
     c                   eval      IdleD = Durr_Days

     c                   endif

     c                   eval      ByteIn  = C1BytIn
     c                   eval      ByteOut = C1BytOut
     c                   eval      RmtPort = C1RmtPort
     c                   eval      LclPort = C1LocPort
     c                   select
     c                   when      C1TcpState = 0
     c                   if        include = 'N'
     C                   move      zerotime      Idletime
     c                   goto      nolisten
     c                   endif
     c                   Eval      CnnStat   = 'Listen     '
     c                   when      C1TcpState = 1
     c                   Eval      CnnStat   = 'SYN-sent   '
     c                   when      C1TcpState = 2
     c                   Eval      CnnStat   = 'SYN-recvd  '
     c                   when      C1TcpState = 3
     c                   Eval      CnnStat   = 'Established'
     c                   when      C1TcpState = 4
     c                   Eval      CnnStat   = 'FIN-wait-1 '
     c                   when      C1TcpState = 5
     c                   Eval      CnnStat   = 'FIN-wait-2 '
     c                   when      C1TcpState = 6
     c                   Eval      CnnStat   = 'Close-wait '
     c                   when      C1TcpState = 7
     c                   Eval      CnnStat   = 'Closing    '
     c                   when      C1TcpState = 8
     c                   Eval      CnnStat   = 'Last-ACK   '
     c                   when      C1TcpState = 9
     c                   Eval      CnnStat   = 'Time-wait  '
     c                   when      C1TcpState = 10
     c                   Eval      CnnStat   = 'Closed     '
     c                   other
     c                   Eval      CnnStat   = 'Not Supptd '
     c                   endsl
     ** Write the Record.
     c                   if        OutPut = '*PRINT'
     C                   Except    prtline
     C                   move      zerotime      Idletime
     c                   endif
     c                   if        OutPut = '*FILE'
     C                   Exsr      $SQLAddRec
     c                   endif
     **
     c     nolisten      tag
      *                         end include for listening ports

     C                   If        Idx         < UsNumLstEnt
     C                   Eval      pLstEnt     = pLstEnt + UsSizLstEnt
     C                   EndIf
     C                   EndFor
     **
     C                   EndSr
     ** TCP state. A typical connection goes through the states:
     **
      * C1TcpState
     **
     ** 0 Listen.      Waiting for a connection request from any remote host.
     ** 1 SYN-sent.    Waiting for a matching connection request after having
     **                 sent connection request.
     ** 2 SYN-rcvd.    Waiting for a confirming connection request acknowledgement.
     ** 3 Established. The normal state in which data is transferred.
     ** 4 FIN-wait-1.  Waiting for the remote host to acknowledge the local
     **                 system request to end the connection.
     ** 5 FIN-wait-2.  Waiting for the remote host request to end the connection.
     ** 6 Close-wait.  Waiting for an end connection request from the local user.
     ** 7 Closing.     Waiting for an end connection request acknowledgement from the remote host.
     ** 8 Last-ACK.    Waiting for the remote host to acknowledge an end connection r quest.
     ** 9 Time-wait.   Waiting to allow the remote host enough time to receive the
     **                 the local system's acknowledgement to end.
     ** 10 Closed.     The connection has ended.
     ** 11 State value not supported by protocol.
      *--------- Start the program ---------------
     C     *inzsr        begsr

     c                   if        Output = '*FILE' and
     c                             Fileopt = '*REPLACE'
     C                   Exsr      $SQLDrop
     C                   Exsr      $SQLCreate
     c                   endif
     c                   if        Output = '*FILE' and
     c                             Fileopt = '*ADD'
     C                   Exsr      $SQLCreate
     c                   endif

     c                   if        OutPut = '*PRINT'
     c                   Open      Qsysprt
     c                   except    header
     C                   Time                    HHMMSS
     C                   Eval      *inOF = *on
     c                   endif

      * Call Retrieve Network Attributes API
     c                   call      'QWCRNETA'
     c                   parm                    rcv
     c                   parm                    rcvsiz
     c                   parm                    nbr
     c                   parm                    neta
     c                   parm                    apierror
     C*
     c                   if        (number = 1)
     C*
     c                   eval      off = (off1 + 1)
     C* Header Information for the Network Attribute
     c                   eval      %subst(qwcrat:1:16) =
     c                             %subst(rcv:off:16)
     C*
     c                   eval      off = (off + 16)
     C*
     c                   if        (qwcna = 'SYSNAME')
     C*
     c                   move      *blanks       sysnam
     C* Get the returned value
     c                   eval      %subst(sysnam:1:qwcld) =
     c                             %subst(rcv:off:qwcld)
     c                   endif
     c                   endif
     c                   endsr

      /free
          exec SQL Set option naming=*sys, commit=*none,
              CompileOpt='DBGVIEW(*List)';
      /end-free

      *---------------------------------------------------------------
     C* SQL Create Table
      *---------------------------------------------------------------
     C     $SQLCreate    Begsr

     C                   eval      sqlStm = 'create table ' +
     C                                %trim(##lib) + '/' +
     C                                %trim(##File) + '('    +
     C                                ' LclAddr    CHAR(15)      NOT NULL,' +
     C                                ' RmtAddr    CHAR(15)      NOT NULL,' +
     C                                ' LclPort    NUMERIC(5,0)  NOT NULL,' +
     C                                ' RmtPort    NUMERIC(5,0)  NOT NULL,' +
     C                                ' BytesIn    NUMERIC(10,0) NOT NULL,' +
     C                                ' BytesOut   NUMERIC(10,0) NOT NULL,' +
     C                                ' IdleHour   NUMERIC(3,0)  NOT NULL,' +
     C                                ' IdleMin    NUMERIC(2,0)  NOT NULL,' +
     C                                ' IdelSec    NUMERIC(2,0)  NOT NULL,' +
     C                                ' UsrPrf     CHAR(10)      NOT NULL,' +
     C                                ' ConnStat   CHAR(11)      NOT NULL,' +
     C                                ' ConnType   CHAR(10)      NOT NULL,' +
     C                                ' OutPutTime TIMESTAMP +
     C                                  NOT NULL WITH DEFAULT ' +
     C                                 ') '

     c/Exec Sql
     c+    declare s statement
     c/End-Exec

     c/Exec Sql
     c+    prepare s from :sqlStm
     c/End-Exec

     c/Exec Sql
     c+    execute s
     c/End-Exec

     C                   Endsr
      *---------------------------------------------------------------
     C* SQL Drop Table
      *---------------------------------------------------------------
     C     $SQLDrop      Begsr

     C                   eval      sqlStm = 'drop table ' +
     C                                %trim(##lib) + '/' +
     C                                %trim(##File)

      *C/exec SQL
      *C+  Set option commit = *none, CompileOpt='DBGVIEW(*List)'
      *C/end-EXEC

     c/Exec Sql
     c+    declare d statement
     c/End-Exec

     c/Exec Sql
     c+    prepare d from :sqlStm
     c/End-Exec

     c/Exec Sql
     c+    execute d
     c/End-Exec

     C                   Endsr
      *---------------------------------------------------------------
     C* SQL Add to Table
      *---------------------------------------------------------------
     C     $SQLAddRec    Begsr

     C                   eval      sqlStm1 = 'insert into ' +
     C                                %trim(##lib) + '/' +
     C                                %trim(##File) + '('    +
     C                                ' LclAddr,' +
     C                                ' RmtAddr,' +
     C                                ' LclPort,' +
     C                                ' RmtPort,' +
     C                                ' BytesIn,' +
     C                                ' BytesOut,' +
     C                                ' IdleHour,' +
     C                                ' IdleMin,' +
     C                                ' IdelSec,' +
     c                                ' UsrPrf,' +
     C                                ' ConnStat,'+
     C                                ' ConnType' +
     C                                 ') Values('+ tick +
     c                                c1locadr + tick + ', ' + tick +
     c                                c1rmtadr + tick + ', ' +
     c                                %editc(lclport : '3') + ', ' +
     c                                %editc(rmtport : '3') + ', ' +
     c                                %editc(bytein : '3')  + ', ' +
     c                                %editc(byteout : '3') + ', ' +
     c                                %editc(idleh : '3')   + ', ' +
     c                                %editc(idlem : '3')   + ', ' +
     c                                %editc(idles : '3')   + ', ' + tick +
     c                                C1UserPrf + tick + ', ' + tick +
     c                                CnnStat  + tick + ', ' + tick +
     c                                C1NetCnnTyp + tick + ')'

     c/Exec Sql
     c+    declare w statement
     c/End-Exec

     c/Exec Sql
     c+    prepare w from :sqlStm1
     c/End-Exec

     c/Exec Sql
     c+    execute w
     c/End-Exec

     C                   Endsr
      *---------------------------------------------------------------
     OQsysprt   e    OF      Header         1 03
     O                       *Date         Y     12
     O                       HHMMSS             108 '  :  :  '
     O                                          118 'Page'
     O                       Page          Z    123
     O                                           60 '  NStat Listing for'
     O                       sysnam              70
     OQsysprt   e    OF      header      1
     o                                           15 '_____________'
     o                                          +04 '______________'
     o                                          +03 '________'
     o                                          +02 '________'
     o                                          +07 '________'
     o                                          +08 '_________'
     o                                          +02 '_________'
     o                                          +01 '_______'
     o                                          +04 '______'
     o                                          +06 '____'
     OQsysprt   e    OF      header         1
     o                                           15 'Local Address'
     o                                          +04 'Remote Address'
     o                                          +03 'Lcl Port'
     o                                          +02 'Rmt Port'
     o                                          +07 'Bytes In'
     o                                          +08 'Bytes Out'
     o                                          +02 'Idle Time'
     o                                          +01 'Usr Prf'
     o                                          +04 'Status'
     o                                          +06 'Type'
     OQsysprt   EF           PrtLine        1
     O                       C1LocAdr            17
     O                       C1RmtAdr           +02
     O                       lclport       z    +03
     O                       rmtport       z    +04
     O                       ByteIn        1    +01
     O                       ByteOut       1    +02
     o*                      Idled              +02
     o*                                         +00 ':'
     o                       Idleh              +02
     o                                          +00 ':'
     o                       idlem              +00
     o                                          +00 ':'
     o                       idles              +00
     O                       C1UserPrf          +01
     O                       CnnStat            +01
     O                       C1NetCnnTyp        +01
