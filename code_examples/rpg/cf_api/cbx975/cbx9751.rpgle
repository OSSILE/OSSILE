     **
     **  Program . . : CBX9751
     **  Description : Run Job Command - CPP
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **  Compilation specification:
     **    CrtRpgMod  Module( CBX9751 )
     **               DbgView( *NONE )
     **
     **    CrtPgm     Pgm( CBX9751 )
     **               Module( CBX9751 )
     **               ActGrp( *NEW )
     **
     **
     **
     **-- Header specifications:  --------------------------------------------**
     H Option( *SrcStmt )
 
     **-- System information:
     D PgmSts         SDs                  Qualified  NoOpt
     D  PgmNam           *Proc
     D  Status                        5a   Overlay( PgmSts: 11 )
     D  StmNbr                        8a   Overlay( PgmSts: 21 )
     D  MsgId                         7a   Overlay( PgmSts: 40 )
     D  PgmLib                       10a   Overlay( PgmSts: 81 )
     D  Msg                          80a   Overlay( PgmSts: 91 )
     D  JobId                        26a   Overlay( PgmSts: 244 )
     D  CurJob                       10a   Overlay( PgmSts: 244 )
     D  UsrPrf                       10a   Overlay( PgmSts: 254 )
     D  JobNbr                        6a   Overlay( PgmSts: 264 )
     **-- API error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                     1024a
     **-- Job interrupt response - JITR0100:
     D JITR0100        Ds                  Qualified
     D  RspLen                       10i 0
     D  RspFmt                        8a
     D  RtnCod                       10i 0
     D  MsgId                         7a
     D  MsgF_q                       20a
     D   MsgFnam                     10a   Overlay( MsgF_q )
     D                                5a
     D  MsgDta                     1024a   Varying
 
     **-- Global constants:
     D NULL            c                   ''
     D OFS_MSGDTA      c                   16
     D TMO_SEC_25      c                   25
     **-- Global variables:
     D CmdRspMsg       s           4096a   Varying
 
     **-- Program data:
     D PgmDta          Ds                  Qualified
     D  DtqNam_q                     20a
     D   DtqNam                      10a   Inz( 'CBX975Q' )
     D                                     Overlay( DtqNam_q:  1 )
     D   DtqLib                      10a   Overlay( DtqNam_q: 11 )
     D  DtqKey                       16a
     D  RpyKey                       16a
 
     **-- JITP0100 format:
     D JITP0100        Ds                  Qualified
     D  PgmNam                       10a
     D  PgmLib                       10a
     D  TgtJobNam                    10a
     D  TgtJobUsr                    10a
     D  TgtJobNbr                     6a
     D                                2a   Inz( *Allx'00' )
     D  OfsPgmDta                    10i 0 Inz( 56 )
     D  LenPgmDta                    10i 0 Inz( %Size( PgmDta ))
     D  PgmDta                     2000a
 
     **-- Retrieve object description:
     D RtvObjD         Pr                  ExtPgm( 'QUSROBJD' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  ObjNamQ                      20a   Const
     D  ObjTyp                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Send program message:
     D SndPgmMsg       Pr                  ExtPgm( 'QMHSNDPM' )
     D  MsgId                         7a   Const
     D  MsgFq                        20a   Const
     D  MsgDta                      128a   Const
     D  MsgDtaLen                    10i 0 Const
     D  MsgTyp                       10a   Const
     D  CalStkE                      10a   Const  Options( *VarSize )
     D  CalStkCtr                    10i 0 Const
     D  MsgKey                        4a
     D  Error                     32767a          Options( *VarSize )
     **-- Receive program message:
     D RcvPgmMsg       Pr                  ExtPgm( 'QMHRCVPM' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                       10a   Const
     D  CalStkE                     256a   Const  Options( *VarSize )
     D  CalStkCtr                    10i 0 Const
     D  MsgTyp                       10a   Const
     D  MsgKey                        4a   Const
     D  Wait                         10i 0 Const
     D  MsgAct                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     D  CalStkElen                   10i 0 Const  Options( *NoPass )            call stack counter
     D  CalStkEq                     20a   Const  Options( *NoPass )            call stack counter
     D  CalStkEtyp                   20a   Const  Options( *NoPass )            call stack counter
     D  CcsId                        10i 0 Const  Options( *NoPass )            call stack counter
     **-- Call job interrupt program:
     D JobItpPgm       Pr                  ExtPgm( 'QWCJBITP' )
     D  InpVar                    32767a          Options( *VarSize )
     D  FmtNam                        8a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Execute command:
     D ExcCmd          Pr                  ExtPgm( 'QCMDEXC' )
     D  CmdStr                     4096a   Const  Options( *VarSize )
     D  CmdLen                       15p 5 Const
     D  CmdIGC                        3a   Const  Options( *NoPass )
     **-- Send data queue entry:
     D SndDtaQe        Pr                  ExtPgm( 'QSNDDTAQ' )
     D  DtqNam                       10a   Const
     D  DtqLib                       10a   Const
     D  DtaLen                        5p 0 Const
     D  Dta                       32767a   Const  Options( *VarSize )
     D  KeyLen                        3p 0 Const  Options( *NoPass )
     D  Key                         256a   Const  Options( *VarSize: *NoPass )
     D  AscRqs                       10a   Const  Options( *NoPass )
     D  JrnDta                       10a   Const  Options( *NoPass )
     **-- Receive data queue entry:
     D RcvDtaQe        Pr                  ExtPgm( 'QRCVDTAQ' )
     D  DtqNam                       10a   Const
     D  DtqLib                       10a   Const
     D  DtaLen                        5p 0
     D  Dta                       32767a          Options( *VarSize )
     D  Wait                          5p 0 Const
     D  KeyOrder                      2a   Const  Options( *NoPass )
     D  KeyLen                        3p 0 Const  Options( *NoPass )
     D  Key                         256a   Const  Options( *VarSize: *NoPass )
     D  SndInLg                       3p 0 Const  Options( *NoPass)
     D  SndInfo                      44a          Options( *VarSize: *Nopass )
     D  RmvMsg                       10a   Const  Options( *Nopass )
     D  DtaRcvLen                     5p 0 Const  Options( *Nopass )
     D  Error                     32767a          Options( *VarSize: *Nopass )
     **-- Generate universal unique identifier:
     D GenUuid         Pr                  ExtProc( '_GENUUID' )
     D  UUID_template                  *   Value
 
     **-- Check object existence:
     D ChkObj          Pr              n
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const
     **-- Create commnunication data queue:
     D CrtComDtq       Pr
     D  PxDtqNam                     10a   Const  Varying  Options( *Trim )
     D  PxDtqLib                     10a   Const  Varying  Options( *Trim )
     **-- Run command:
     D RunCmd          Pr            10i 0
     D  PxCmdStr                   4096a   Const  Varying
     **-- Get universal unique identifier:
     D GetUUID         Pr            16a
     **-- Put to data queue - keyed:
     D PutDtaQk        Pr
     D  PxDtqNam                     10a   Const
     D  PxDtqLib                     10a   Const
     D  PxDtqEnt                  65535a   Const  Varying  Options( *VarSize )
     D  PxDtqKey                    256a   Const  Varying  Options( *VarSize )
     **-- Get from data queue - keyed:
     D GetDtaQk        Pr         65535a   Varying
     D  PxDtqNam                     10a   Const
     D  PxDtqLib                     10a   Const
     D  PxDtqKey                    256a   Const  Varying  Options( *VarSize )
     D  PxDtqWait                    10i 0 Const
     **-- Send completion message:
     D SndCompMsg      Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF_q                     20a   Const           Options( *Omit )
     D  PxMsgDta                   3000a   Const  Varying  Options( *Omit )
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying
     **-- Convert integer to character:
     D CvtItoC         Pr             4a
     D  PxInt                        10i 0 Const
 
     **-- Entry parameters:
     D Job_q           Ds                  Qualified
     D  JobNam                       10a
     D  JobUsr                       10a
     D  JobNbr                        6a
     **
     D CBX9751         Pr
     D  PxJob_q                            LikeDs( Job_q )
     D  PxCmdStr                   3000a   Varying
     D  PxCmdTmo                      5i 0
     **
     D CBX9751         Pi
     D  PxJob_q                            LikeDs( Job_q )
     D  PxCmdStr                   3000a   Varying
     D  PxCmdTmo                      5i 0
 
      /Free
 
        If  PxJob_q = PgmSts.JobId;
          SndEscMsg( 'CBX0001': 'CBX975M': NULL );
        EndIf;
 
        PgmDta.DtqLib = PgmSts.PgmLib;
 
        If  ChkObj( PgmDta.DtqNam_q: '*DTAQ' ) = *Off;
          CrtComDtq( PgmDta.DtqNam: PgmDta.DtqLib );
        EndIf;
 
        PgmDta.DtqKey = GetUUID();
        PgmDta.RpyKey = GetUUID();
 
        JITP0100.PgmNam = 'CBX9752';
        JITP0100.PgmLib = PgmSts.PgmLib;
        JITP0100.TgtJobNam = PxJob_q.JobNam;
        JITP0100.TgtJobUsr = PxJob_q.JobUsr;
        JITP0100.TgtJobNbr = PxJob_q.JobNbr;
        JITP0100.PgmDta = PgmDta;
 
        Monitor;
          JobItpPgm( JITP0100: 'JITP0100': ERRC0100 );
        On-Error;
          SndEscMsg( 'CPF9897': 'QCPFMSG': 'Release must be V5R4 or higher.');
        EndMon;
 
        If  ERRC0100.BytAvl > *Zero;
          ExSr  EscApiErr;
        EndIf;
 
        PutDtaQk( PgmDta.DtqNam: PgmDta.DtqLib: PxCmdStr: PgmDta.DtqKey );
 
        CmdRspMsg = GetDtaQk( PgmDta.DtqNam
                            : PgmDta.DtqLib
                            : PgmDta.RpyKey
                            : PxCmdTmo
                            );
 
        If  %Len( CmdRspMsg ) = *Zero;
          GetDtaQk( PgmDta.DtqNam: PgmDta.DtqLib: PgmDta.DtqKey: *Zero );
 
          SndEscMsg( 'CBX0103': 'CBX975M': CvtItoC( PxCmdTmo ));
        Else;
          JITR0100 = CmdRspMsg;
        EndIf;
 
        If  JITR0100.RtnCod > *Zero;
          SndEscMsg( JITR0100.MsgId: JITR0100.MsgFnam: JITR0100.MsgDta );
 
        Else;
          SndCompMsg( 'CPF9897': *Omit: 'Command ran successfully.' );
        EndIf;
 
        *InLr = *On;
        Return;
 
 
        BegSr  EscApiErr;
 
          If  ERRC0100.BytAvl < OFS_MSGDTA;
            ERRC0100.BytAvl = OFS_MSGDTA;
          EndIf;
 
          SndEscMsg( ERRC0100.MsgId
                   : 'QCPFMSG'
                   : %Subst( ERRC0100.MsgDta: 1: ERRC0100.BytAvl - OFS_MSGDTA )
                   );
        EndSr;
 
      /End-Free
 
     **-- Check object existence:
     P ChkObj          B
     D                 Pi              n
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const
     **
     D OBJD0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  ObjNam                       10a
     D  ObjLib                       10a
     D  ObjTyp                       10a
 
      /Free
 
         RtvObjD( OBJD0100
                : %Size( OBJD0100 )
                : 'OBJD0100'
                : PxObjNam_q
                : PxObjTyp
                : ERRC0100
                );
 
         If  ERRC0100.BytAvl > *Zero;
           Return  *Off;
 
         Else;
           Return  *On;
         EndIf;
 
      /End-Free
 
     P ChkObj          E
     **-- Create communication data queue:
     P CrtComDtq       B
     D                 Pi
     D  PxDtqNam                     10a   Const  Varying  Options( *Trim )
     D  PxDtqLib                     10a   Const  Varying  Options( *Trim )
 
      /Free
 
        RunCmd( 'CRTDTAQ DTAQ(' + PxDtqLib   + '/' +
                                  PxDtqNam   + ')' +
                       ' TYPE(*STD)'               +
                       ' MAXLEN(4096)'             +
                       ' FORCE(*NO)'               +
                       ' SEQ(*KEYED)'              +
                       ' KEYLEN(16)'               +
                       ' SENDERID(*NO)'            +
                       ' SIZE(*MAX2GB 256)'        +
                       ' AUTORCL(*YES)'            +
                       ' AUT(*CHANGE)'
              );
 
        Return;
 
      /End-Free
 
     P CrtComDtq       E
     **-- Run command:
     P RunCmd          B
     D                 Pi            10i 0
     D  PxCmdStr                   4096a   Const  Varying
 
     **-- Message information structure:
     D RCVM0100        Ds                  Qualified
     D  BytPrv                       10i 0
     D  BytAvl                       10i 0
     D  MsgSev                       10i 0
     D  MsgId                         7a
     D  MsgTyp                        2a
     D  MsgKey                        4a
 
      /Free
 
        Monitor;
          ExcCmd( PxCmdStr: %Len( PxCmdStr ));
 
        On-Error;
          Return -1;
        EndMon;
 
        RcvPgmMsg( RCVM0100
                 : %Size( RCVM0100 )
                 : 'RCVM0100'
                 : '*'
                 : *Zero
                 : '*LAST'
                 : *Blanks
                 : *Zero
                 : '*REMOVE'
                 : ERRC0100
                 );
 
        Return *Zero;
 
      /End-Free
 
     P RunCmd          E
     **-- Get universal unique identifier:
     P GetUUID         B                   Export
     D                 Pi            16a
 
     **-- UUID template:
     D UUID_t          Ds                  Qualified
     D  BytPrv                       10u 0 Inz( %Size( UUID_t ))
     D  BytAvl                       10u 0
     D                                8a   Inz( *Allx'00' )
     D  UUID                         16a
 
      /Free
 
        GenUuid( %Addr( UUID_t ));
 
        Return  UUID_t.UUID;
 
      /End-Free
 
     P GetUUID         E
     **-- Put to data queue - keyed:
     P PutDtaQk        B                   Export
     D                 Pi
     D  PxDtqNam                     10a   Const
     D  PxDtqLib                     10a   Const
     D  PxDtqEnt                  65535a   Const  Varying  Options( *VarSize )
     D  PxDtqKey                    256a   Const  Varying  Options( *VarSize )
 
      /Free
 
        SndDtaQe( PxDtqNam
                : PxDtqLib
                : %Len( PxDtqEnt )
                : PxDtqEnt
                : %Len( PxDtqKey )
                : PxDtqKey
                );
 
        Return;
 
      /End-Free
 
     P PutDtaQk        E
     **-- Get from data queue - keyed:
     P GetDtaQk        B                   Export
     D                 Pi         65535a   Varying
     D  PxDtqNam                     10a   Const
     D  PxDtqLib                     10a   Const
     D  PxDtqKey                    256a   Const  Varying  Options( *VarSize )
     D  PxDtqWait                    10i 0 Const
 
     D DtaLen          s              5p 0
     D DtaRcv          s          65535a
     D SndInfo         s             36a
 
      /Free
 
        RcvDtaQe( PxDtqNam
                : PxDtqLib
                : DtaLen
                : DtaRcv
                : PxDtqWait
                : 'EQ'
                : %Len( PxDtqKey )
                : PxDtqKey
                : *Zero
                : SndInfo
                : '*YES'
                : %Size( DtaRcv )
                : ERRC0100
                );
 
        Return  %Subst( DtaRcv: 1: DtaLen );
 
      /End-Free
 
     P GetDtaQk        E
     **-- Send completion message:
     P SndCompMsg      B                   Export
     D                 Pi            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF_q                     20a   Const           Options( *Omit )
     D  PxMsgDta                   3000a   Const  Varying  Options( *Omit )
     **
     D MsgKey          s              4a
     D MsgF_q          s             20a
     D MsgDta          s           3000a   Varying
 
      /Free
 
        If  %Addr( PxMsgF_q ) = *Null;
          MsgF_q = 'QCPFMSG   *LIBL';
        Else;
          MsgF_q = PxMsgF_q;
        EndIf;
 
        If  %Addr( PxMsgDta ) = *Null;
          MsgDta = NULL;
        Else;
          MsgDta = PxMsgDta;
        EndIf;
 
        SndPgmMsg( PxMsgId
                 : MsgF_q
                 : MsgDta
                 : %Len( MsgDta )
                 : '*COMP'
                 : '*PGMBDY'
                 : 1
                 : MsgKey
                 : ERRC0100
                 );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  -1;
 
        Else;
          Return   0;
        EndIf;
 
      /End-Free
 
     P SndCompMsg      E
     **-- Send escape message:
     P SndEscMsg       B
     D                 Pi            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying
     **
     D MsgKey          s              4a
 
      /Free
 
        SndPgmMsg( PxMsgId
                 : PxMsgF + '*LIBL'
                 : PxMsgDta
                 : %Len( PxMsgDta )
                 : '*ESCAPE'
                 : '*PGMBDY'
                 : 1
                 : MsgKey
                 : ERRC0100
                 );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  -1;
 
        Else;
          Return   0;
        EndIf;
 
      /End-Free
 
     P SndEscMsg       E
     **-- Convert integer to character:
     P CvtItoC         B                   Export
     D                 Pi             4a
     D  PxInt                        10i 0 Const
 
     D Char            Ds                  Qualified
     D  Int                          10i 0
      /Free
 
        Char.Int = PxInt;
 
        Return  Char;
 
      /End-Free
 
     P CvtItoC         E
