     **
     **  Program . . : CBX9721
     **  Description : Work with Profile Security Attributes - CPP 1
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod   Module( CBX9721 )
     **                DbgView( *LIST )
     **
     **    CrtPgm      Pgm( CBX9721 )
     **                Module( CBX9721 )
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
     D TYP_INTER       c                   'I'
     D APP_MSGF        c                   'CBX972M   *LIBL'
     D ADP_PRV_INVLVL  c                   1
     D NULL            c                   ''
     **-- UIM constants:
     D PNLGRP_Q        c                   'CBX972P   *LIBL     '
     D PNLGRP          c                   'CBX972P   '
     D SCP_AUT_RCL     c                   -1
     D RDS_OPT_INZ     c                   'N'
     D NO_TASK_BDY     c                   'O'
     D CALLSTK_SAME    c                   0
     D MSGQ_CALLER     c                   '*CALLER'
     D PRM_IFC_0       c                   0
     D CLO_NORM        c                   'M'
     D FNC_EXIT        c                   -4
     D FNC_CNL         c                   -8
     D KEY_F05         c                   5
     D KEY_F17         c                   17
     D KEY_F18         c                   18
     D RTN_ENTER       c                   500
     D HLP_WDW         c                   'N'
     D POS_TOP         c                   'TOP'
     D POS_BOT         c                   'BOT'
     D LIST_COMP       c                   'ALL'
     D LIST_SAME       c                   'SAME'
     D EXIT_SAME       c                   '*SAME'
     D TRIM_SAME       c                   'S'
     **
     D APP_PRTF        c                   'QPRINT    *LIBL'
     D ODP_SHR         c                   'N'
     D SPLF_NAM        c                   'PPRFSECA'
     D SPLF_USRDTA     c                   'WRKPRFSECA'
     D EJECT_NO        c                   'N'
 
     **-- Global variables:
     D Idx             s             10i 0
     D SysDts          s               z
     D WrkUsr          s             10a
     D AutFlg          s              1a
     D IdxNam_q        s             20a
     D SpcAutLst       s             10a   Dim( 8 )
     D UimMsgKey       s              4a
     **
     D SysVal          Ds                  Qualified
     D  MaxSign                       6s 0
 
     **-- Special authorities:
     D SpcAut          Ds            15
     D  AllObj                        1a   Overlay( SpcAut: 1 )
     D  SecAdm                        1a   Overlay( SpcAut: *Next )
     D  JobCtl                        1a   Overlay( SpcAut: *Next )
     D  SplCtl                        1a   Overlay( SpcAut: *Next )
     D  SavSys                        1a   Overlay( SpcAut: *Next )
     D  Service                       1a   Overlay( SpcAut: *Next )
     D  Audit                         1a   Overlay( SpcAut: *Next )
     D  IoSysCfg                      1a   Overlay( SpcAut: *Next )
 
     **-- UIM variables:
     D UIM             Ds                  Qualified
     D  AppHdl                        8a
     D  LstHdl                        4a
     D  EntHdl                        4a
     D  FncRqs                       10i 0
     D  EntLocOpt                     4a
     D  LstPos                        4a
     **-- List attributes structure:
     D LstAtr          Ds                  Qualified
     D  LstCon                        4a
     D  ExtPgmVar                    10a
     D  DspPos                        4a
     D  AlwTrim                       1a
 
     **-- UIM Message data:
     D MsgDta          Ds                  Qualified
     D  NbrRcd                       10i 0
     **-- UIM Panel exit prgram record:
     D ExpRcd          Ds                  Qualified
     D  ExitPg                       20a   Inz( 'CBX972E   *LIBL' )
     **-- UIM Panel header record:
     D HdrRcd          Ds                  Qualified
     D  SysDat                        7a
     D  SysTim                        6a
     D  TimZon                       10a
     D  WrkUsr                       10a
     D  PosUsr                       10a
     **-- UIM List entry:
     D LstEnt          Ds                  Qualified
     D  Option                        5i 0
     D  UsrPrf                       10a
     D  PrfSts                       10a
     D  UsrCls                       10a
     D  InvSgo                        7s 0
     D  PrvSgoDat                     7a
     D  PrvSgoTim                     6a
     D  PwdTyp                        1a
     D  PwdExpI                       1a
     D  PwdExpItv                     5i 0
     D  PwdChgDat                     7a
     D  LmtCap                       10a
     D  NbrSpcAut                     5i 0
     D  SpcAut                       15a
     D  GrpPrf                       10a
     D  SupGrp                             LikeDs( SupGrp_t )
     D  ObjAudVal                    10a
     D  NbrUsrAud                     5i 0
     D  UsrAudVal                    25a
     D  DigCerI                       1a
     D  LocPwdMgt                     1a
     D  TxtDsc                       50a
     D  PubAut                       10a
     D  CrtUsr                       10a
     D  ObjOwn                       10a
     D  SignOn                        1a
     D  LstUsdDat                     7a
     D  JrnDat                        8a
     D  JrnTim                        8a
     **
     D LstEntPos       Ds                  LikeDs( LstEnt )
 
     **-- List API parameters:
     D LstApi          Ds                  Qualified  Inz
     D  RtnRcdNbr                    10i 0
     D  GrpNam                       10a
     D  SltCri                       10a
     **-- Return records feedback information:
     D RtnRcdFbi       Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  NbrSvrAutE                   10i 0
     **-- List information:
     D LstInf          Ds                  Qualified
     D  RcdNbrTot                    10i 0
     D  RcdNbrTotC                    4a   Overlay( RcdNbrTot )
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
     D USRI0300        Ds         10240    Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  UsrPrf                       10a
     D  PrvSgoDts                    13a   Overlay( USRI0300:  19 )
     D   PrvSgoDat                    7a   Overlay( USRI0300:  19 )
     D   PrvSgoTim                    6a   Overlay( USRI0300:  26 )
     D  InvSgo                       10i 0 Overlay( USRI0300:  33 )
     D  PrfSts                       10a   Overlay( USRI0300:  37 )
     D  PwdChgDat                     8a   Overlay( USRI0300:  47 )
     D  NoPwdI                        1a   Overlay( USRI0300:  55 )
     D  PwdExpItv                    10i 0 Overlay( USRI0300:  57 )
     D  PwdExpDat                     8a   Overlay( USRI0300:  61 )
     D  PwdExpI                       1a   Overlay( USRI0300:  73 )
     D  UsrCls                       10a   Overlay( USRI0300:  74 )
     D  SpcAut                       15a   Overlay( USRI0300:  84 )
     D  GrpPrf                       10a   Overlay( USRI0300:  99 )
     D  Owner                        10a   Overlay( USRI0300: 109 )
     D  GrpAut                       10a   Overlay( USRI0300: 119 )
     D  InlMnu                       10a   Overlay( USRI0300: 149 )
     D  InlPgm                       10a   Overlay( USRI0300: 169 )
     D  LmtCap                       10a   Overlay( USRI0300: 189 )
     D  TxtDsc                       50a   Overlay( USRI0300: 199 )
     D  ObjAudVal                    10a   Overlay( USRI0300: 501 )
     D  UsrAudVal                    64a   Overlay( USRI0300: 511 )
     D  GrpAutTyp                    10a   Overlay( USRI0300: 575 )
     D  OfsSupGrp                    10i 0 Overlay( USRI0300: 585 )
     D  NbrSupGrp                    10i 0 Overlay( USRI0300: 589 )
     D  GrpMbrI                       1a   Overlay( USRI0300: 633 )
     D  DigCerI                       1a   Overlay( USRI0300: 634 )
     D  LocPwdMgt                     1a   Overlay( USRI0300: 661 )
     **-- Object authority information:
     D USRA0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  ObjAut                       10a
     D  AutLstMgt                     1a
     D  ObjOpr                        1a
     D  ObjMgt                        1a
     D  ObjExs                        1a
     D  DtaRead                       1a
     D  DtaAdd                        1a
     D  DtaUpd                        1a
     D  DtaDlt                        1a
     D  AutLst                       10a
     D  AutSrc                        2a
     D  AdpAut                        1a
     D  AdpObjAut                    10a
     D  AdpAutLstMgt                  1a
     D  AdpObjOpr                     1a
     D  AdpObjMgt                     1a
     D  AdpObjExs                     1a
     D  AdpDtaRead                    1a
     D  AdpDtaAdd                     1a
     D  AdpDtaUpd                     1a
     D  AdpDtaDlt                     1a
     D  AdpDtaExe                     1a
     D                               10a
     D  AdpObjAlt                     1a
     D  AdpObjRef                     1a
     D                               10a
     D  DtaExe                        1a
     D                               10a
     D  ObjAlt                        1a
     D  ObjRef                        1a
     D  AspDevLib                    10a
     D  AspDevObj                    10a
 
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
     **-- Retrieve user authority to object:
     D RtvUsrAut       Pr                  ExtPgm( 'QSYRUSRA' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  UsrPrf                       10a   Const
     D  ObjNamQ                      20a   Const
     D  ObjTyp                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     D  AspDev                       10a          Options( *NoPass )
     **-- Retrieve system value:
     D RtvSysVal       Pr                  ExtPgm( 'QWCRSVAL' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  NbrSysVal                    10i 0 Const
     D  SysVal                       10a   Const  Dim( 256 )
     D                                            Options( *VarSize )
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
     **--
     D CBX9722         Pr                  ExtPgm( 'CBX9722' )
     D  IdxNam_q                     20a
 
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
 
     **-- Open display application:
     D OpnDspApp       Pr                  ExtPgm( 'QUIOPNDA' )
     D  AppHdl                        8a
     D  PnlGrp_q                     20a   Const
     D  AppScp                       10i 0 Const
     D  ExtPrmIfc                    10i 0 Const
     D  FulScrHlp                     1a   Const
     D  Error                     32767a          Options( *VarSize )
     D  OpnDtaRcv                   128a          Options( *NoPass: *VarSize )
     D  OpnDtaRcvLen                 10i 0 Const  Options( *NoPass )
     D  OpnDtaRcvAvl                 10i 0        Options( *NoPass )
     **-- Add print application:
     D AddPrtApp       Pr                  ExtPgm( 'QUIADDPA' )
     D  AppHdl                        8a   Const
     D  PrtDevF_q                    20a   Const
     D  AltFilNam                    10a   Const
     D  ShrOpnDtaPth                  1a   Const
     D  UsrDta                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     D  OpnDtaRcv                   128a          Options( *NoPass: *VarSize )
     D  OpnDtaRcvLen                 10i 0 Const  Options( *NoPass )
     D  OpnDtaRcvAvl                 10i 0        Options( *NoPass )
     **-- Open print application:
     D OpnPrtApp       Pr                  ExtPgm( 'QUIOPNPA' )
     D  AppHdl                        8a
     D  PnlGrp_q                     20a   Const
     D  AppScp                       10i 0 Const
     D  ExtPrmIfc                    10i 0 Const
     D  PrtDevF_q                    20a   Const
     D  AltFilNam                    10a   Const
     D  ShrOpnDtaPth                  1a   Const
     D  UsrDta                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     D  OpnDtaRcv                   128a          Options( *NoPass: *VarSize )
     D  OpnDtaRcvLen                 10i 0 Const  Options( *NoPass )
     D  OpnDtaRcvAvl                 10i 0        Options( *NoPass )
     **-- Display panel:
     D DspPnl          Pr                  ExtPgm( 'QUIDSPP' )
     D  AppHdl                        8a   Const
     D  FncRqs                       10i 0
     D  PnlNam                       10a   Const
     D  ReDspOpt                      1a   Const
     D  Error                     32767a          Options( *VarSize )
     D  UsrTsk                        1a   Const  Options( *NoPass )
     D  CalStkCnt                    10i 0 Const  Options( *NoPass )
     D  CalMsgQue                   256a   Const  Options( *NoPass: *VarSize )
     D  MsgKey                        4a   Const  Options( *NoPass )
     D  CsrPosOpt                     1a   Const  Options( *NoPass )
     D  FinLstEnt                     4a   Const  Options( *NoPass )
     D  ErrLstEnt                     4a   Const  Options( *NoPass )
     D  WaitTim                      10i 0 Const  Options( *NoPass )
     D  CalMsgQueLen                 10i 0 Const  Options( *NoPass )
     D  CalQlf                       20a   Const  Options( *NoPass )
     **-- Print panel:
     D PrtPnl          Pr                  ExtPgm( 'QUIPRTP' )
     D  AppHdl                        8a   Const
     D  PrtPnlNam                    10a   Const
     D  EjtOpt                        1a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Put dialog variable:
     D PutDlgVar       Pr                  ExtPgm( 'QUIPUTV' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a   Const  Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Get dialog variable:
     D GetDlgVar       Pr                  ExtPgm( 'QUIGETV' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a          Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Add list entry:
     D AddLstEnt       Pr                  ExtPgm( 'QUIADDLE' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a   Const  Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
     D  LstNam                       10a   Const
     D  EntLocOpt                     4a   Const
     D  LstEntHdl                     4a
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
     **-- Retrieve list attributes:
     D RtvLstAtr       Pr                  ExtPgm( 'QUIRTVLA' )
     D  AppHdl                        8a   Const
     D  LstNam                       10a   Const
     D  AtrRcv                    32767a          Options( *VarSize )
     D  AtrRcvLen                    10i 0 Const
     D  Error                     32767a          Options( *VarSize )
     **-- Set list attributes:
     D SetLstAtr       Pr                  ExtPgm( 'QUISETLA' )
     D  AppHdl                        8a   Const
     D  LstNam                       10a   Const
     D  LstCon                        4a   Const
     D  ExtPgmVar                    10a   Const
     D  DspPos                        4a   Const
     D  AlwTrim                       1a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Delete list:
     D DltLst          Pr                  ExtPgm( 'QUIDLTL' )
     D  AppHdl                        8a   Const
     D  LstNam                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Close application:
     D CloApp          Pr                  ExtPgm( 'QUICLOA' )
     D  AppHdl                        8a   Const
     D  CloOpt                        1a   Const
     D  Error                     32767a          Options( *VarSize )
 
     **-- Validate profile status:
     D ValPrfSts       Pr              n
     D  PxPrfSts                     10a   Value
     D  PxChkSts                     10a   Value
     D  PxDftRtn                       n   Value
     **-- Validate profile type:
     D ValPrfTyp       Pr              n
     D  PxPrfTyp                     10a   Value
     D  PxGrpInd                      1a   Value
     D  PxDftRtn                       n   Value
     **-- Validate profile inactivity days:
     D ValPrfDays      Pr              n
     D  PxPrfDays                     5i 0 Value
     D  PxPrvSgoDat                   7a   Value
     D  PxDftRtn                       n   Value
     **-- Validate password type:
     D ValPwdTyp       Pr              n
     D  PxPwdTyp                     10a   Value
     D  PxPwdCod                      1a   Value
     D  PxDftRtn                       n   Value
     **-- Validate password status:
     D ValPwdSts       Pr              n
     D  PxPwdSts                     10a   Value
     D  PxPwdExpI                     1a   Value
     D  PxDftRtn                       n   Value
     **-- Validate password unchanged days:
     D ValPwdDays      Pr              n
     D  PxPwdDays                     5i 0 Value
     D  PxPwdChgDat                   7a   Value
     D  PxDftRtn                       n   Value
     **-- Validate password expiration interval:
     D ValPwdExp       Pr              n
     D  PxPwdExp                      5i 0 Value
     D  PxPwdExpItv                   5i 0 Value
     D  PxDftRtn                       n   Value
     **-- Validate invalid signon:
     D ValInvSgo       Pr              n
     D  PxInvSgo                     10a   Value
     D  PxInvSgoCnt                  10i 0 Value
     D  PxDftRtn                       n   Value
     **-- Validate user class:
     D ValUsrCls       Pr              n
     D  PxUsrCls                     10a   Value
     D  PxChkCls                     10a   Value
     D  PxDftRtn                       n   Value
     **-- Validate special authority:
     D ValSpcAut       Pr              n
     D  PxSpcAut                           Value  LikeDs( SpcAut_t )
     D  PxAutFlg                           Value  LikeDs( SpcAut )
     D  PxDftRtn                       n   Value
     **-- Validate limited capability:
     D ValLmtCap       Pr              n
     D  PxLmtCap                     10a   Value
     D  PxChkCap                     10a   Value
     D  PxDftRtn                       n   Value
     **-- Validate group profile:
     D ValGrpPrf       Pr              n
     D  PxGrpPrf                     10a   Value
     D  PxChkGrp                     10a   Value
     D  PxDftRtn                       n   Value
     **-- Validate supplemental groups:
     D ValSupGrp       Pr              n
     D  PxSupGrp                           Const  LikeDs( SupGrp_t )
     D  PxChkSup                           Const  LikeDs( SupGrp_t )
     D  PxDftRtn                       n   Value
     **-- Check supplemental group:
     D ChkSupGrp       Pr              n
     D  PxSupGrp                     10a   Const
     D  PxChkSup                           Const  LikeDs( SupGrp_t )
 
     **-- Get job type:
     D GetJobTyp       Pr             1a
     **-- Get CYMD-date from DTS-timestamp:
     D GetCymdDts      Pr             7a
     D  PxSysDts                      8a   Value
     **-- Get special authority count:
     D GetSpcAut       Pr             5i 0
     D  PxSpcAut                     15a   Const
     **-- Get user audit value count:
     D GetUsrAud       Pr             5i 0
     D  PxUsrAudVal                  64a   Const
     **-- Get profile creation date:
     D GetCrtDat       Pr             7a
     D  PxUsrPrf                     10a   Value
     **-- Get object owner:
     D GetObjOwn       Pr            10a
     D  PxUsrPrf                     10a   Value
     **-- Get profile last used date:
     D GetUsdDat       Pr             7a
     D  PxUsrPrf                     10a   Value
     **-- Verify user index entry:
     D VfyIdxEnt       Pr              n
     D  PxIdxNam_q                   20a   Const
     D  PxKeyVal                   2000a   Const  Varying
     **-- Check generic name:
     D ChkGenNam       Pr              n
     D  PxGenNam                     10a   Value
     D  PxChkNam                     10a   Value
     **-- Get user creator:
     D GetUsrCrt       Pr            10a
     D  PxUsrPrf                     10a   Value
     **-- Get system value:
     D GetSysVal       Pr          4096a   Varying
     D  PxSysVal                     10a   Const
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
     **-- Send UIM completion message:
     D SndUimMsg       Pr             4a
     D  PxMsgId                       7a   Const
     D  PxMsgFil_q                   20a   Const           Options( *Omit )
     D  PxMsgDta                    512a   Const  Varying  Options( *Omit )
 
     **-- Entry parameters:
     D SpcAut_t        Ds                  Qualified
     D  NbrVal                        5i 0
     D  SpcAut                       10a   Dim( 8 )
     **
     D SupGrp_t        Ds                  Qualified
     D  NbrVal                        5i 0
     D  SupGrp                       10a   Dim( 15 )
     D  SupGrpStr                   150a   Overlay( SupGrp_t: 3 )
     **
     D CBX9721         Pr
     D  PxUsrPrf                     10a
     D  PxRelCri                     10a
     D  PxPrfTyp                      1a
     D  PxPrfSts                     10a
     D  PxPrfDays                     5i 0
     D  PxPwdTyp                     10a
     D  PxPwdSts                     10a
     D  PxPwdDays                     5i 0
     D  PxPwdExp                      5i 0
     D  PxInvSgo                     10a
     D  PxUsrCls                     10a
     D  PxSpcAut                           LikeDs( SpcAut_t )
     D  PxLmtCap                     10a
     D  PxGrpPrf                     10a
     D  PxSupGrp                           LikeDs( SupGrp_t )
     D  PxSysPrf                      4a
     D  PxUpdPwd                      4a
     D  PxOutOpt                      3a
     **
     D CBX9721         Pi
     D  PxUsrPrf                     10a
     D  PxRelCri                     10a
     D  PxPrfTyp                      1a
     D  PxPrfSts                     10a
     D  PxPrfDays                     5i 0
     D  PxPwdTyp                     10a
     D  PxPwdSts                     10a
     D  PxPwdDays                     5i 0
     D  PxPwdExp                      5i 0
     D  PxInvSgo                     10a
     D  PxUsrCls                     10a
     D  PxSpcAut                           LikeDs( SpcAut_t )
     D  PxLmtCap                     10a
     D  PxGrpPrf                     10a
     D  PxSupGrp                           LikeDs( SupGrp_t )
     D  PxSysPrf                      4a
     D  PxUpdPwd                      4a
     D  PxOutOpt                      3a
 
      /Free
 
        SpcAutLst( 1 ) = '*SECADM';
        SpcAutLst( 2 ) = '*ALLOBJ';
 
        ChkSpcAut( AutFlg
                 : PgmSts.UsrPrf
                 : SpcAutLst
                 : 2
                 : ADP_PRV_INVLVL
                 : ERRC0100
                 );
 
        If  ERRC0100.BytAvl > *Zero  Or AutFlg = 'N';
          SndEscMsg( 'CPFB304': 'QCPFMSG': NULL );
        EndIf;
 
        If  PxOutOpt = 'DSP'  And  GetJobTyp() = TYP_INTER;
 
          OpnDspApp( UIM.AppHdl
                   : PNLGRP_Q
                   : SCP_AUT_RCL
                   : PRM_IFC_0
                   : HLP_WDW
                   : ERRC0100
                   );
        Else;
          OpnPrtApp( UIM.AppHdl
                   : PNLGRP_Q
                   : SCP_AUT_RCL
                   : PRM_IFC_0
                   : APP_PRTF
                   : SPLF_NAM
                   : ODP_SHR
                   : SPLF_USRDTA
                   : ERRC0100
                   );
        EndIf;
 
        If  ERRC0100.BytAvl > *Zero;
          ExSr  EscApiErr;
        EndIf;
 
        PutDlgVar( UIM.AppHdl: ExpRcd: %Size( ExpRcd ): 'EXPRCD': ERRC0100 );
 
        ExSr  BldHdrRcd;
        ExSr  BldAutUsrLst;
 
        If  PxOutOpt = 'DSP'  And  GetJobTyp() = TYP_INTER;
          ExSr  DspLst;
        Else;
          ExSr  WrtLst;
        EndIf;
 
        CloApp( UIM.AppHdl: CLO_NORM: ERRC0100 );
 
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
 
        BegSr  DspLst;
 
          DoU  UIM.FncRqs = FNC_EXIT  Or  UIM.FncRqs = FNC_CNL;
 
            If  MsgDta.NbrRcd > *Zero;
              UimMsgKey = SndUimMsg( 'CBX0101': APP_MSGF: MsgDta );
            Else;
              UimMsgKey = *Blanks;
            EndIf;
 
            DspPnl( UIM.AppHdl
                  : UIM.FncRqs
                  : PNLGRP
                  : RDS_OPT_INZ
                  : ERRC0100
                  : NO_TASK_BDY
                  : CALLSTK_SAME
                  : MSGQ_CALLER
                  : UimMsgKey
                  : 'D'
                  : 'NONE'
                  : 'NONE'
                  : -1
                  );
 
            If  ERRC0100.BytAvl > *Zero;
              ExSr  EscApiErr;
            EndIf;
 
            GetDlgVar( UIM.AppHdl
                     : HdrRcd
                     : %Size( HdrRcd )
                     : 'HDRRCD'
                     : ERRC0100
                     );
 
            Select;
            When  UIM.FncRqs = KEY_F05  And  UIM.EntLocOpt = 'NEXT';
              ExSr  GetLstPos;
              ExSr  DltUsrLst;
 
            When  WrkUsr <> HdrRcd.WrkUsr;
              ExSr  DltUsrLst;
            EndSl;
 
            Select;
            When  UIM.FncRqs = KEY_F05;
              ExSr  RstHdrRcd;
              ExSr  BldHdrRcd;
              ExSr  BldAutUsrLst;
              ExSr  SetLstPos;
 
            When  WrkUsr <> HdrRcd.WrkUsr;
              WrkUsr = HdrRcd.WrkUsr;
 
              ExSr  BldHdrRcd;
              ExSr  BldAutUsrLst;
            EndSl;
 
            Select;
            When  UIM.FncRqs = RTN_ENTER  And
                  UIM.EntLocOpt = 'NEXT'  And
                  HdrRcd.PosUsr > *Blanks;
 
              ExSr  FndLstPos;
 
            When  UIM.FncRqs = KEY_F17;
              ExSr  PosLstTop;
 
            When  UIM.FncRqs = KEY_F18;
              ExSr  PosLstBot;
            EndSl;
 
          EndDo;
 
        EndSr;
 
        BegSr  WrtLst;
 
          PrtPnl( UIM.AppHdl
                : 'PRTHDR'
                : EJECT_NO
                : ERRC0100
                );
 
          PrtPnl( UIM.AppHdl
                : 'PRTLST'
                : EJECT_NO
                : ERRC0100
                );
 
          SndCmpMsg( 'List has been printed.' );
 
        EndSr;
 
        BegSr  BldAutUsrLst;
 
          SndStsMsg( 'Retrieving user profile information, please wait...' );
 
          If  PxUpdPwd = '*YES';
            CBX9722( IdxNam_q );
          EndIf;
 
          UIM.EntLocOpt = 'FRST';
 
          MsgDta.NbrRcd = *Zero;
 
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
                   : WrkUsr
                   );
 
          If  ERRC0100.BytAvl = *Zero;
 
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
          EndIf;
 
          SetLstAtr( UIM.AppHdl
                   : 'DTLLST'
                   : LIST_COMP
                   : EXIT_SAME
                   : POS_TOP
                   : TRIM_SAME
                   : ERRC0100
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
 
            If  PxSysPrf = '*YES'  Or  GetUsrCrt( AUTU0150.UsrPrf ) <> '*IBM';
 
              ExSr  SetValFld;
 
              If  PxRelCri = '*AND';
                ExSr  ValCriAnd;
              Else;
                ExSr  ValCriOr;
              EndIf;
            EndIf;
 
          EndIf;
 
        EndSr;
 
        BegSr  SetValFld;
 
          Select;
          When  USRI0300.NoPwdI = 'Y';
            LstEnt.PwdTyp = 'N';
 
          When  PxUpdPwd = '*NO';
            LstEnt.PwdTyp = 'P';
 
          When  VfyIdxEnt( IdxNam_q: AUTU0150.UsrPrf ) = *On;
            LstEnt.PwdTyp = 'D';
 
          Other;
            LstEnt.PwdTyp = 'P';
          EndSl;
 
          If  USRI0300.PwdChgDat = *Blanks;
            LstEnt.PwdChgDat = GetCrtDat( AUTU0150.UsrPrf );
          Else;
            LstEnt.PwdChgDat = GetCymdDts( USRI0300.PwdChgDat );
          EndIf;
 
          LstEnt.PrvSgoDat = GetUsdDat( AUTU0150.UsrPrf );
 
          Select;
          When  USRI0300.PrvSgoDat > *Blanks  And
                USRI0300.PrvSgoDat >= LstEnt.PrvSgoDat;
          LstEnt.JrnDat = %Char( %Date( USRI0300.PrvSgoDat: *CYMD0 ): *JOBRUN );
          LstEnt.JrnTim = %Char( %Time( USRI0300.PrvSgoTim: *HMS0 ): *JOBRUN );
 
          When  LstEnt.PrvSgoDat > *Blanks;
            LstEnt.JrnDat = %Char( %Date( LstEnt.PrvSgoDat: *CYMD0 ): *JOBRUN );
            LstEnt.JrnTim = %Char( %Time( '000000': *HMS0 ): *JOBRUN );
          Other;
            LstEnt.JrnDat = %Char( %Date(): *JOBRUN );
            LstEnt.JrnTim = %Char( %Time( '000000': *HMS0 ): *JOBRUN );
          EndSl;
 
          If  USRI0300.PrvSgoDat > *Blanks  And
              USRI0300.PrvSgoDat > LstEnt.PrvSgoDat;
            LstEnt.PrvSgoDat = USRI0300.PrvSgoDat;
          EndIf;
 
          LstEnt.SupGrp.NbrVal = USRI0300.NbrSupGrp;
 
          If  USRI0300.NbrSupGrp = *Zero;
            LstEnt.SupGrp.SupGrpStr = '*NONE';
          Else;
            LstEnt.SupGrp.SupGrpStr = %Subst( USRI0300
                                            : USRI0300.OfsSupGrp + 1
                                            : USRI0300.NbrSupGrp * 10
                                            );
          EndIf;
 
          Select;
          When  USRI0300.InlMnu = '*SIGNOFF'  And
                USRI0300.InlPgm = '*NONE'     And
                USRI0300.LmtCap = '*YES';
            LstEnt.SignOn = '0';
 
          When  USRI0300.InlMnu = '*SIGNOFF'  And
                USRI0300.InlPgm = '*NONE';
            LstEnt.SignOn = '2';
 
          Other;
            LstEnt.SignOn = '1';
          EndSl;
 
          If  GetSysVal( 'QMAXSIGN' ) = '*NOMAX';
            SysVal = '999999';
          Else;
            SysVal = GetSysVal( 'QMAXSIGN' );
          EndIf;
 
        EndSr;
 
        BegSr  ValCriAnd;
 
          If  ValPrfSts( PxPrfSts: USRI0300.PrfSts: *On )    = *On  And
 
              ValPrfTyp( PxPrfTyp: AUTU0150.UsrGrpI: *On )   = *On  And
 
              ValPwdTyp( PxPwdTyp: LstEnt.PwdTyp: *On )      = *On  And
 
              ValPwdSts( PxPwdSts: USRI0300.PwdExpI: *On )   = *On  And
 
              ValPrfDays( PxPrfDays: LstEnt.PrvSgoDat: *On ) = *On  And
 
              ValPwdDays( PxPwdDays: LstEnt.PwdChgDat: *On ) = *On  And
 
              ValPwdExp( PxPwdExp: USRI0300.PwdExpItv: *On ) = *On  And
 
              ValInvSgo( PxInvSgo: USRI0300.InvSgo: *On )    = *On  And
 
              ValUsrCls( PxUsrCls: USRI0300.UsrCls: *On )    = *On  And
 
              ValLmtCap( PxLmtCap: USRI0300.LmtCap: *On )    = *On  And
 
              ValSpcAut( PxSpcAut: USRI0300.SpcAut: *On )    = *On  And
 
              ValGrpPrf( PxGrpPrf: USRI0300.GrpPrf: *On )    = *On  And
 
              ValSupGrp( PxSupGrp: LstEnt.SupGrp: *On )      = *On;
 
            ExSr  PutLstEnt;
          EndIf;
 
        EndSr;
 
        BegSr  ValCriOr;
 
          If  ValPrfSts( PxPrfSts: USRI0300.PrfSts: *Off )    = *On  Or
 
              ValPrfTyp( PxPrfTyp: AUTU0150.UsrGrpI: *Off )   = *On  Or
 
              ValPwdTyp( PxPwdTyp: LstEnt.PwdTyp: *Off )      = *On  Or
 
              ValPwdSts( PxPwdSts: USRI0300.PwdExpI: *Off )   = *On  Or
 
              ValPrfDays( PxPrfDays: LstEnt.PrvSgoDat: *Off ) = *On  Or
 
              ValPwdDays( PxPwdDays: LstEnt.PwdChgDat: *Off ) = *On  Or
 
              ValPwdExp( PxPwdExp: USRI0300.PwdExpItv: *Off ) = *On  Or
 
              ValInvSgo( PxInvSgo: USRI0300.InvSgo: *Off )    = *On  Or
 
              ValUsrCls( PxUsrCls: USRI0300.UsrCls: *Off )    = *On  Or
 
              ValLmtCap( PxLmtCap: USRI0300.LmtCap: *Off )    = *On  Or
 
              ValSpcAut( PxSpcAut: USRI0300.SpcAut: *Off )    = *On  Or
 
              ValGrpPrf( PxGrpPrf: USRI0300.GrpPrf: *Off )    = *On  Or
 
              ValSupGrp( PxSupGrp: LstEnt.SupGrp: *Off )      = *On;
 
            ExSr  PutLstEnt;
          EndIf;
 
        EndSr;
 
        BegSr  PutLstEnt;
 
          RtvUsrAut( USRA0100
                   : %Size( USRA0100 )
                   : 'USRA0100'
                   : '*PUBLIC'
                   : AUTU0150.UsrPrf + 'QSYS'
                   : '*USRPRF'
                   : ERRC0100
                   );
 
          If  ERRC0100.BytAvl > *Zero;
            Clear  USRA0100;
          EndIf;
 
          LstEnt.Option = *Zero;
 
          LstEnt.UsrPrf    = AUTU0150.UsrPrf;
          LstEnt.PrfSts    = USRI0300.PrfSts;
          LstEnt.UsrCls    = USRI0300.UsrCls;
          LstEnt.InvSgo    = USRI0300.InvSgo;
          LstEnt.PwdExpItv = USRI0300.PwdExpItv;
          LstEnt.PrvSgoDat = USRI0300.PrvSgoDat;
          LstEnt.PrvSgoTim = USRI0300.PrvSgoTim;
          LstEnt.PwdExpI   = USRI0300.PwdExpI;
          LstEnt.SpcAut    = USRI0300.SpcAut;
          LstEnt.LmtCap    = USRI0300.LmtCap;
          LstEnt.GrpPrf    = USRI0300.GrpPrf;
          LstEnt.ObjAudVal = USRI0300.ObjAudVal;
          LstEnt.UsrAudVal = USRI0300.UsrAudVal;
          LstEnt.DigCerI   = USRI0300.DigCerI;
          LstEnt.LocPwdMgt = USRI0300.LocPwdMgt;
          LstEnt.TxtDsc    = USRI0300.TxtDsc;
          LstEnt.PubAut    = USRA0100.ObjAut;
 
          LstEnt.PwdChgDat = GetCymdDts( USRI0300.PwdChgDat );
          LstEnt.NbrSpcAut = GetSpcAut( USRI0300.SpcAut );
          LstEnt.NbrUsrAud = GetUsrAud( USRI0300.UsrAudVal );
          LstEnt.LstUsdDat = GetUsdDat( AUTU0150.UsrPrf );
          LstEnt.CrtUsr    = GetUsrCrt( AUTU0150.UsrPrf );
          LstEnt.ObjOwn    = GetObjOwn( AUTU0150.UsrPrf );
 
          AddLstEnt( UIM.AppHdl
                   : LstEnt
                   : %Size( LstEnt )
                   : 'DTLRCD'
                   : 'DTLLST'
                   : UIM.EntLocOpt
                   : UIM.LstHdl
                   : ERRC0100
                   );
 
          UIM.EntLocOpt = 'NEXT';
          MsgDta.NbrRcd += 1;
 
        EndSr;
 
        BegSr  GetLstPos;
 
          RtvLstAtr( UIM.AppHdl: 'DTLLST': LstAtr: %Size( LstAtr ): ERRC0100 );
 
          If  LstAtr.DspPos <> 'TOP';
 
            GetLstEnt( UIM.AppHdl
                     : LstEnt
                     : %Size( LstEnt )
                     : 'DTLRCD'
                     : 'DTLLST'
                     : 'HNDL'
                     : 'Y'
                     : *Blanks
                     : LstAtr.DspPos
                     : 'N'
                     : UIM.EntHdl
                     : ERRC0100
                     );
 
            LstEntPos = LstEnt;
          EndIf;
 
        EndSr;
 
        BegSr  SetLstPos;
 
          If  LstAtr.DspPos <> 'TOP';
 
            LstEnt = LstEntPos;
 
            PutDlgVar( UIM.AppHdl
                     : LstEnt
                     : %Size( LstEnt )
                     : 'DTLRCD'
                     : ERRC0100
                     );
 
            GetLstEnt( UIM.AppHdl
                     : LstEnt
                     : %Size( LstEnt )
                     : '*NONE'
                     : 'DTLLST'
                     : 'FSLT'
                     : 'N'
                     : 'EQ        USRPRF'
                     : *Blanks
                     : 'N'
                     : UIM.EntHdl
                     : ERRC0100
                     );
 
            If  ERRC0100.BytAvl = *Zero;
 
              SetLstAtr( UIM.AppHdl
                       : 'DTLLST'
                       : LIST_SAME
                       : EXIT_SAME
                       : UIM.EntHdl
                       : TRIM_SAME
                       : ERRC0100
                       );
 
            EndIf;
          EndIf;
 
        EndSr;
 
        BegSr  FndLstPos;
 
          LstEnt.UsrPrf = HdrRcd.PosUsr;
 
          PutDlgVar( UIM.AppHdl
                   : LstEnt
                   : %Size( LstEnt )
                   : 'DTLRCD'
                   : ERRC0100
                   );
 
          GetLstEnt( UIM.AppHdl
                   : LstEnt
                   : %Size( LstEnt )
                   : 'DTLRCD'
                   : 'DTLLST'
                   : 'FSLT'
                   : 'Y'
                   : 'GE        USRPRF'
                   : *Blanks
                   : 'N'
                   : UIM.EntHdl
                   : ERRC0100
                   );
 
          Select;
          When  ERRC0100.BytAvl > *Zero;
            GetLstEnt( UIM.AppHdl
                     : LstEnt
                     : %Size( LstEnt )
                     : '*NONE'
                     : 'DTLLST'
                     : 'LAST'
                     : 'N'
                     : *Blanks
                     : *Blanks
                     : 'N'
                     : UIM.EntHdl
                     : ERRC0100
                     );
 
          When  %Scan( %Trim( HdrRcd.PosUsr ): LstEnt.UsrPrf ) <> 1;
            GetLstEnt( UIM.AppHdl
                     : LstEnt
                     : %Size( LstEnt )
                     : '*NONE'
                     : 'DTLLST'
                     : 'PREV'
                     : 'N'
                     : *Blanks
                     : *Blanks
                     : 'N'
                     : UIM.EntHdl
                     : ERRC0100
                     );
 
            If  ERRC0100.BytAvl > *Zero;
              GetLstEnt( UIM.AppHdl
                       : LstEnt
                       : %Size( LstEnt )
                       : '*NONE'
                       : 'DTLLST'
                       : 'FRST'
                       : 'N'
                       : *Blanks
                       : *Blanks
                       : 'N'
                       : UIM.EntHdl
                       : ERRC0100
                       );
            EndIf;
          EndSl;
 
          If  ERRC0100.BytAvl = *Zero;
 
            SetLstAtr( UIM.AppHdl
                     : 'DTLLST'
                     : LIST_SAME
                     : EXIT_SAME
                     : UIM.EntHdl
                     : TRIM_SAME
                     : ERRC0100
                     );
 
          EndIf;
 
          HdrRcd.PosUsr = *Blanks;
 
        EndSr;
 
        BegSr  PosLstTop;
 
          SetLstAtr( UIM.AppHdl
                   : 'DTLLST'
                   : LIST_SAME
                   : EXIT_SAME
                   : POS_TOP
                   : TRIM_SAME
                   : ERRC0100
                   );
 
        EndSr;
 
        BegSr  PosLstBot;
 
          SetLstAtr( UIM.AppHdl
                   : 'DTLLST'
                   : LIST_SAME
                   : EXIT_SAME
                   : POS_BOT
                   : TRIM_SAME
                   : ERRC0100
                   );
 
        EndSr;
 
        BegSr  BldHdrRcd;
 
          SysDts = %Timestamp();
 
          HdrRcd.SysDat = %Char( %Date( SysDts ): *CYMD0 );
          HdrRcd.SysTim = %Char( %Time( SysDts ): *HMS0 );
          HdrRcd.TimZon = '*SYS';
 
          PutDlgVar( UIM.AppHdl: HdrRcd: %Size( HdrRcd ): 'HDRRCD': ERRC0100 );
 
        EndSr;
 
        BegSr  RstHdrRcd;
 
          HdrRcd.WrkUsr = WrkUsr;
          HdrRcd.PosUsr = *Blanks;
 
        EndSr;
 
        BegSr  *InzSr;
 
          HdrRcd.WrkUsr = PxUsrPrf;
          HdrRcd.PosUsr = *Blanks;
 
          WrkUsr = HdrRcd.WrkUsr;
 
        EndSr;
 
        BegSr  DltUsrLst;
 
          DltLst( UIM.AppHdl: 'DTLLST': ERRC0100 );
 
        EndSr;
 
      /End-Free
 
     **-- Validate profile status:
     P ValPrfSts       B
     D                 Pi              n
     D  PxPrfSts                     10a   Value
     D  PxChkSts                     10a   Value
     D  PxDftRtn                       n   Value
 
      /Free
 
        Select;
        When  PxPrfSts = '*NOCHK';
          Return  PxDftRtn;
 
        When  PxPrfSts = PxChkSts;
          Return  *On;
 
        Other;
          Return  *Off;
        EndSl;
 
      /End-Free
 
     P ValPrfSts       E
     **-- Validate profile type:
     P ValPrfTyp       B
     D                 Pi              n
     D  PxPrfTyp                     10a   Value
     D  PxGrpInd                      1a   Value
     D  PxDftRtn                       n   Value
 
      /Free
 
        Select;
        When  PxPrfTyp = *Blank;
          Return  PxDftRtn;
 
        When  PxPrfTyp = PxGrpInd;
          Return  *On;
 
        Other;
          Return  *Off;
        EndSl;
 
      /End-Free
 
     P ValPrfTyp       E
     **-- Validate profile inactivity days:
     P ValPrfDays      B
     D                 Pi              n
     D  PxPrfDays                     5i 0 Value
     D  PxPrvSgoDat                   7a   Value
     D  PxDftRtn                       n   Value
 
      /Free
 
        Select;
        When  PxPrfDays = -1;
          Return  PxDftRtn;
 
        When  PxPrvSgoDat = *Blanks;
          Return  *On;
 
        When  %Diff( %Date()
                   : %Date( PxPrvSgoDat: *CYMD0 )
                   : *Days
                   ) > PxPrfDays;
          Return  *On;
 
        Other;
          Return  *Off;
        EndSl;
 
      /End-Free
 
     P ValPrfDays      E
     **-- Validate password type:
     P ValPwdTyp       B
     D                 Pi              n
     D  PxPwdTyp                     10a   Value
     D  PxPwdCod                      1a   Value
     D  PxDftRtn                       n   Value
 
      /Free
 
        Select;
        When  PxPwdTyp = '*NOCHK';
          Return  PxDftRtn;
 
        When  PxPwdTyp = '*DFT'  And  PxPwdCod = 'D';
          Return  *On;
 
        When  PxPwdTyp = '*PWD'  And  PxPwdCod = 'P';
          Return  *On;
 
        When  PxPwdTyp = '*NONE'  And  PxPwdCod = 'N';
          Return  *On;
 
        Other;
          Return  *Off;
        EndSl;
 
      /End-Free
 
     P ValPwdTyp       E
     **-- Validate password status:
     P ValPwdSts       B
     D                 Pi              n
     D  PxPwdSts                     10a   Value
     D  PxPwdExpI                     1a   Value
     D  PxDftRtn                       n   Value
 
      /Free
 
        Select;
        When  PxPwdSts = '*NOCHK';
          Return  PxDftRtn;
 
        When  PxPwdSts = '*EXPIRED'  And  PxPwdExpI = 'Y';
          Return  *On;
 
        When  PxPwdSts = '*ACTIVE'  And  PxPwdExpI = 'N';
          Return  *On;
 
        Other;
          Return  *Off;
        EndSl;
 
      /End-Free
 
     P ValPwdSts       E
     **-- Validate password unchanged days:
     P ValPwdDays      B
     D                 Pi              n
     D  PxPwdDays                     5i 0 Value
     D  PxPwdChgDat                   7a   Value
     D  PxDftRtn                       n   Value
 
      /Free
 
        Select;
        When  PxPwdDays = -1;
          Return  PxDftRtn;
 
        When  PxPwdChgDat = *Blanks;
          Return  *On;
 
        When  %Diff( %Date()
                   : %Date( PxPwdChgDat: *CYMD0 )
                   : *Days
                   ) > PxPwdDays;
          Return  *On;
 
        Other;
          Return  *Off;
        EndSl;
 
      /End-Free
 
     P ValPwdDays      E
     **-- Validate password expiration interval:
     P ValPwdExp       B
     D                 Pi              n
     D  PxPwdExp                      5i 0 Value
     D  PxPwdExpItv                   5i 0 Value
     D  PxDftRtn                       n   Value
 
      /Free
 
        Select;
        When  PxPwdExp  = -2;
          Return  PxDftRtn;
 
        When  PxPwdExp  = PxPwdExpItv;
          Return  *On;
 
        When  PxPwdExp  > *Zero  And  PxPwdExp < PxPwdExpItv;
          Return  *On;
 
        Other;
          Return  *Off;
        EndSl;
 
      /End-Free
 
     P ValPwdExp       E
     **-- Validate invalid signon:
     P ValInvSgo       B
     D                 Pi              n
     D  PxInvSgo                     10a   Value
     D  PxInvSgoCnt                  10i 0 Value
     D  PxDftRtn                       n   Value
 
      /Free
 
        Select;
        When  PxInvSgo = '*NOCHK';
          Return  PxDftRtn;
 
        When  PxInvSgo = '*CHECK'   And  PxInvSgoCnt > *Zero;
          Return  *On;
 
        When  PxInvSgo = '*SYSLMT'  And  PxInvSgoCnt > SysVal.MaxSign;
          Return  *On;
 
        Other;
          Return  *Off;
        EndSl;
 
      /End-Free
 
     P ValInvSgo       E
     **-- Validate user class:
     P ValUsrCls       B
     D                 Pi              n
     D  PxUsrCls                     10a   Value
     D  PxChkCls                     10a   Value
     D  PxDftRtn                       n   Value
 
      /Free
 
        Select;
        When  PxUsrCls = '*NOCHK';
          Return  PxDftRtn;
 
        When  PxUsrCls = '*NONUSER'  And  PxChkCls <> '*USER';
          Return  *On;
 
        When  PxUsrCls = PxChkCls;
          Return  *On;
 
        Other;
          Return  *Off;
        EndSl;
 
      /End-Free
 
     P ValUsrCls       E
     **-- Validate special authority:
     P ValSpcAut       B
     D                 Pi              n
     D  PxSpcAut                           Value  LikeDs( SpcAut_t )
     D  PxAutFlg                           Value  LikeDs( SpcAut )
     D  PxDftRtn                       n   Value
 
     **-- Local variables:
     D Idx             s             10i 0
 
      /Free
 
        Select;
        When  PxSpcAut.SpcAut(1) = '*NOCHK';
          Return  PxDftRtn;
 
        When  PxSpcAut.SpcAut(1) = '*ANY'  And  %Scan( 'Y': PxAutFlg ) > *Zero;
          Return  *On;
 
        When  PxSpcAut.SpcAut(1) = '*ANY';
          Return  *Off;
 
        When  PxSpcAut.SpcAut(1) = '*NONE'  And  %Scan( 'Y': PxAutFlg ) = *Zero;
          Return  *On;
 
        When  PxSpcAut.SpcAut(1) = '*NONE';
          Return  *Off;
 
        Other;
          For  Idx = 1  to  PxSpcAut.NbrVal;
 
            Select;
            When  PxSpcAut.SpcAut(Idx) = '*AUDIT'   And  PxAutFlg.Audit  = 'N';
              Return  *Off;
 
            When  PxSpcAut.SpcAut(Idx) = '*ALLOBJ'  And  PxAutFlg.AllObj = 'N';
              Return  *Off;
 
            When  PxSpcAut.SpcAut(Idx) = '*SECADM'  And  PxAutFlg.SecAdm = 'N';
              Return  *Off;
 
            When  PxSpcAut.SpcAut(Idx) = '*JOBCTL'  And  PxAutFlg.JobCtl = 'N';
              Return  *Off;
 
            When  PxSpcAut.SpcAut(Idx) = '*SPLCTL'  And  PxAutFlg.SplCtl = 'N';
              Return  *Off;
 
            When  PxSpcAut.SpcAut(Idx) = '*SAVSYS'  And  PxAutFlg.SavSys = 'N';
              Return  *Off;
 
            When  PxSpcAut.SpcAut(Idx) = '*SERVICE'   And
                  PxAutFlg.Service     = 'N';
              Return  *Off;
 
            When  PxSpcAut.SpcAut(Idx) = '*IOSYSCFG'  And
                  PxAutFlg.IoSysCfg    = 'N';
              Return  *Off;
            EndSl;
 
          EndFor;
        EndSl;
 
        Return  *On;
 
      /End-Free
 
     P ValSpcAut       E
     **-- Validate limited capability:
     P ValLmtCap       B
     D                 Pi              n
     D  PxLmtCap                     10a   Value
     D  PxChkCap                     10a   Value
     D  PxDftRtn                       n   Value
 
      /Free
 
        Select;
        When  PxLmtCap = '*NOCHK';
          Return  PxDftRtn;
 
        When  PxLmtCap = '*ANYLMT'  And  PxChkCap <> '*NO';
          Return  *On;
 
        When  PxLmtCap = PxChkCap;
          Return  *On;
 
        Other;
          Return  *Off;
        EndSl;
 
      /End-Free
 
     P ValLmtCap       E
     **-- Validate group profile:
     P ValGrpPrf       B
     D                 Pi              n
     D  PxGrpPrf                     10a   Value
     D  PxChkGrp                     10a   Value
     D  PxDftRtn                       n   Value
 
      /Free
 
        Select;
        When  PxGrpPrf = '*NOCHK';
          Return  PxDftRtn;
 
        When  PxGrpPrf = '*ANY'   And  PxChkGrp <> '*NONE';
          Return  *On;
 
        When  PxGrpPrf = '*NONE'  And  PxChkGrp  = '*NONE';
          Return  *On;
 
        When  ChkGenNam( PxGrpPrf: PxChkGrp ) = *On;
          Return  *On;
 
        Other;
          Return  *Off;
        EndSl;
 
      /End-Free
 
     P ValGrpPrf       E
     **-- Validate supplemental groups:
     P ValSupGrp       B
     D                 Pi              n
     D  PxSupGrp                           Const  LikeDs( SupGrp_t )
     D  PxChkSup                           Const  LikeDs( SupGrp_t )
     D  PxDftRtn                       n   Value
 
     **-- Local variables:
     D Idx             s             10i 0
 
      /Free
 
        Select;
        When  PxSupGrp.SupGrp(1) = '*NOCHK';
          Return  PxDftRtn;
 
        When  PxSupGrp.SupGrp(1) = '*ANY'   And  PxChkSup.NbrVal > *Zero;
          Return  *On;
 
        When  PxSupGrp.SupGrp(1) = '*ANY';
          Return  *Off;
 
        When  PxSupGrp.SupGrp(1) = '*NONE'  And  PxChkSup.NbrVal = *Zero;
          Return  *On;
 
        When  PxSupGrp.SupGrp(1) = '*NONE';
          Return  *Off;
 
        Other;
          For  Idx = 1  to  PxSupGrp.NbrVal;
 
            If  ChkSupGrp( PxSupGrp.SupGrp(Idx): PxChkSup ) = *On;
              Return  *On;
            EndIf;
          EndFor;
        EndSl;
 
        Return  *Off;
 
      /End-Free
 
     P ValSupGrp       E
     **-- Check supplemental group:
     P ChkSupGrp       B
     D                 Pi              n
     D  PxSupGrp                     10a   Const
     D  PxChkSup                           Const  LikeDs( SupGrp_t )
 
     **-- Local variables:
     D Idx             s             10i 0
 
      /Free
 
        For  Idx = 1  to  PxChkSup.NbrVal;
 
          If  ChkGenNam( PxSupGrp: PxChkSup.SupGrp(Idx)) = *On;
            Return  *On;
          EndIf;
        EndFor;
 
        Return  *Off;
 
      /End-Free
 
     P ChkSupGrp       E
 
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
     **-- Get CYMD date from *DTS timestamp:
     P GetCymdDts      B
     D                 Pi             7a
     D  PxSysDts                      8a   Value
 
     **-- Local variables:
     D OutDts          Ds                  Qualified
     D  OutDat                        8s 0
     D  OutTim                        9s 0
 
      /Free
 
        If  PxSysDts = *Blanks;
          Return  *Blanks;
 
        Else;
          CvtDtf( '*DTS': PxSysDts: '*YYMD': OutDts: ERRC0100 );
 
          If  ERRC0100.BytAvl > *Zero;
            Return  *Blanks;
          Else;
            Return  %Char( %Date( OutDts.OutDat: *ISO ): *CYMD0 );
          EndIf;
        EndIf;
 
      /End-Free
 
     P GetCymdDts      E
     **-- Get special authority count:
     P GetSpcAut       B
     D                 Pi             5i 0
     D  PxSpcAut                     15a   Const
 
     **-- Local variables
     D Pos             s              5i 0 Inz( 0 )
     D Cnt             s              5i 0 Inz( 0 )
 
      /Free
 
        Pos = %Scan( 'Y': PxSpcAut: Pos + 1 );
 
        DoW  Pos > *Zero;
          Cnt += 1;
 
          Pos = %Scan( 'Y': PxSpcAut: Pos + 1 );
        EndDo;
 
        Return  Cnt;
 
      /End-Free
 
     P GetSpcAut       E
     **-- Get user audit value count:
     P GetUsrAud       B
     D                 Pi             5i 0
     D  PxUsrAudVal                  64a   Const
 
     **-- Local variables
     D Pos             s              5i 0 Inz( 0 )
     D Cnt             s              5i 0 Inz( 0 )
 
      /Free
 
        Pos = %Scan( 'Y': PxUsrAudVal: Pos + 1 );
 
        DoW  Pos > *Zero;
          Cnt += 1;
 
          Pos = %Scan( 'Y': PxUsrAudVal: Pos + 1 );
        EndDo;
 
        Return  Cnt;
 
      /End-Free
 
     P GetUsrAud       E
     **-- Get profile creation date:
     P GetCrtDat       B
     D                 Pi             7a
     D  PxUsrPrf                     10a   Value
     **
     D OBJD0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  CrtDts                       13a   Overlay( OBJD0100: 65 )
     D   CrtDat                       7a   Overlay( CrtDts: 1 )
     D   CrtTim                       6a   Overlay( CrtDts: 8 )
 
      /Free
 
        RtvObjD( OBJD0100
               : %Size( OBJD0100 )
               : 'OBJD0100'
               : PxUsrPrf + 'QSYS'
               : '*USRPRF'
               : ERRC0100
               );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  *Blanks;
 
        Else;
          Return  OBJD0100.CrtDat;
        EndIf;
 
      /End-Free
 
     P GetCrtDat       E
     **-- Get object owner:
     P GetObjOwn       B
     D                 Pi            10a
     D  PxUsrPrf                     10a   Value
     **
     D OBJD0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  ObjOwn                       13a   Overlay( OBJD0100: 53 )
 
      /Free
 
        RtvObjD( OBJD0100
               : %Size( OBJD0100 )
               : 'OBJD0100'
               : PxUsrPrf + 'QSYS'
               : '*USRPRF'
               : ERRC0100
               );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  *Blanks;
 
        Else;
          Return  OBJD0100.ObjOwn;
        EndIf;
 
      /End-Free
 
     P GetObjOwn       E
     **-- Get profile last used date:
     P GetUsdDat       B
     D                 Pi             7a
     D  PxUsrPrf                     10a   Value
     **
     D OBJD0400        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  LstUsdDat                     7a   Overlay( OBJD0400: 461 )
 
      /Free
 
        RtvObjD( OBJD0400
               : %Size( OBJD0400 )
               : 'OBJD0400'
               : PxUsrPrf + 'QSYS'
               : '*USRPRF'
               : ERRC0100
               );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  *Blanks;
 
        Else;
          If  OBJD0400.LstUsdDat > *Blanks;
            Return  OBJD0400.LstUsdDat;
 
          Else;
            Return  GetCrtDat( PxUsrPrf );
          EndIf;
        EndIf;
 
      /End-Free
 
     P GetUsdDat       E
     **-- Verify user index entry:
     P VfyIdxEnt       B
     D                 Pi              n
     D  PxIdxNam_q                   20a   Const
     D  PxKeyVal                   2000a   Const  Varying
 
     **-- Local variables:
     D IDXE0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  Entry                      2000a
     **
     D EntLoc          Ds                  Qualified
     D  EntOfs                       10i 0
     D  EntLen                       10i 0
     **
     D RtnLib          s             10a
     D EntNbrRtv       s             10i 0
     **-- Local constants:
     D ENT_SCH_EQ      c                   1
     D CRI_OFS_FIRST   c                   0
 
      /Free
 
        RtvUsrIdxE( IDXE0100
                  : %Size( IDXE0100 )
                  : EntLoc
                  : %Size( EntLoc )
                  : EntNbrRtv
                  : RtnLib
                  : PxIdxNam_q
                  : 'IDXE0100'
                  : 1
                  : ENT_SCH_EQ
                  : PxKeyval
                  : %Len( PxKeyVal )
                  : CRI_OFS_FIRST
                  : ERRC0100
                  );
 
        Select;
        When  ERRC0100.BytAvl > *Zero;
          Return  *Off;
 
        When  EntNbrRtv = *Zero;
          Return  *Off;
 
        Other;
          Return  *On;
        EndSl;
 
      /End-Free
 
     P VfyIdxEnt       E
     **-- Check generic name:
     P ChkGenNam       B
     D                 Pi              n
     D  PxGenNam                     10a   Value
     D  PxChkNam                     10a   Value
 
      /Free
 
        If  PxGenNam <> *Blanks  And  PxChkNam <> *Blanks;
 
          If  %Scan( '*': PxGenNam ) = *Zero;
 
            If  PxGenNam = PxChkNam;
              Return  *On;
            EndIf;
 
          Else;
            If  %Scan( %TrimR( PxGenNam: ' *'): PxChkNam ) = 1;
              Return  *On;
            EndIf;
 
          EndIf;
        EndIf;
 
        Return  *Off;
 
      /End-Free
 
     P ChkGenNam       E
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
     **-- Get user creator:
     P GetUsrCrt       B                   Export
     D                 Pi            10a
     D  PxUsrPrf                     10a   Value
 
     D OBJD0300        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  ObjCrt                       10a   Overlay( OBJD0300: 220 )
 
      /Free
 
        RtvObjD( OBJD0300
               : %Size( OBJD0300 )
               : 'OBJD0300'
               : PxUsrPrf + 'QSYS'
               : '*USRPRF'
               : ERRC0100
               );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  *Blanks;
 
        Else;
          Return  OBJD0300.ObjCrt;
        EndIf;
 
      /End-Free
 
     P GetUsrCrt       E
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
     **-- Send UIM completion message:
     P SndUimMsg       B
     D                 Pi             4a
     D  PxMsgId                       7a   Const
     D  PxMsgFil_q                   20a   Const           Options( *Omit )
     D  PxMsgDta                    512a   Const  Varying  Options( *Omit )
     **
     D MsgKey          s              4a
     D MsgFil_q        s             20a
     D MsgDta          s            512a   Varying
 
      /Free
 
        If  %Addr( PxMsgFil_q ) = *Null;
          MsgFil_q = 'QCPFMSG   *LIBL';
        Else;
          MsgFil_q = PxMsgFil_q;
        EndIf;
 
        If  %Addr( PxMsgDta ) = *Null;
          MsgDta = NULL;
        Else;
          MsgDta = PxMsgDta;
        EndIf;
 
        SndPgmMsg( PxMsgId
                 : MsgFil_q
                 : MsgDta
                 : %Len( MsgDta )
                 : '*COMP'
                 : '*'
                 : 1
                 : MsgKey
                 : ERRC0100
                 );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  *Loval;
 
        Else;
          Return  MsgKey;
        EndIf;
 
      /End-Free
 
     P SndUimMsg       E
     **-- Get system value:
     P GetSysVal       B                   Export
     D                 Pi          4096a   Varying
     D  PxSysVal                     10a   Const
 
     **-- Local variables:
     D Idx             s             10i 0
     D SysVal          s           4096a   Varying
     **
     D ApiPrm          Ds                  Qualified
     D  RtnVarLen                    10i 0
     D  SysValNbr                    10i 0 Inz( %Elem( ApiPrm.SysVal ))
     D  SysVal                       10a   Dim( 1 )
     **
     D RtnVar          Ds                  Qualified
     D  RtnVarNbr                    10i 0
     D  RtnVarOfs                    10i 0 Dim( %Elem( ApiPrm.SysVal ))
     D  RtnVarDta                  4096a
     **
     D SysValInf       Ds                  Qualified  Based( pSysVal )
     D  SysValKwd                    10a
     D  DtaTyp                        1a
     D  InfSts                        1a
     D  DtaLen                       10i 0
     D  Dta                        4096a
     D  DtaInt                       10i 0 Overlay( Dta )
 
      /Free
 
        ApiPrm.RtnVarLen = %Elem( ApiPrm.SysVal ) * 24 + %Size( SysVal ) + 4;
        ApiPrm.SysVal(1) = PxSysVal;
 
        RtvSysVal( RtnVar
                 : ApiPrm.RtnVarLen
                 : ApiPrm.SysValNbr
                 : ApiPrm.SysVal
                 : ERRC0100
                 );
 
        If  ERRC0100.BytAvl > *Zero;
          SysVal = NULL;
 
        Else;
          For  Idx = 1  to RtnVar.RtnVarNbr;
 
            pSysVal = %Addr( RtnVar ) + RtnVar.RtnVarOfs(Idx);
 
            If  SysValInf.SysValKwd = PxSysVal;
 
              Select;
              When  SysValInf.DtaTyp = 'C';
                SysVal = %Subst( SysValInf.Dta: 1: SysValInf.DtaLen );
 
              When  SysValInf.DtaTyp = 'B';
                SysVal = %Char( SysValInf.DtaInt );
 
              Other;
                SysVal = NULL;
              EndSl;
            EndIf;
 
          EndFor;
        EndIf;
 
        Return  SysVal;
 
      /End-Free
 
     P GetSysVal       E
