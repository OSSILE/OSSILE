     **
     **  Program . . : CBX9752
     **  Description : Run Job Command - Exit Program
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **  Program description:
     **    This program will run the command received from a data queue and
     **    pass back a response indicating success or failure of the command.
     **
     **
     **  Prerequisite:
     **    This program must be registered with the QIBM_QWC_JOBITPPGM exit
     **    point, in order for the Call Job Interrupt Program (QWCJBITP) API
     **    to be enabled to specify this program as the job interrupt exit
     **    program:
     **
     **      AddExitPgm  ExitPnt( QIBM_QWC_JOBITPPGM )
     **                  Format( JITP0100 )
     **                  PgmNbr( *LOW )
     **                  Pgm( <library>/CBX9752 )
     **                  Text( 'Job interrupt exit program' )
     **
     **    The Job Interrupt Exit Program is documented here:
     **      http://publib.boulder.ibm.com/infocenter/iseries/v5r4/topic/apis/
     **        xwcjbitp.htm
     **
     **
     **    To allow the registered exit program to interrupt a specified
     **    job, the system value QALWJOBITP must be set appropriately,
     **    which must be one of the following two values:
     **
     **      1. ChgSysVal   SysVal( QALWJOBITP )
     **                     Value( '1' )
     **
     **      Running the above command will cause the system to allow
     **      jobs to be interrupted to run user-defined exit programs.
     **
     **      All new jobs becoming active will default to be uninterruptible
     **      and must have their interrupt status explicitly changed before
     **      job interruption will be allowed.
     **
     **      2. ChgSysVal   SysVal( QALWJOBITP )
     **                     Value( '2' )
     **
     **      Running the above command will cause the system to allow
     **      jobs to be interrupted to run user-defined exit programs.
     **
     **      All new jobs becoming active will default to be interruptible
     **      and will implicitly allow job interruption to take place,
     **      without any further action being required.
     **
     **    Leaving the QALWJOBITP system value at it's default value '0'
     **    will cause the system to disallow all attempts to run any
     **    registered job interrupt exit programs.
     **
     **    The QALWJOBITP system value is documented here:
     **      http://publib.boulder.ibm.com/infocenter/iseries/v5r4/topic/rzakz/
     **        rzakzqalwjobitp.htm
     **
     **
     **  Compilation specification:
     **    CrtRpgMod  Module( CBX9752 )
     **               DbgView( *NONE )
     **
     **    CrtPgm     Pgm( CBX9752 )
     **               Module( CBX9752 )
     **               ActGrp( *NEW )
     **
     **
     **-- Control specification:  --------------------------------------------**
     H Option( *SrcStmt )
 
     **-- API error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                     1024a
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
     D  JobId2                       16a   Overlay( PgmSts: 254 )
     D  UsrPrf                       10a   Overlay( PgmSts: 254 )
     D  JobNbr                        6a   Overlay( PgmSts: 264 )
 
     **-- Global constants:
     D TMO_SEC_25      c                   25
     D APP_MSGF        c                   'CBX975M   *LIBL'
     D NULL            c                   ''
     **
     D RC_OK           c                   0
     D RC_ERROR        c                   1
     D RC_WARNING      c                   2
     **-- Global variables:
     D CmdStr          s           3000a   Varying
 
     **-- Exit program data:
     D PgmDta          Ds                  Qualified
     D  DtqNam_q                     20a
     D   DtqNam                      10a   Overlay( DtqNam_q:  1 )
     D   DtqLib                      10a   Overlay( DtqNam_q: 11 )
     D  DtqKey                       16a
     D  RpyKey                       16a
     **-- Job interrupt response - JITR0100:
     D JITR0100        Ds                  Qualified
     D  RspLen                       10i 0 Inz( %Size( JITR0100 ))
     D  RspFmt                        8a   Inz( 'JITR0100' )
     D  RtnCod                       10i 0
     D  MsgId                         7a
     D  MsgF_q                       20a
     D                                5a   Inz( *Allx'00' )
     D  MsgDta                     1024a   Varying
 
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
     **-- Execute command:
     D ExcCmd          Pr                  ExtPgm( 'QCMDEXC' )
     D  CmdStr                      256a   Const  Options( *VarSize )
     D  CmdLen                       15p 5 Const
     D  CmdIGC                        3a   Const  Options( *NoPass )
     **-- Process commands:
     D PrcCmds         Pr                  ExtPgm( 'QCAPCMD' )
     D  SrcCmd                    32702a   Const  Options( *VarSize )
     D  SrcCmdLen                    10i 0 Const
     D  OptCtlBlk                    20a   Const
     D  OptCtlBlkLn                  10i 0 Const
     D  OptCtlBlkFm                   8a   Const
     D  ChgCmd                    32767a          Options( *VarSize )
     D  ChgCmdLen                    10i 0 Const
     D  ChgCmdLenAvl                 10i 0
     D  Error                     32767a          Options( *VarSize )
 
     **-- Get from data queue - keyed:
     D GetDtaQk        Pr         65535a   Varying
     D  PxDtqNam                     10a   Const
     D  PxDtqLib                     10a   Const
     D  PxDtqKey                    256a   Const  Varying  Options( *VarSize )
     D  PxDtqWait                    10i 0 Const
     **-- Put to data queue - keyed:
     D PutDtaQk        Pr
     D  PxDtqNam                     10a   Const
     D  PxDtqLib                     10a   Const
     D  PxDtqEnt                  65535a   Const  Varying  Options( *VarSize )
     D  PxDtqKey                    256a   Const  Varying  Options( *VarSize )
     **-- Process command:
     D PrcCmd          Pr             7a
     D  PxCmdStr                   4096a   Const  Varying
     D  PxMsgDta                   1024a          Varying  Options( *NoPass )
 
     **-- Entry parameters:
     D CBX9752         Pr
     D  PxPgmDta                           LikeDs( PgmDta )
     D  PxPgmDtaLen                   5i 0
     **
     D CBX9752         Pi
     D  PxPgmDta                           LikeDs( PgmDta )
     D  PxPgmDtaLen                   5i 0
 
      /Free
 
        CmdStr = GetDtaQk( PxPgmDta.DtqNam
                         : PxPgmDta.DtqLib
                         : PxPgmDta.DtqKey
                         : TMO_SEC_25
                         );
 
        If  %Len( CmdStr ) = *Zero;
          JITR0100.RtnCod = RC_WARNING;
          JITR0100.MsgId  = 'CBX0101';
          JITR0100.MsgF_q = APP_MSGF;
          JITR0100.MsgDta = NULL;
 
        Else;
          CallP(e)  ExcCmd( CmdStr: %Len( CmdStr ));
 
          If  %Error;
            JITR0100.RtnCod = RC_ERROR;
            JITR0100.MsgId  = 'CBX0102';
            JITR0100.MsgF_q = APP_MSGF;
            JITR0100.MsgDta = PgmSts.JobId;
          Else;
            JITR0100.RtnCod = RC_OK;
            JITR0100.MsgId  = *Blanks;
            JITR0100.MsgF_q = *Blanks;
            JITR0100.MsgDta = NULL;
          EndIf;
        EndIf;
 
        PutDtaQk( PxPgmDta.DtqNam
                : PxPgmDta.DtqLib
                : JITR0100
                : PxPgmDta.RpyKey
                );
 
        *InLr = *On;
        Return;
 
 
      /End-Free
 
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
     **-- Process command:
     P PrcCmd          B                   Export
     D                 Pi             7a
     D  PxCmdStr                   4096a   Const  Varying
     D  PxMsgDta                   1024a          Varying  Options( *NoPass )
 
     **-- Local variables:
     D CPOP0100        Ds                  Qualified
     D  TypPrc                       10i 0 Inz( 2 )
     D  DBCS                          1a   Inz( '0' )
     D  PmtAct                        1a   Inz( '2' )
     D  CmdStx                        1a   Inz( '0' )
     D  MsgRtvKey                     4a   Inz( *Allx'00' )
     D  Rsv                           9a   Inz( *Allx'00' )
     **
     D ChgCmd          s          32767a
     D ChgCmdAvl       s             10i 0
     **-- Local constants:
     D OFS_MSGDTA      c                   16
     D NULL            c                   ''
 
      /Free
 
        PrcCmds( PxCmdStr
               : %Len( PxCmdStr )
               : CPOP0100
               : %Size( CPOP0100 )
               : 'CPOP0100'
               : ChgCmd
               : %Size( ChgCmd )
               : ChgCmdAvl
               : ERRC0100
               );
 
        If  ERRC0100.BytAvl > *Zero;
 
          If  %Parms > 1;
            PxMsgDta = NULL;
 
            If  ERRC0100.BytAvl >= OFS_MSGDTA;
              PxMsgDta = %Subst( ERRC0100.MsgDta
                               : 1
                               : ERRC0100.BytAvl - OFS_MSGDTA
                               );
            EndIf;
          EndIf;
 
          Return  ERRC0100.MsgId;
 
        Else;
          Return  *Blanks;
        EndIf;
 
      /End-Free
 
     P PrcCmd          E
