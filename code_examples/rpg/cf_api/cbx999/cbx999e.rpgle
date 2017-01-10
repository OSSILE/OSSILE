     **
     **  Program . . : CBX999E
     **  Description : Work with Remote Output Queues - UIM Exit Program
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod  Module( CBX999E )
     **               DbgView( *LIST )
     **
     **    CrtPgm     Pgm( CBX999E )
     **               Module( CBX999E )
     **               ActGrp( *CALLER )
     **
     **
     **-- Control specification:  --------------------------------------------**
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
     D  MsgDta                      512a
 
     **-- Global constants:
     D NULL            c                   ''
     D NO_ENT          c                   x'00000000'
     D OPT_PMT         c                   -10
 
     **-- UIM variables:
     D UIM             Ds                  Qualified
     D  EntHdl                        4a
     **-- UIM constants:
     D RES_OK          c                   0
     D RES_ERR         c                   1
 
     **-- UIM API return structures:
     **-- Cursor record:
     D CsrRcd          Ds                  Qualified
     D  CsrEid                        4a
     D  CsrVar                       10a
     **-- UIM List entry:
     D LstEnt          Ds                  Qualified  Inz
     D  Option                        5i 0
     D  RmtOutQue                    10a
     D  TxtDsc                       50a
     D  WtrNam                       10a
     D  UsrPrf                       10a
     D  JobNbr                        6a
     D  WtrSts                        4a
     D  MsgWaitSts                    1a
     D  StrUsrPrf                    10a
     D  WrtSts                        1a
     D  RmtSysNam                   255a
     D  RmtPrtQue                   255a
     D  DstTyp                       10i 0
     D  ManTypMod                    17a
     D  HstPrtTfr                     1a
     D  WksCusObj                    10a
     D  WksCusLib                    10a
     D  DstOpt                      128a
     D  OutQueNam                    10a
     D  OutQueLib                    10a
     D  OutQueSts                     1a
     D  OutQueWrk                    10a
     D  FrmTyp                       10a
     D  MsgOpt                       10a
     D  MsgQue_q                     20a
     D   MsgQueNam                   10a   Overlay( MsgQue_q:  1 )
     D   MsgQueLib                   10a   Overlay( MsgQue_q: 11 )
     D  MsgKey                        4a
 
     **-- UIM exit program interfaces:
     **-- Parm interface:
     D UimExit         Ds            70    Qualified
     D  StcLvl                       10i 0
     D                                8a
     D  TypCall                      10i 0
     D  AppHdl                        8a
     **-- Function key - call:
     D Type1           Ds                  Qualified
     D  StcLvl                       10i 0
     D                                8a
     D  TypCall                      10i 0
     D  AppHdl                        8a
     D  PnlNam                       10a
     D  FncKey                       10i 0
     **-- Action list option/Pull-down field choice - call (type 3/9):
     D Type3           Ds                  Qualified
     D  StcLvl                       10i 0
     D                                8a
     D  TypCall                      10i 0
     D  AppHdl                        8a
     D  PnlNam                       10a
     D  LstNam                       10a
     D  LstEntHdl                     4a
     D  OptNbr                       10i 0
     D  FncQlf                       10i 0
     D  PdwFldNam                    10a
     **-- Action list option/Pull-down field choice:
     D Type5           Ds                  Qualified
     D  StcLvl                       10i 0
     D                                8a
     D  TypCall                      10i 0
     D  AppHdl                        8a
     D  PnlNam                       10a
     D  LstNam                       10a
     D  LstEntHdl                     4a
     D  OptNbr                       10i 0
     D  FncQlf                       10i 0
     D  ActRes                       10i 0
     D  PdwFldNam                    10a
 
     **-- Get dialog variable:
     D GetDlgVar       Pr                  ExtPgm( 'QUIGETV' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a          Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Get list entry:
     D GetLstEnt       Pr                  ExtPgm( 'QUIGETLE' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a   Const  Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
     D  LstNam                       10a   Const
     D  PosOpt                        4a   Const
     D  CpyOpt                        1a   Const
     D  SltCri                       20a   Const
     D  SltHdl                        4a   Const
     D  ExtOpt                        1a   Const
     D  LstEntHdl                     4a
     D  Error                     32767a          Options( *VarSize )
     **-- Update list entry:
     D UpdLstEnt       Pr                  ExtPgm( 'QUIUPDLE' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a   Const  Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
     D  LstNam                       10a   Const
     D  Option                        4a   Const
     D  LstEntHdl                     4a
     D  Error                     32767a          Options( *VarSize )
 
     **-- Move program messages:
     D MovPgmMsgs      Pr                  ExtPgm( 'QMHMOVPM' )
     D  MsgKey                        4a   Const
     D  MsgTyps                      10a   Const  Options( *VarSize )
     D                                     Dim( 4 )
     D  NbrMsgTyps                   10i 0 Const
     D  ToCalStkE                  4102a   Const  Options( *VarSize )
     D  ToCalStkCnt                  10i 0 Const
     D  Error                     32767a          Options( *VarSize )
     **
     D  ToCalStkLen                  10i 0 Const  Options( *NoPass )
     D  ToCalStkEq                   20a   Const  Options( *NoPass )
     **
     D  ToCalStkEdt                  10a   Const  Options( *NoPass )
     D  FrCalStkEad                    *   Const  Options( *NoPass )
     D  FrCalStkCnt                  10i 0 Const  Options( *NoPass )
     **-- Resend escape messages:
     D RsnEscMsg       Pr                  ExtPgm( 'QMHRSNEM' )
     D  MsgKey                        4a   Const
     D  Error                     32767a          Options( *VarSize )
     D  ToCalStkEnt                5120a   Const  Options( *VarSize )
     D  ToCalStkEntLn                10i 0 Const
     D  ToCalStkFmt                   8a   Const
     D  FrCalStkAdr                  16a   Const
     D  FrCalStkCnt                  10i 0 Const
     **-- Process commands:
     D PrcCmds         Pr                  ExtPgm( 'QCAPCMD' )
     D  SrcCmd                    32702a   Const  Options( *VarSize )
     D  SrcCmdLen                    10i 0 Const
     D  OptCtlBlk                    20a   Const
     D  OptCtlBlkLn                  10i 0 Const
     D  OptCtlBlkFm                   8a   Const
     D  ChgCmd                    32767a          Options( *VarSize )
     D  ChgCmdLen                    10i 0 Const
     D  ChgCmdLenAv                  10i 0
     D  Error                     32767a          Options( *VarSize )
     **-- Display long text:
     D DspLngTxt       Pr                  ExtPgm( 'QUILNGTX' )
     D  LngTxt                    32767a   Const  Options( *VarSize )
     D  LngTxtLen                    10i 0 Const
     D  MsgId                         7a   Const
     D  MsgF                         20a   Const
     D  Error                     32767a   Const  Options( *VarSize )
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
     **-- Additional message information:
     D CBX209          Pr                  ExtPgm( 'CBX209' )
     D  MsqNam_q                     20a
     D  MsqKey                        4a
 
     **-- Update list entry status:
     D UpdEntSts       Pr
     D  PxEntSts                      4a   Const
     **-- Process command:
     D PrcCmd          Pr            10i 0
     D  CmdStr                     1024a   Const  Varying
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying
 
     **-- Entry parameters:
     D CBX999E         Pr
     D  PxUimExit                          LikeDs( UimExit )
     **
     D CBX999E         Pi
     D  PxUimExit                          LikeDs( UimExit )
 
      /Free
 
        Select;
        When  PxUimExit.TypCall = 1;
          Type1 = PxUimExit;
 
          If  Type1.FncKey = 22;
 
            GetDlgVar( Type1.AppHdl
                     : CsrRcd
                     : %Size( CsrRcd )
                     : 'CSRRCD'
                     : ERRC0100
                     );
 
            If  CsrRcd.CsrEid = NO_ENT     Or
              ( CsrRcd.CsrVar <> 'TXTDSC'  And
                CsrRcd.CsrVar <> 'DSTOPT'  And
                CsrRcd.CsrVar <> 'MFTPMD'  And
                CsrRcd.CsrVar <> 'WKCSOB'  And
                CsrRcd.CsrVar <> 'RMTSYS'  And
                CsrRcd.CsrVar <> 'RMTQUE' );
 
              SndEscMsg( 'CPD9820': 'QCPFMSG': NULL );
 
            Else;
              ExSr  RunCsrAct;
            EndIf;
          EndIf;
 
        When  PxUimExit.TypCall = 3;
          Type3 = PxUimExit;
 
          Select;
          When  Type3.OptNbr = 2;
            ExSr  ChkActWtr;
            ExSr  ChgWtrCmd;
 
          When  Type3.OptNbr = 3;
            ExSr  ChkActWtr;
            ExSr  HldWtrCmd;
 
          When  Type3.OptNbr = 4;
            ExSr  ChkActWtr;
            ExSr  EndWtrCmd;
 
          When  Type3.OptNbr = 5;
            ExSr  ChkActWtr;
            ExSr  WrkWtrCmd;
 
          When  Type3.OptNbr = 6;
            ExSr  ChkActWtr;
            ExSr  RlsWtrCmd;
 
          When  Type3.OptNbr = 7;
            ExSr  DspMsgInf;
 
          When  Type3.OptNbr = 8;
            ExSr  ChkActWtr;
            ExSr  WrkJobCmd;
          EndSl;
 
        When  PxUimExit.TypCall = 5;
          Type5 = PxUimExit;
 
          If  Type5.ActRes = RES_OK;
 
            Select;
            When  Type5.OptNbr = 1;
              UpdEntSts( '*STR' );
 
            When  Type5.OptNbr = 2;
              UpdEntSts( '*CHG' );
 
            When  Type5.OptNbr = 3;
              UpdEntSts( '*HLD' );
 
            When  Type5.OptNbr = 4;
              UpdEntSts( '*END' );
 
            When  Type5.OptNbr = 6;
              UpdEntSts( '*RLS' );
            EndSl;
          EndIf;
        EndSl;
 
        Return;
 
 
        BegSr  ChkActWtr;
 
          GetLstEnt( Type3.AppHdl
                   : LstEnt
                   : %Size( LstEnt )
                   : 'DTLRCD'
                   : 'DTLLST'
                   : 'HNDL'
                   : 'Y'
                   : *Blanks
                   : Type3.LstEntHdl
                   : 'N'
                   : UIM.EntHdl
                   : ERRC0100
                   );
 
          If  LstEnt.WtrNam = *Blanks;
 
            SndEscMsg( 'CPF3450'
                     : 'QCPFMSG'
                     : LstEnt.RmtOutQue + %Char( Type3.OptNbr )
                     );
          EndIf;
 
        EndSr;
 
        BegSr  ChgWtrCmd;
 
          If  Type3.FncQlf = OPT_PMT;
 
            PrcCmd( '?CHGWTR ?*WTR(' + %TrimR( LstEnt.WtrNam ) + ')' );
          Else;
 
            PrcCmd( 'CHGWTR WTR(' + %TrimR( LstEnt.WtrNam ) + ')' );
          EndIf;
 
        EndSr;
 
        BegSr  HldWtrCmd;
 
          If  Type3.FncQlf = OPT_PMT;
 
            PrcCmd( '?HLDWTR ?*WTR(' + %TrimR( LstEnt.WtrNam ) + ')' );
          Else;
 
            PrcCmd( 'HLDWTR WTR(' + %TrimR( LstEnt.WtrNam ) + ')' );
          EndIf;
 
        EndSr;
 
        BegSr  EndWtrCmd;
 
          If  Type3.FncQlf = OPT_PMT;
 
            PrcCmd( '?ENDWTR ?*WTR(' + %TrimR( LstEnt.WtrNam ) + ')' );
          Else;
 
            PrcCmd( 'ENDWTR WTR(' + %TrimR( LstEnt.WtrNam ) + ')' );
          EndIf;
 
        EndSr;
 
        BegSr  WrkWtrCmd;
 
          If  Type3.FncQlf = OPT_PMT;
 
            PrcCmd( '?WRKWTR ?*WTR(' + %TrimR( LstEnt.WtrNam ) + ')' );
          Else;
 
            PrcCmd( 'WRKWTR WTR(' + %TrimR( LstEnt.WtrNam ) + ')' );
          EndIf;
 
        EndSr;
 
        BegSr  RlsWtrCmd;
 
          If  Type3.FncQlf = OPT_PMT;
 
            PrcCmd( '?RLSWTR ?*WTR(' + %TrimR( LstEnt.WtrNam ) + ')' );
          Else;
 
            PrcCmd( 'RLSWTR WTR(' + %TrimR( LstEnt.WtrNam ) + ')' );
          EndIf;
 
        EndSr;
 
        BegSr  WrkJobCmd;
 
          If  Type3.FncQlf = OPT_PMT;
 
            PrcCmd( '?WRKJOB ?*JOB(' + %TrimR( LstEnt.JobNbr ) + '/'
                                     + %TrimR( LstEnt.UsrPrf ) + '/'
                                     + %TrimR( LstEnt.WtrNam ) + ')'
                  );
          Else;
 
            PrcCmd( 'WRKJOB JOB(' + %TrimR( LstEnt.JobNbr ) + '/'
                                  + %TrimR( LstEnt.UsrPrf ) + '/'
                                  + %TrimR( LstEnt.WtrNam ) + ')'
                  );
          EndIf;
 
        EndSr;
 
        BegSr  DspMsgInf;
 
          GetLstEnt( Type3.AppHdl
                   : LstEnt
                   : %Size( LstEnt )
                   : 'DTLRCD'
                   : 'DTLLST'
                   : 'HNDL'
                   : 'Y'
                   : *Blanks
                   : Type3.LstEntHdl
                   : 'N'
                   : UIM.EntHdl
                   : ERRC0100
                   );
 
          If  LstEnt.MsgKey = *Blanks;
 
            PrcCmd( 'DSPMSG MSGQ(' + %TrimR( LstEnt.MsgQueLib ) + '/'
                                   + %TrimR( LstEnt.MsgQueNam ) + ') '
                                   + 'OUTPUT(*) MSGTYPE(*ALL) '
                                   + 'START(*LAST) SEV(0)'
                                );
          Else;
            CBX209( LstEnt.MsgQue_q: LstEnt.MsgKey );
          EndIf;
 
        EndSr;
 
        BegSr  RunCsrAct;
 
          GetLstEnt( Type1.AppHdl
                   : LstEnt
                   : %Size( LstEnt )
                   : 'DTLRCD'
                   : 'DTLLST'
                   : 'HNDL'
                   : 'Y'
                   : *Blanks
                   : CsrRcd.CsrEid
                   : 'N'
                   : UIM.EntHdl
                   : ERRC0100
                   );
 
           If  LstEnt.ManTypMod = *BLANKS;
             LstEnt.ManTypMod = '*NONE';
           EndIf;
 
           If  LstEnt.WksCusObj = *BLANKS;
             LstEnt.WksCusObj = '*NONE';
           EndIf;
 
           Select;
           When  CsrRcd.CsrVar = 'TXTDSC';
             DspLngTxt( LstEnt.TxtDsc
                      : %Len( %TrimR( LstEnt.TxtDsc ))
                      : 'CPX843D'
                      : 'QCPFMSG   *LIBL'
                      : ERRC0100
                      );
 
           When  CsrRcd.CsrVar = 'DSTOPT';
             DspLngTxt( LstEnt.DstOpt
                      : %Len( %TrimR( LstEnt.DstOpt ))
                      : 'CPX843D'
                      : 'QCPFMSG   *LIBL'
                      : ERRC0100
                      );
 
           When  CsrRcd.CsrVar = 'MFTPMD';
             DspLngTxt( LstEnt.ManTypMod
                      : %Len( %TrimR( LstEnt.ManTypMod ))
                      : 'CPX843D'
                      : 'QCPFMSG   *LIBL'
                      : ERRC0100
                      );
 
           When  CsrRcd.CsrVar = 'WKCSOB';
             DspLngTxt( LstEnt.WksCusObj + ' ' + LstEnt.WksCusLib
                      : %Len( LstEnt.WksCusObj + ' ' + LstEnt.WksCusLib )
                      : 'CPX843D'
                      : 'QCPFMSG   *LIBL'
                      : ERRC0100
                      );
 
           When  CsrRcd.CsrVar = 'RMTSYS';
             DspLngTxt( LstEnt.RmtSysNam
                      : %Len( %TrimR( LstEnt.RmtSysNam ))
                      : 'CPX843D'
                      : 'QCPFMSG   *LIBL'
                      : ERRC0100
                      );
 
           When  CsrRcd.CsrVar = 'RMTQUE';
             DspLngTxt( LstEnt.RmtPrtQue
                      : %Len( %TrimR( LstEnt.RmtPrtQue ))
                      : 'CPX843D'
                      : 'QCPFMSG   *LIBL'
                      : ERRC0100
                      );
         EndSl;
 
        EndSr;
 
      /End-Free
 
     **-- Update list entry status:
     P UpdEntSts       B
     D                 Pi
     D  PxEntSts                      4a   Const
 
      /Free
 
        GetLstEnt( Type5.AppHdl
                 : LstEnt
                 : %Size( LstEnt )
                 : 'DTLRCD'
                 : 'DTLLST'
                 : 'HNDL'
                 : 'Y'
                 : *Blanks
                 : Type5.LstEntHdl
                 : 'N'
                 : UIM.EntHdl
                 : ERRC0100
                 );
 
        LstEnt.WtrSts = PxEntSts;
 
        UpdLstEnt( Type5.AppHdl
                 : LstEnt
                 : %Size( LstEnt )
                 : 'DTLRCD'
                 : 'DTLLST'
                 : 'SAME'
                 : UIM.EntHdl
                 : ERRC0100
                 );
 
        Return;
 
      /End-Free
 
     P UpdEntSts       E
     **-- Process command:
     P PrcCmd          B
     D                 Pi            10i 0
     D  PxCmdStr                   1024a   Const  Varying
 
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
     **-- API error data structure:
     D ERRC0100_e      Ds                  Qualified
     D  BytPro                       10i 0 Inz( 0 )
     D  BytAvl                       10i 0
     **-- Call stack entry id:
     D ToCalStkE       Ds                  Qualified
     D  ToCalStkCnt                  10i 0 Inz( 1 )
     D  ToCalStkEq                   20a   Inz( '*NONE     *NONE' )
     D  ToCalStkIdLen                10i 0 Inz( %Size( ToCalStkE.ToCalStkId ))
     D  ToCalStkId                   10a   Inz( '*PGMBDY' )
     **-- Message types:
     D TypTbl          Ds
     D  MsgTyps                      10a   Dim( 1 )
     D                               10a   Overlay( TypTbl )
     D                                     Inz( '*COMP' )
 
      /Free
 
        PrcCmds( PxCmdStr
               : %Len( PxCmdStr )
               : CPOP0100
               : %Size( CPOP0100 )
               : 'CPOP0100'
               : ChgCmd
               : %Size( ChgCmd )
               : ChgCmdAvl
               : ERRC0100_e
               );
 
        MovPgmMsgs( *Blanks
                  : MsgTyps
                  : %Elem( MsgTyps )
                  : '*CTLBDY'
                  : 1
                  : ERRC0100
                  );
 
        Return  0;
 
        BegSr  *PsSr;
 
          If  Not *InLr;
            *InLr = *On;
 
            MovPgmMsgs( *Blanks
                      : '*DIAG'
                      : 1
                      : '*CTLBDY'
                      : 1
                      : ERRC0100
                      );
 
            RsnEscMsg( *Blanks
                     : ERRC0100
                     : ToCalStkE
                     : %Size( ToCalStkE )
                     : 'RSNM0100'
                     : '*'
                     : *Zero
                     );
 
            Return -1;
          EndIf;
 
        EndSr;
 
      /End-Free
 
     P PrcCmd          E
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
