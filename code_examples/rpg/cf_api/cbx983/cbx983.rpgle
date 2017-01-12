     **
     **  Program . . : CBX983
     **  Description : Set User Query Attributes - CPP
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **
     **  Programmer's notes:
     **    In order to run the Change Query Attributes (CHGQRYA) command,
     **    which requires *JOBCTL special authority, this program must have
     **    a User profile (USRPRF) attribute of *OWNER and be owned by a
     **    user profile having *JOBCTL special authority, as for example
     **    QSECOFR.
     **
     **
     **  Compilation instructions:
     **    CrtRpgMod   Module( CBX983 )
     **                DbgView( *NONE )
     **
     **    CrtPgm      Pgm( CBX983 )
     **                Module( CBX983 )
     **                BndSrvPgm( CBX980 )
     **                UsrPrf( *OWNER )
     **                ActGrp( *NEW )
     **
     **    ChgObjOwn   Obj( CBX983 )
     **                ObjType( *PGM )
     **                NewOwn( QSECOFR )
     **
     **    ChgPgm      Pgm( CBX983 )
     **                RmvObs( *ALL )
     **
     **
     **-- Header specifications:  --------------------------------------------**
     H Option( *SrcStmt )
 
     **-- System information:
     D PgmSts         SDs                  Qualified
     D  PgmNam           *Proc
     D  CurJob                       10a   Overlay( PgmSts: 244 )
     D  UsrPrf                       10a   Overlay( PgmSts: 254 )
     D  JobNbr                        6a   Overlay( PgmSts: 264 )
     D  CurUsr                       10a   Overlay( PgmSts: 358 )
     **-- API error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      128a
 
     **-- Global variables:
     D QryUsr          s             10a
     D CmdStr          s           1024a   Varying
     **-- Global constants:
     D NULL            c                   ''
     D TYP_INTER       c                   'I'
     D USR_APP_NAM     c                    'CBX_QQQ_USRQRYA'
 
     **-- User query attributes application information:
     D UsrQryAtr       Ds                  Qualified
     D  FmtLen                       10i 0
     D  FmtNam                        8a
     D  Resv1                         4a
     D  QryIntLmt                    10i 0
     D  QryIntAlw                    10a
     D  QryOptLib                    10a
     D  Resv2                       216a   Inz
 
     **-- Retrieve job information:
     D RtvJobInf       Pr                  ExtPgm( 'QUSRJOBI' )
     D  RcvVar                    32767a         Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  JobNamQ                      26a   Const
     D  JobIntId                     16a   Const
     D  Error                     32767a         Options( *NoPass: *VarSize )
     **-- Process commands:
     D PrcCmds         Pr                  ExtPgm( 'QCAPCMD' )
     D  SrcCmd                    32702a   Const  Options( *VarSize )
     D  SrcCmdLen                    10i 0 Const
     D  OptCtlBlk                    20a   Const
     D  OptCtlBlkLen                 10i 0 Const
     D  OptCtlBlkFmt                  8a   Const
     D  ChgCmd                    32767a          Options( *VarSize )
     D  ChgCmdLen                    10i 0 Const
     D  ChgCmdLenAvl                 10i 0
     D  Error                     32767a          Options( *VarSize )
     **-- Send program message:
     D SndPgmMsg       Pr                  ExtPgm( 'QMHSNDPM' )
     D  MsgId                         7a   Const
     D  MsgF_q                       20a   Const
     D  MsgDta                      128a   Const
     D  MsgDtaLen                    10i 0 Const
     D  MsgTyp                       10a   Const
     D  CalStkE                      10a   Const  Options( *VarSize )
     D  CalStkCtr                    10i 0 Const
     D  MsgKey                        4a
     D  Error                     32767a          Options( *VarSize )
     **-- Retrieve user application info:
     D RtvUsrAppInf    Pr                  ExtProc( 'QsyRetrieveUser-
     D                                     ApplicationInfo' )
     D  RcvVar                    32767a   Const  Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  RtnRcdInf                    12a   Const
     D  FmtNam                        8a   Const
     D  UsrPrf                       10a   Const
     D  AppInfId                    200a   Const  Options( *VarSize )
     D  AppInfIdLen                  10i 0 Const
     D  Error                     32767a          Options( *VarSize: *NoPass)
 
     **-- Get group profile:
     D GetGrpPrf       Pr            10a
     D  PxUsrPrf                     10a   Const
     **-- Verify user query attributes:
     D VfyUsrQryA      Pr              n
     D  PxUsrPrf                     10a   Const
     **-- Get user query attributes:
     D GetUsrQryA      Pr           256a
     D  PxUsrPrf                     10a   Const
 
     **-- Get job type:
     D GetJobTyp       Pr             1a
     **-- Get query interactive time limit:
     D GetQryIntLmt    Pr            10a   Varying
     D  PxParmVal                    10i 0 Const
     **-- Process command:
     D PrcCmd          Pr            10i 0
     D  PxCmdStr                   1024a   Const  Varying
     **-- Send joblog message:
     D SndLogMsg       Pr            10i 0
     D  PxMsgDta                    512a   Const  Varying
     **-- Send completion message:
     D SndCmpMsg       Pr            10i 0
     D  PxMsgDta                    512a   Const  Varying
 
     **-- Entry parameters:
     D CBX983          Pr
     D  PxGrpOpt                     10a
     **
     D CBX983          Pi
     D  PxGrpOpt                     10a
 
      /Free
 
        QryUsr = '*NONE';
 
        Select;
        When  PxGrpOpt = '*GRPONLY';
 
          If  VfyUsrQryA( GetGrpPrf( PgmSts.CurUsr )) = *On;
            QryUsr = GetGrpPrf( PgmSts.CurUsr );
          EndIf;
 
        When  PxGrpOpt = '*NONE';
 
          If  VfyUsrQryA( PgmSts.CurUsr ) = *On;
            QryUsr = PgmSts.CurUsr;
          EndIf;
 
        When  PxGrpOpt = '*GRPDFT';
 
          Select;
          When  VfyUsrQryA( PgmSts.CurUsr ) = *On;
            QryUsr = PgmSts.CurUsr;
 
          When  VfyUsrQryA( GetGrpPrf( PgmSts.CurUsr )) = *On;
            QryUsr = GetGrpPrf( PgmSts.CurUsr );
          EndSl;
        EndSl;
 
        If  QryUsr <> '*NONE';
          UsrQryAtr = GetUsrQryA( QryUsr );
 
          CmdStr = 'CHGQRYA JOB(*) ';
 
          If  GetJobTyp() = TYP_INTER;
            CmdStr += 'QRYTIMLMT(' + GetQryIntLmt( UsrQryAtr.QryIntLmt ) + ') ';
          Else;
            CmdStr += 'QRYTIMLMT(*SAME) ';
          EndIf;
 
          CmdStr += 'DEGREE(*SAME) ';
          CmdStr += 'ASYNCJ(*SAME) ';
          CmdStr += 'APYRMT(*SAME) ';
          CmdStr += 'QRYSTGLMT(*SAME) ';
 
          CmdStr += 'QRYOPTLIB(' + %Trim( UsrQryAtr.QryOptLib ) + ')';
 
          If  PrcCmd( CmdStr ) < *Zero;
            SndLogMsg( 'User query attributes change attempt failed.' );
          Else;
            SndLogMsg( 'User query attributes changed succesfully.' );
          EndIf;
        EndIf;
 
        SndCmpMsg ( 'Set user query attributes completed for user '  +
                     %Trim( PgmSts.CurUsr )                          +
                    '.'
                  );
 
        *InLr = *On;
        Return;
 
      /End-Free
 
     **-- Get job type:
     P GetJobTyp       B
     D                 Pi             1a
 
     D JOBI0400        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  JobNam                       10a
     D  UsrNam                       10a
     D  JobNbr                        6a
     D  JobIntId                     16a
     D  JobSts                       10a
     D  JobTyp                        1a
     D  JobSubTyp                     1a
 
      /Free
 
        RtvJobInf( JOBI0400
                 : %Size( JOBI0400 )
                 : 'JOBI0400'
                 : '*'
                 : *Blank
                 : ERRC0100
                 );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  *Blank;
 
        Else;
          Return  JOBI0400.JobTyp;
        EndIf;
 
      /End-Free
 
     P GetJobTyp       E
     **-- Get query interactive time limit:
     P GetQryIntLmt    B
     D                 Pi            10a   Varying
     D  PxParmVal                    10i 0 Const
 
      /Free
 
        Select;
        When  PxParmVal = -1;
          Return  '*NOMAX';
 
        When  PxParmVal = -2;
          Return  '*SAME';
 
        When  PxParmVal = -3;
          Return  '*SAME';
 
        Other;
          Return  %Char( PxParmVal );
        EndSl;
 
      /End-Free
 
     P GetQryIntLmt    E
     **-- Process command:
     P PrcCmd          B
     D                 Pi            10i 0
     D  PxCmdStr                   1024a   Const  Varying
 
     **-- Local variables:
     D OptCtlBlk       Ds                  Qualified
     D  TypPrc                       10i 0 Inz( 0 )
     D  DBCS                          1a   Inz( '0' )
     D  PmtAct                        1a   Inz( '2' )
     D  CmdStx                        1a   Inz( '0' )
     D  MsgRtvKey                     4a   Inz( *Allx'00' )
     D  CmdCcsId                     10i 0 Inz( 0 )
     D  Rsv                           9a   Inz( *Allx'00' )
     **
     D ChgCmd          s          32767a
     D ChgCmdAvl       s             10i 0
 
      /Free
 
        PrcCmds( PxCmdStr
               : %Len( PxCmdStr )
               : OptCtlBlk
               : %Size( OptCtlBlk )
               : 'CPOP0100'
               : ChgCmd
               : %Size( ChgCmd )
               : ChgCmdAvl
               : ERRC0100
               );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  -1;
 
        Else;
          Return  *Zero;
        EndIf;
 
      /End-Free
 
     P PrcCmd          E
     **-- Send joblog message:
     P SndLogMsg       B
     D                 Pi            10i 0
     D  PxMsgDta                    512a   Const  Varying
 
     D MsgKey          s              4a
 
      /Free
 
        SndPgmMsg( *Blanks
                 : *Blanks
                 : PxMsgDta
                 : %Len( PxMsgDta )
                 : '*INFO'
                 : '*'
                 : *Zero
                 : MsgKey
                 : ERRC0100
                 );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  -1;
 
        Else;
          Return  0;
 
        EndIf;
 
      /End-Free
 
     P SndLogMsg       E
     **-- Send completion message:
     P SndCmpMsg       B
     D                 Pi            10i 0
     D  PxMsgDta                    512a   Const  Varying
     **
     D MsgKey          s              4a
 
      /Free
 
        SndPgmMsg( 'CPF9897'
                 : 'QCPFMSG   *LIBL'
                 : PxMsgDta
                 : %Len( PxMsgDta )
                 : '*COMP'
                 : '*PGMBDY'
                 : 1
                 : MsgKey
                 : ERRC0100
                 );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  -1;
 
        Else;
          Return  0;
 
        EndIf;
 
      /End-Free
 
     P SndCmpMsg       E
