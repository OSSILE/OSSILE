     **
     **  Program . . : CBX999
     **  Description : Work with Remote Output Queues - CPP
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **  Compile options:
     **    CrtRpgMod   Module( CBX999 )
     **                DbgView( *LIST )
     **
     **    CrtPgm      Pgm( CBX999 )
     **                Module( CBX999 )
     **                ActGrp( *NEW )
     **
     **-- Header specifications:  --------------------------------------------**
     H Option( *SrcStmt )
 
     **-- API error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      128a
 
     **-- Global constants:
     D USRSPC          c                   'LSTOTQ'
     D OFS_MSGDTA      c                   16
     D NULL            c                   ''
     **-- UIM constants:
     D PNLGRP_Q        c                   'CBX999P   *LIBL     '
     D PNLGRP          c                   'CBX999P   '
     D SCP_AUT_RCL     c                   -1
     D RDS_OPT_INZ     c                   'N'
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
     D SPLF_NAM        c                   'PRMTOUTQ'
     D SPLF_USRDTA     c                   'WRKRMTOUTQ'
     D EJECT_NO        c                   'N'
 
     **-- Global variables:
     D Idx             s             10i 0
     D SysDts          s               z
     D UsrSpc_q        s             20a
 
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
 
     **-- UIM Panel exit prgram record:
     D ExpRcd          Ds                  Qualified
     D  ExitPg                       20a   Inz( 'CBX999E   *LIBL' )
     **-- UIM Panel header record:
     D HdrRcd          Ds                  Qualified
     D  SysDat                        7a
     D  SysTim                        6a
     D  TimZon                       10a
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
     D  MsgQueNam                    10a
     D  MsgQueLib                    10a
     D  MsgKey                        4a
     **
     D LstEntPos       Ds                  LikeDs( LstEnt )
 
     **-- API header information:
     D ApiHdrInf       Ds                  Qualified  Based( pHdrInf )
     D  CfgDscTypUsd                 10a
     D  ObjQualUsd                   40a
     D  StsQualUsd                   20a
     D                                2a
     D  UsrSpcUsd                    10a
     D  SpcLibUsd                    10a
     **-- Object description format:
     D OBJL0100        Ds                  Qualified  Based( pLstEnt )
     D  ObjNam_q                     20a
     D   ObjNam                      10a   Overlay( ObjNam_q:  1 )
     D   ObjLib                      10a   Overlay( ObjNam_q: 11 )
     D  ObjTyp                       10a
     **-- Output queue information:
     D OUTQ0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  OutQue_q                     20a
     D   OutQueNam                   10a   Overlay( OutQue_q: 1 )
     D   OutQueLib                   10a   Overlay( OutQue_q: 11 )
     D  FilOrd                       10a
     D  DspAnyF                      10a
     D  JobSep                       10i 0
     D  OprCtl                       10a
     D  DtaQueNam                    10a
     D  DtaQueLib                    10a
     D  AutChk                       10a
     D  NbrFil                       10i 0
     D  OutQueSts                    10a
     D  WtrJobNam                    10a
     D  WtrJobUsr                    10a
     D  WtrJobNbr                     6a
     D  WtrJobSts                    10a
     D  PrtDevNam                    10a
     D  TxtDsc                       50a
     D                                2a
     D  NbrSpfPag                    10i 0
     D  NbrWtrStr                    10i 0
     D  WtrAutStr                    10i 0
     D  RmtSysNamTyp                  1a
     D  RmtSysNam                   255a
     D  RmtPrtQue                   128a
     D  MsgQueNam                    10a
     D  MsgQueLib                    10a
     D  CnnTyp                       10i 0
     D  DstTyp                       10i 0
     D  VmMvsCls                      1a
     D  FrmCtlBuf                     8a
     D  HstPrtTfr                     1a
     D  ManTypMod                    17a
     D  WksCusObj                    10a
     D  WksCusLib                    10a
     D  SpfAspAtr                     1a
     D  OfsMaxPagEnt                 10i 0
     D  NbrPagEntRtn                 10i 0
     D  LenMaxPagEnt                 10i 0
     D  DstOpt                      128a
     D  WtrTypStr                     1a
     D  PrtSepPag                     1a
     D  RmtPrtQueL                  255a
     D  ImgCfg                       10a
     D  ImgCfgLib                    10a
     D  NtwPubSts                     1a
     D                                2a
     D  SpfAspId                     10i 0
     D  SpfAspDevNam                 10a
     **-- Writer information format:
     D WTRI0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  StrUsrPrf                    10a
     D  WrtSts                        1a
     D  MsgWaitSts                    1a
     D  HldSts                        1a
     D  EndPndSts                     1a
     D  HldPndSts                     1a
     D  BtwFilSts                     1a
     D  BtwCpySts                     1a
     D  DtaWaitSts                    1a
     D  DevWaitSts                    1a
     D  OnJobqSts                     1a
     D  TypWtr                        1a
     D                                3a
     D  WtrJobNam                    10a
     D  WtrJobUsrPrf                 10a
     D  WtrJobNbr                     6a
     D  PrtDevTyp                    10a
     D  NbrSep                       10i 0
     D  DrwSep                       10i 0
     D  AlgForm                      10a
     D  OutQueNam                    10a
     D  OutQueLib                    10a
     D  OutQueSts                     1a
     D                                1a
     D  FrmTyp                       10a
     D  MsgOpt                       10a
     D  AutEntWtr                    10a
     D  AlwDirPrt                    10a
     D  MsgQueNam                    10a
     D  MsgQueLib                    10a
     D                                2a
     D  ChgEfc                       10a
     D  NxtOutQueNam                 10a
     D  NxtOutQueLib                 10a
     D  NxtFrmTyp                    10a
     D  NxtMsgOpt                    10a
     D  NxtFilSep                    10i 0
     D  NxtSepDrw                    10i 0
     D  SplFilNam                    10a
     D  JobNam                       10a
     D  UsrPrf                       10a
     D  JobNbr                        6a
     D  SplFilNbr                    10i 0
     D  PagWrt                       10i 0
     D  PagTot                       10i 0
     D  CpyLeft                      10i 0
     D  CpyTot                       10i 0
     D  MsgKey                        4a
     D  InzPrt                        1a
     D  PrtDevNam                    10a
     D  JobSysNam                     8a
     D  SpfCrtDat                     7a
     D  SpfCrtTim                     6a
 
     **-- User space generic header:
     D UsrSpcHdr       Ds                  Qualified  Based( pUsrSpc )
     D  OfsHdr                       10i 0 Overlay( UsrSpcHdr: 117 )
     D  OfsLst                       10i 0 Overlay( UsrSpcHdr: 125 )
     D  NumLstEnt                    10i 0 Overlay( UsrSpcHdr: 133 )
     D  SizLstEnt                    10i 0 Overlay( UsrSpcHdr: 137 )
     **-- User space pointers:
     D pUsrSpc         s               *   Inz( *Null )
     D pHdrInf         s               *   Inz( *Null )
     D pLstEnt         s               *   Inz( *Null )
 
     **-- Create user space:
     D CrtUsrSpc       Pr                  ExtPgm( 'QUSCRTUS' )
     D  SpcNamQ                      20a   Const
     D  ExtAtr                       10a   Const
     D  InzSiz                       10i 0 Const
     D  InzVal                        1a   Const
     D  PubAut                       10a   Const
     D  Text                         50a   Const
     D  Replace                      10a   Const  Options( *NoPass )
     D  Error                     32767a          Options( *NoPass: *VarSize )
     D  Domain                       10a   Const  Options( *NoPass )
     **-- Delete user space:
     D DltUsrSpc       Pr                  ExtPgm( 'QUSDLTUS' )
     D  SpcNamQ                      20a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Retrieve pointer to user space:
     D RtvPtrSpc       Pr                  ExtPgm( 'QUSPTRUS' )
     D  SpcNamQ                      20a   Const
     D  Pointer                        *
     D  Error                     32767a          Options( *NoPass: *VarSize )
     **-- List objects:
     D LstObj          Pr                  ExtPgm( 'QUSLOBJ' )
     D  SpcNam_q                     20a   Const
     D  FmtNam                        8a   Const
     D  ObjNam_q                     20a   Const
     D  ObjTyp                       10a   Const
     D  Error                     32767a          Options( *NoPass: *VarSize )
     D  AutCtl                      238a   Const  Options( *NoPass: *VarSize )
     D  SltCtl                       25a   Const  Options( *NoPass: *VarSize )
     D  AspCtl                       24a   Const  Options( *NoPass: *VarSize )
     **-- Retrieve writer information:
     D RtvWtrInf       Pr                  ExtPgm( 'QSPRWTRI' )
     D  RcvVar                    65535a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  PrtNam                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     D  WtrNam                       10a   Const  Options( *NoPass )
     **-- Retrieve device description:
     D RtvDevDsc       Pr                  ExtPgm( 'QDCRDEVD' )
     D  RcvVar                    65535a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  DevNam                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Retrieve output queue information:
     D RtvOutQueInf    Pr                  ExtPgm( 'QSPROUTQ' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  OutQue_q                     20a   Const
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
     **-- Retrieve job information:
     D RtvJobInf       Pr                  ExtPgm( 'QUSRJOBI' )
     D  RcvVar                    32767a         Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  JobNamQ                      26a   Const
     D  JobIntId                     16a   Const
     D  Error                     32767a         Options( *NoPass: *VarSize )
     **-- Retrieve call stack:
     D RtvCalStk       Pr                  ExtPgm( 'QWVRCSTK' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  RcvInfFmt                     8a   Const
     D  JobId                        56a   Const
     D  JobIdFmt                      8a   Const
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
 
     **-- Get job type:
     D GetJobTyp       Pr             1a
     **-- Get invocation level:
     D GetInvLvl       Pr             4a
     **-- Get output queue status:
     D GetOutQueSts    Pr             1a
     D  PxOutQue_q                   20a   Const
     **-- Send completion message:
     D SndCmpMsg       Pr            10i 0
     D  PxMsgDta                    512a   Const  Varying
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying
 
     **-- Entry parameters:
     D ObjNam_q        Ds
     D  ObjNam                       10a
     D  ObjLib                       10a
     **
     D CBX999          Pr
     D  PxRmtOutQue_q                      LikeDs( ObjNam_q )
     D  PxOutOpt                      3a
     **
     D CBX999          Pi
     D  PxRmtOutQue_q                      LikeDs( ObjNam_q )
     D  PxOutOpt                      3a
 
      /Free
 
        If  PxOutOpt = 'DSP'  And  GetJobTyp() = 'I';
 
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
 
          If  ERRC0100.BytAvl < OFS_MSGDTA;
            ERRC0100.BytAvl = OFS_MSGDTA;
          EndIf;
 
          SndEscMsg( ERRC0100.MsgId
                   : 'QCPFMSG'
                   : %Subst( ERRC0100.MsgDta: 1: ERRC0100.BytAvl - OFS_MSGDTA )
                   );
        EndIf;
 
        PutDlgVar( UIM.AppHdl: ExpRcd: %Size( ExpRcd ): 'EXPRCD': ERRC0100 );
 
        ExSr  BldWtrLst;
        ExSr  BldHdrRcd;
 
        If  PxOutOpt = 'DSP'  And  GetJobTyp() = 'I';
          ExSr  DspLst;
        Else;
          ExSr  WrtLst;
        EndIf;
 
        CloApp( UIM.AppHdl: CLO_NORM: ERRC0100 );
 
        DltUsrSpc( UsrSpc_q: ERRC0100 );
 
        *InLr = *On;
        Return;
 
 
        BegSr  DspLst;
 
          DoU  UIM.FncRqs = FNC_EXIT  Or  UIM.FncRqs = FNC_CNL;
 
            DspPnl( UIM.AppHdl: UIM.FncRqs: PNLGRP: RDS_OPT_INZ: ERRC0100 );
 
            Select;
            When  UIM.FncRqs = RTN_ENTER;
              Leave;
 
            When  UIM.FncRqs = KEY_F17;
              ExSr  PosLstTop;
 
            When  UIM.FncRqs = KEY_F18;
              ExSr  PosLstBot;
            EndSl;
 
          GetDlgVar( UIM.AppHdl: HdrRcd: %Size( HdrRcd ): 'HDRRCD': ERRC0100 );
 
          If  UIM.FncRqs = KEY_F05  And  UIM.EntLocOpt = 'NEXT';
            ExSr  GetLstPos;
            ExSr  DltWtrLst;
          EndIf;
 
          If  UIM.FncRqs = KEY_F05;
            ExSr  BldWtrLst;
            ExSr  SetLstPos;
          EndIf;
 
            ExSr  BldHdrRcd;
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
 
        BegSr  BldWtrLst;
 
          UIM.EntLocOpt = 'FRST';
 
          LstObj( UsrSpc_q
                : 'OBJL0100'
                : PxRmtOutQue_q
                : '*OUTQ'
                : ERRC0100
                );
 
          If  ERRC0100.BytAvl = *Zero;
            ExSr  PrcLstEnt;
 
          Else;
            If  ERRC0100.BytAvl < OFS_MSGDTA;
              ERRC0100.BytAvl = OFS_MSGDTA;
            EndIf;
 
            SndEscMsg( ERRC0100.MsgId
                     : 'QCPFMSG'
                     : %Subst( ERRC0100.MsgDta
                             : 1
                             : ERRC0100.BytAvl - OFS_MSGDTA
                             ));
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
 
          RtvPtrSpc( UsrSpc_q: pUsrSpc );
 
          pHdrInf = pUsrSpc + UsrSpcHdr.OfsHdr;
          pLstEnt = pUsrSpc + UsrSpcHdr.OfsLst;
 
          For  Idx = 1  to UsrSpcHdr.NumLstEnt;
 
            RtvOutQueInf( OUTQ0100
                        : %Size( OUTQ0100 )
                        : 'OUTQ0100'
                        : OBJL0100.ObjNam_q
                        : ERRC0100
                        );
 
            If  ERRC0100.BytAvl = *Zero   And
                OUTQ0100.CnnTyp > *Zero;
 
              If  OUTQ0100.WtrJobNam > *Blanks;
 
                RtvWtrInf( WTRI0100
                         : %Size( WTRI0100 )
                         : 'WTRI0100'
                         : '*WRITER'
                         : ERRC0100
                         : OUTQ0100.WtrJobNam
                         );
 
                Select;
                When  ERRC0100.BytAvl > *Zero      And
                     (ERRC0100.MsgId  = 'CPF3313'  Or
                      ERRC0100.MsgId  = 'CPF33C8');
                  LstEnt.WtrSts = 'END';
 
                When  ERRC0100.BytAvl > *Zero;
                  LstEnt.WtrSts = 'ERR';
 
                Other;
                  LstEnt.WtrSts = 'STR';
                EndSl;
              Else;
 
                LstEnt.WtrSts = 'END';
              EndIf;
 
              LstEnt.Option    = *Zero;
              LstEnt.RmtOutQue = OUTQ0100.OutQueNam;
              LstEnt.TxtDsc    = OUTQ0100.TxtDsc;
              LstEnt.WtrNam    = OUTQ0100.WtrJobNam;
              LstEnt.UsrPrf    = OUTQ0100.WtrJobUsr;
              LstEnt.JobNbr    = OUTQ0100.WtrJobNbr;
              LstEnt.MsgQueNam = OUTQ0100.MsgQueNam;
              LstEnt.MsgQueLib = OUTQ0100.MsgQueLib;
              LstEnt.RmtSysNam = OUTQ0100.RmtSysNam;
              LstEnt.RmtPrtQue = OUTQ0100.RmtPrtQueL;
              LstEnt.OutQueNam = OUTQ0100.OutQueNam;
              LstEnt.OutQueLib = OUTQ0100.OutQueLib;
              LstEnt.DstTyp    = OUTQ0100.DstTyp;
              LstEnt.DstOpt    = OUTQ0100.DstOpt;
              LstEnt.ManTypMod = OUTQ0100.ManTypMod;
              LstEnt.HstPrtTfr = OUTQ0100.HstPrtTfr;
              LstEnt.WksCusObj = OUTQ0100.WksCusObj;
              LstEnt.WksCusLib = OUTQ0100.WksCusLib;
 
              If  LstEnt.WtrSts = 'STR';
                LstEnt.StrUsrPrf  = WTRI0100.StrUsrPrf;
                LstEnt.WrtSts     = WTRI0100.WrtSts;
                LstEnt.OutQueNam  = WTRI0100.OutQueNam;
                LstEnt.OutQueLib  = WTRI0100.OutQueLib;
                LstEnt.OutQueSts  = WTRI0100.OutQueSts;
                LstEnt.FrmTyp     = WTRI0100.FrmTyp;
                LstEnt.MsgOpt     = WTRI0100.MsgOpt;
                LstEnt.MsgWaitSts = WTRI0100.MsgWaitSts;
                LstEnt.MsgQueNam  = WTRI0100.MsgQueNam;
                LstEnt.MsgQueLib  = WTRI0100.MsgQueLib;
                LstEnt.MsgKey     = WTRI0100.MsgKey;
 
                Select;
                When  WTRI0100.MsgWaitSts = 'Y';
                  LstEnt.WtrSts = 'MSGW';
                When  WTRI0100.HldSts     = 'Y';
                  LstEnt.WtrSts = 'HLD';
                When  WTRI0100.OnJobqSts  = 'Y';
                  LstEnt.WtrSts = 'JOBQ';
                EndSl;
              Else;
                LstEnt.OutQueSts  = GetOutQueSts( LstEnt.OutQueNam +
                                                  LstEnt.OutQueLib
                                                );
              EndIf;
 
              LstEnt.OutQueWrk  = %TrimR( %Subst( LstEnt.OutQueNam: 1: 9 ))
                                  + '*';
 
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
 
              Reset  LstEnt;
            EndIf;
 
            If  Idx < UsrSpcHdr.NumLstEnt;
              pLstEnt += UsrSpcHdr.SizLstEnt;
            EndIf;
          EndFor;
 
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
                     : 'EQ        RMTOTQ'
                     : LstAtr.DspPos
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
 
        BegSr  *InzSr;
 
          UsrSpc_q = USRSPC + GetInvLvl() + 'QTEMP';
 
          CrtUsrSpc( UsrSpc_q
                   : *Blanks
                   : 65535
                   : x'00'
                   : '*CHANGE'
                   : *Blanks
                   : '*NO'
                   : ERRC0100
                   );
 
        EndSr;
 
        BegSr  DltWtrLst;
 
          DltLst( UIM.AppHdl: 'DTLLST': ERRC0100 );
 
        EndSr;
 
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
     **-- Get invocation level:
     P GetInvLvl       B
     D                 Pi             4a
     **
     D CSTK0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  NbrStkE                      10i 0
     **
     D JobId           Ds                  Qualified
     D  JobNam                       10a   Inz( '*' )
     D  UsrNam                       10a
     D  JobNbr                        6a
     D  IntId                        16a
     D  Rsv                           2a   Inz( *Allx'00' )
     D  ThrInd                       10i 0 Inz( 1 )
     D  ThrId                         8a   Inz( *Allx'00' )
     **
     D CUR_INVLVL      c                   1
 
      /Free
 
        CallP  RtvCalStk( CSTK0100
                        : %Size( CSTK0100 )
                        : 'CSTK0100'
                        : JobId
                        : 'JIDF0100'
                        : ERRC0100
                        );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  '0000';
        Else;
          Return  %EditC( %Dec( CSTK0100.NbrStkE - CUR_INVLVL: 4: 0 ): 'X' );
        EndIf;
 
      /End-Free
 
     P GetInvLvl       E
     **-- Get output queue status:
     P GetOutQueSts    B
     D                 Pi             1a
     D  PxOutQue_q                   20a   Const
 
     **-- Output queue information:
     D OUTQ0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  OutQue_q                     20a
     D   OutQueNam                   10a   Overlay( OutQue_q: 1 )
     D   OutQueLib                   10a   Overlay( OutQue_q: 11 )
     D  FilOrd                       10a
     D  DspAnyF                      10a
     D  JobSep                       10i 0
     D  OprCtl                       10a
     D  DtaQueNam                    10a
     D  DtaQueLib                    10a
     D  AutChk                       10a
     D  NbrFil                       10i 0
     D  OutQueSts                    10a
     D  WtrJobNam                    10a
     D  WtrJobUsr                    10a
     D  WtrJobNbr                     6a
     D  WtrJobSts                    10a
     D  PrtDevNam                    10a
     D  OutQueTxt                    50a
     D                                2a
     D  NbrSpfPag                    10i 0
     D  NbrWtrStr                    10i 0
     D  WtrAutStr                    10i 0
 
      /Free
 
        RtvOutQueInf( OUTQ0100
                    : %Size( OUTQ0100 )
                    : 'OUTQ0100'
                    : PxOutQue_q
                    : ERRC0100
                    );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  *Blank;
 
        Else;
          Return  %Subst( OUTQ0100.OutQueSts: 1: 1 );
        EndIf;
 
      /End-Free
 
     P GetOutQueSts    E
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
          Return   0;
        EndIf;
 
      /End-Free
 
     P SndEscMsg       E
