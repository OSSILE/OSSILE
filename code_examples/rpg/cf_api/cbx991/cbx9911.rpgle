     **
     **  Program . . : CBX9911
     **  Description : Add User Auditing - CPP
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod   Module( CBX9911 )
     **                DbgView( *LIST )
     **
     **    CrtPgm      Pgm( CBX9911 )
     **                Module( CBX9911 )
     **                ActGrp( *NEW )
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
 
     **-- Global constants:
     D OFS_MSGDTA      c                   16
     D ADP_PRV_INVLVL  c                   1
     D NULL            c                   ''
 
     **-- Global variables:
     D Idx             s             10i 0
     D AudCnt          s             10i 0
     D AddCnt          s             10i 0
     D AutFlg          s              1a
     D IdxNam_q        s             20a
     D SpcAutLst       s             10a   Dim( 8 )
     D CmdStr          s           4096a   Varying
     D AudStr          s           4096a   Varying
 
     **-- List API parameters:
     D LstApi          Ds                  Qualified  Inz
     D  RtnRcdNbr                    10i 0
     D  GrpNam                       10a
     D  SltCri                       10a
     **-- List information:
     D LstInf          Ds                  Qualified
     D  RcdNbrTot                    10i 0
     D  RcdNbrRtn                    10i 0
     D  Handle                        4a
     D  RcdLen                       10i 0
     D  InfSts                        1a
     D  Dts                          13a
     D  LstSts                        1a
     D                                1a
     D  InfLen                       10i 0
     D  Rcd1                         10i 0
     D                               40a
 
     **-- User information:
     D AUTU0150        Ds                  Qualified
     D  UsrPrf                       10a
     D  UsrGrpI                       1a
     D  GrpMbrI                       1a
     D  TxtDsc                       50a
     **-- User information:
     D USRI0300        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  UsrPrf                       10a
     D  UsrCls                       10a   Overlay( USRI0300:  74 )
     D  ObjAudVal                    10a   Overlay( USRI0300: 501 )
     D  UsrAudFlg                          Overlay( USRI0300: 511 )
     D                                     LikeDs( AudFlg )
     **
     D AudFlg          Ds                  Qualified
     D  Cmd                           1a
     D  Create                        1a
     D  Delete                        1a
     D  JobDta                        1a
     D  ObjMgt                        1a
     D  OfcSrv                        1a
     D  PgmAdp                        1a
     D  SavRst                        1a
     D  Security                      1a
     D  Service                       1a
     D  SplfDta                       1a
     D  SysMgt                        1a
     D  Optical                       1a
 
     **-- Open list of authorized users:
     D LstAutUsr       Pr                  ExtPgm( 'QGYOLAUS' )
     D  RcvVar                    65535a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  LstInf                       80a
     D  NbrRcdRtn                    10i 0 Const
     D  FmtNam                        8a   Const
     D  SltCri                       10a   Const
     D  GrpNam                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     D  UsrPrf                       10a   Const  Options( *NoPass )
     **-- Retrieve user information:
     D RtvUsrInf       Pr                  ExtPgm( 'QSYRUSRI' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                       10a   Const
     D  UsrPrf                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Retrieve object description:
     D RtvObjD         Pr                  ExtPgm( 'QUSROBJD' )
     D  RcvVar                    32767a         Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  ObjNamQ                      20a   Const
     D  ObjTyp                       10a   Const
     D  Error                     32767a         Options( *VarSize )
     **-- Retrieve user index entries:
     D RtvUsrIdxE      Pr                  ExtPgm( 'QUSRTVUI' )
     D  RcvVar                     2008a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  EntLoc                     2000a          Options( *VarSize )
     D  EntLocLen                    10i 0 Const
     D  EntNbrRtv                    10i 0
     D  RtnLib                       10a
     D  IdxNam_q                     20a   Const
     D  FmtNam                       10a   Const
     D  MaxEnt                       10i 0 Const
     D  SchTyp                       10i 0 Const
     D  SchCri                     2000a   Const  Options( *Varsize )
     D  SchCriLen                    10i 0 Const
     D  SchCriOfs                    10i 0 Const
     D  Error                     32767a          Options( *VarSize )
     **-- Get open list entry:
     D GetOplEnt       Pr                  ExtPgm( 'QGYGTLE' )
     D  RcvVar                    65535a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  Handle                        4a   Const
     D  LstInf                       80a
     D  NbrRcdRtn                    10i 0 Const
     D  RtnRcdNbr                    10i 0 Const
     D  Error                      1024a          Options( *VarSize )
     **-- Close list:
     D CloseLst        Pr                  ExtPgm( 'QGYCLST' )
     D  Handle                        4a   Const
     D  Error                      1024a          Options( *VarSize )
 
     **-- Check special authority
     D ChkSpcAut       Pr                  ExtPgm( 'QSYCUSRS' )
     D  AutInf                        1a
     D  UsrPrf                       10a   Const
     D  SpcAut                       10a   Const  Dim( 8 )  Options( *VarSize )
     D  NbrAut                       10i 0 Const
     D  CalLvl                       10i 0 Const
     D  Error                     32767a          Options( *VarSize )
     **-- Retrieve job information:
     D RtvJobInf       Pr                  ExtPgm( 'QUSRJOBI' )
     D  RcvVar                    32767a         Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  JobNamQ                      26a   Const
     D  JobIntId                     16a   Const
     D  Error                     32767a         Options( *NoPass: *VarSize )
     **-- Convert date & time:
     D CvtDtf          Pr                  ExtPgm( 'QWCCVTDT' )
     D  InpFmt                       10a   Const
     D  InpVar                       17a   Const  Options( *VarSize )
     D  OutFmt                       10a   Const
     D  OutVar                       17a          Options( *VarSize )
     D  Error                     32767a          Options( *VarSize )
 
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
     D  MsgFq                        20a   Const
     D  MsgDta                      128a   Const
     D  MsgDtaLen                    10i 0 Const
     D  MsgTyp                       10a   Const
     D  CalStkE                      10a   Const  Options( *VarSize )
     D  CalStkCtr                    10i 0 Const
     D  MsgKey                        4a
     D  Error                     32767a          Options( *VarSize )
     **-- Move program messages:
     D MovPgmMsg       Pr                  ExtPgm( 'QMHMOVPM' )
     D  MsgKey                        4a   Const
     D  MsgTyps                      10a   Const  Options( *VarSize )  Dim( 4 )
     D  NbrMsgTyps                   10i 0 Const
     D  ToCalStkE                  4102a   Const  Options( *VarSize )
     D  ToCalStkCnt                  10i 0 Const
     D  Error                     32767a          Options( *VarSize )
     D  ToCalStkLen                  10i 0 Const  Options( *NoPass )
     D  ToCalStkEq                   20a   Const  Options( *NoPass )
     D  ToCalStkEdt                  10a   Const  Options( *NoPass )
     D  FrCalStkEad                    *   Const  Options( *NoPass )
     D  FrCalStkCnt                  10i 0 Const  Options( *NoPass )
 
     **-- Get user audit level values:
     D GetAudLvl       Pr           300a   Varying
     D  PxAudFlg                           LikeDs( AudFlg )
     **-- Process command:
     D PrcCmd          Pr            10i 0
     D  PxCmdStr                   4096a   Const  Varying
     **-- Send status message:
     D SndStsMsg       Pr            10i 0
     D  PxMsgDta                   1024a   Const  Varying
     **-- Send completion message:
     D SndCmpMsg       Pr            10i 0
     D  PxMsgDta                    512a   Const  Varying
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying
 
     **-- Entry parameters:
     D AudLvl          Ds                  Qualified
     D  NbrVal                        5i 0
     D  AudVal                       10a   Varying  Dim( 13 )
     **
     D CBX9911         Pr
     D  PxUsrPrf                     10a
     D  PxUsrCls                     10a
     D  PxObjAud                     10a   Varying
     D  PxAudLvl                           LikeDs( AudLvl )
     D  PxRplAud                     10a
     **
     D CBX9911         Pi
     D  PxUsrPrf                     10a
     D  PxUsrCls                     10a
     D  PxObjAud                     10a   Varying
     D  PxAudLvl                           LikeDs( AudLvl )
     D  PxRplAud                     10a
 
      /Free
 
        *InLr = *On;
 
        SpcAutLst( 1 ) = '*AUDIT';
 
        ChkSpcAut( AutFlg
                 : PgmSts.UsrPrf
                 : SpcAutLst
                 : 1
                 : ADP_PRV_INVLVL
                 : ERRC0100
                 );
 
        If  ERRC0100.BytAvl > *Zero  Or AutFlg = 'N';
          SndEscMsg( 'CPFB304': 'QCPFMSG': NULL );
        EndIf;
 
        If  PxObjAud <> '*SAME'  Or  PxAudLvl.AudVal(1) <> '*SAME';
          ExSr  RunAddRqs;
        EndIf;
 
        Return;
 
 
        BegSr  RunAddRqs;
 
          SndStsMsg( 'Processing user profiles, please wait...' );
 
          LstApi.RtnRcdNbr = 1;
          LstApi.SltCri = '*ALL';
          LstApi.GrpNam = '*NONE';
 
          LstAutUsr( AUTU0150
                   : %Size( AUTU0150 )
                   : LstInf
                   : 1
                   : 'AUTU0150'
                   : LstApi.SltCri
                   : LstApi.GrpNam
                   : ERRC0100
                   : PxUsrPrf
                   );
 
          If  ERRC0100.BytAvl > *Zero;
            ExSr  EscApiErr;
          EndIf;
 
          DoW  LstInf.LstSts <> '2'  Or  LstInf.RcdNbrTot >= LstApi.RtnRcdNbr;
 
            ExSr  PrcLstEnt;
 
            LstApi.RtnRcdNbr = LstApi.RtnRcdNbr + 1;
 
            GetOplEnt( AUTU0150
                     : %Size( AUTU0150 )
                     : LstInf.Handle
                     : LstInf
                     : 1
                     : LstApi.RtnRcdNbr
                     : ERRC0100
                     );
 
            If  ERRC0100.BytAvl > *Zero;
              Leave;
            EndIf;
          EndDo;
 
          CloseLst( LstInf.Handle: ERRC0100 );
 
          SndCmpMsg( 'Processing completed. ' +
                      %Char( AddCnt )         +
                     ' user profile(s) changed.'
                   );
 
        EndSr;
 
        BegSr  PrcLstEnt;
 
          RtvUsrInf( USRI0300
                   : %Size( USRI0300 )
                   : 'USRI0300'
                   : AUTU0150.UsrPrf
                   : ERRC0100
                   );
 
          If  ERRC0100.BytAvl = *Zero;
 
            If  PxUsrCls = '*ANY'  Or  PxUsrCls = USRI0300.UsrCls;
 
              AudCnt = *Zero;
 
              If  PxObjAud <> '*SAME'  And  PxObjAud <> USRI0300.ObjAudVal;
                AudCnt += 1;
              EndIf;
 
              If  PxAudLvl.AudVal(1) = '*SAME';
                AudStr = '*SAME';
 
              Else;
                If  PxRplAud = '*NO';
                  AudStr = GetAudLvl( USRI0300.UsrAudFlg );
                EndIf;
 
                For  Idx = 1  To  PxAudLvl.NbrVal;
 
                  If  %Scan( PxAudLvl.AudVal(Idx): AudStr ) = *Zero;
                    AudCnt += 1;
 
                    AudStr += PxAudLvl.AudVal(Idx) + ' ';
                  EndIf;
                EndFor;
              EndIf;
 
              If  AudCnt > *Zero;
                AddCnt += 1;
 
                CmdStr  = 'CHGUSRAUD USRPRF('                         +
                                     %Trim( AUTU0150.UsrPrf ) + ') '  +
                                    'OBJAUD(' + PxObjAud      + ') '  +
                                    'AUDLVL(' + AudStr        + ')';
 
                PrcCmd( CmdStr );
              EndIf;
            EndIf;
          EndIf;
 
        EndSr;
 
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
 
     **-- Get user audit level values:
     P GetAudLvl       B
     D                 Pi           300a   Varying
     D  PxAudFlg                           LikeDs( AudFlg )
 
     **-- Local variables
     D RtnAudVal       s            300a   Varying  Inz( NULL )
 
      /Free
 
        If  %Scan( 'Y': PxAudFlg ) > *Zero;
 
          If  PxAudFlg.Cmd    = 'Y';
            RtnAudVal += '*CMD' + ' ';
          EndIf;
 
          If  PxAudFlg.Create = 'Y';
            RtnAudVal += '*CREATE' + ' ';
          EndIf;
 
          If  PxAudFlg.Delete   = 'Y';
            RtnAudVal += '*DELETE' + ' ';
          EndIf;
 
          If  PxAudFlg.JobDta   = 'Y';
            RtnAudVal += '*JOBDTA' + ' ';
          EndIf;
 
          If  PxAudFlg.ObjMgt   = 'Y';
            RtnAudVal += '*OBJMGT' + ' ';
          EndIf;
 
          If  PxAudFlg.OfcSrv   = 'Y';
            RtnAudVal += '*OFCSRV' + ' ';
          EndIf;
 
          If  PxAudFlg.Optical  = 'Y';
            RtnAudVal += '*OPTICAL' + ' ';
          EndIf;
 
          If  PxAudFlg.PgmAdp   = 'Y';
            RtnAudVal += '*PGMADP' + ' ';
          EndIf;
 
          If  PxAudFlg.SavRst   = 'Y';
            RtnAudVal += '*SAVRST' + ' ';
          EndIf;
 
          If  PxAudFlg.Security = 'Y';
            RtnAudVal += '*SECURITY' + ' ';
          EndIf;
 
          If  PxAudFlg.Service  = 'Y';
            RtnAudVal += '*SERVICE' + ' ';
          EndIf;
 
          If  PxAudFlg.SplfDta  = 'Y';
            RtnAudVal += '*SPLFDTA' + ' ';
          EndIf;
 
          If  PxAudFlg.SysMgt   = 'Y';
            RtnAudVal += '*SYSMGT' + ' ';
          EndIf;
        EndIf;
 
        Return  RtnAudVal;
 
      /End-Free
 
     P GetAudLvl       E
     **-- Process command:
     P PrcCmd          B                   Export
     D                 Pi            10i 0
     D  PxCmdStr                   4096a   Const  Varying
 
     **-- Option control block:
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
     **-- API error data structure:
     D ERRC0100_I      Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
 
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
          MovPgmMsg( *Blanks
                   : '*DIAG'
                   : 1
                   : '*PGMBDY'
                   : 1
                   : ERRC0100_I
                   );
 
          If  ERRC0100.BytAvl < OFS_MSGDTA;
            ERRC0100.BytAvl = OFS_MSGDTA;
          EndIf;
 
          SndEscMsg( ERRC0100.MsgId
                   : 'QCPFMSG'
                   : %Subst( ERRC0100.MsgDta: 1: ERRC0100.BytAvl - OFS_MSGDTA )
                   );
 
          Return  -1;
 
        Else;
          MovPgmMsg( *Blanks
                   : '*COMP'
                   : 1
                   : '*PGMBDY'
                   : 1
                   : ERRC0100
                   );
 
          Return  *Zero;
        EndIf;
 
      /End-Free
 
     P PrcCmd          E
     **-- Send status message:
     P SndStsMsg       B
     D                 Pi            10i 0
     D  PxMsgDta                   1024a   Const  Varying
     **
     D MsgKey          s              4a
 
      /Free
 
        SndPgmMsg( 'CPF9897'
                 : 'QCPFMSG   *LIBL'
                 : PxMsgDta
                 : %Len( PxMsgDta )
                 : '*STATUS'
                 : '*EXT'
                 : 0
                 : MsgKey
                 : ERRC0100
                 );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  -1;
 
        Else;
          Return  0;
        EndIf;
 
      /End-Free
 
     P SndStsMsg       E
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
          Return  0;
        EndIf;
 
      /End-Free
 
     P SndEscMsg       E
