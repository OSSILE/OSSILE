     **
     **  Program . . : CBX982
     **  Description : Work with User Query Attributes - CPP
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod  Module( CBX982 )
     **               DbgView( *LIST )
     **
     **    CrtPgm     Pgm( CBX982 )
     **               Module( CBX982 )
     **               BndSrvPgm( CBX980 )
     **               ActGrp( *NEW )
     **
     **
     **-- Header specifications:  --------------------------------------------**
     H Option( *SrcStmt )
 
     **-- System information:
     D PgmSts         Sds                  Qualified
     D  PgmNam           *Proc
     D  JobNam                       10a   Overlay( PgmSts: 244 )
     D  UsrPrf                       10a   Overlay( PgmSts: 254 )
     D  JobNbr                        6a   Overlay( PgmSts: 264 )
     D  CurUsr                       10a   Overlay( PgmSts: 358 )
     **-- Api error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPro                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0 Inz
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      128a
 
     **-- Global constants:
     D LST_ALL         c                   -1
     D OFS_MSGDTA      c                   16
     D NULL            c                   ''
     **-- UIM constants:
     D PNLGRP_Q        c                   'CBX982P   *LIBL     '
     D PNLGRP          c                   'CBX982P   '
     D SCP_AUT_RCL     c                   -1
     D RDS_OPT_INZ     c                   'N'
     D PRM_IFC_0       c                   0
     D CLO_NORM        c                   'M'
     D FNC_EXIT        c                   -4
     D FNC_CNL         c                   -8
     D KEY_F05         c                   5
     D KEY_F24         c                   24
     D RTN_ENTER       c                   500
     D HLP_WDW         c                   'N'
     D POS_TOP         c                   'TOP'
     D POS_BOT         c                   'BOT'
     D LIST_COMP       c                   'ALL'
     D LIST_SAME       c                   'SAME'
     D EXIT_SAME       c                   '*SAME'
     D TRIM_SAME       c                   'S'
 
     **-- Global variables:
     D Idx             s             10i 0
     D MsgKey          s              4a
     D WrkUsr          s             10a
 
     **-- User query attributes application information:
     D UsrQryAtr       Ds                  Qualified
     D  FmtLen                       10i 0 Inz( %Size( UsrQryAtr ))
     D  FmtNam                        8a   Inz( 'QRYA0100' )
     D  Resv1                         4a
     D  QryIntLmt                    10i 0
     D  QryIntAlw                    10a
     D  QryOptLib                    10a
     D  Resv2                       216a   Inz
 
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
     **-- UIM Panel exit prgram buffer:
     D ExpBuf          Ds                  Qualified
     D  ExitPg                       20a   Inz( 'CBX982E   *LIBL' )
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
     D  QryUsr                       10a
     D  IntLmt                       10i 0
     D  IntAlw                       10a
     D  OptLib                       10a
     **
     D LstEntPos       Ds                  LikeDs( LstEnt )
     **-- List API parameters:
     D LstApi          Ds                  Qualified  Inz
     D  RtnRcdNbr                    10i 0
     D  GrpPrf                       10a
     D  UsrPrf                       10a
     D  SltCri                       10a
     **-- List information:
     D LstInf          Ds                  Qualified  Inz
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
     D AUTU0100        Ds                  Qualified
     D  UsrPrf                       10a
     D  UsrGrpI                       1a
     D  GrpMbrI                       1a
     **-- User information:
     D USRI0300        Ds                  Qualified
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
     D  PwdExpDat                     8a   Overlay( USRI0300:  61 )
     D  PwdExpI                       1a   Overlay( USRI0300:  73 )
     D  UsrCls                       10a   Overlay( USRI0300:  74 )
     D  SpcAut                       15a   Overlay( USRI0300:  84 )
     D  GrpPrf                       10a   Overlay( USRI0300:  99 )
     D  LmtCap                       10a   Overlay( USRI0300: 189 )
 
     **-- Open list of authorized users:
     D LstAutUsr       Pr                  ExtPgm( 'QGYOLAUS' )
     D  RcvVar                    65535a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  LstInf                       80a
     D  NbrRcdRtn                    10i 0 Const
     D  FmtNam                        8a   Const
     D  SltCri                       10a   Const
     D  GrpNam                       10a   Const
     D  Error                      1024a          Options( *VarSize )
     D  UsrPrf                       10a   Const  Options( *NoPass )
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
 
     **-- Verify user query attributes information:
     D VfyUsrQryA      Pr              n
     D  PxUsrPrf                     10a   Const
     **-- Get user query attributes information:
     D GetUsrQryA      Pr           256a
     D  PxUsrPrf                     10a   Const
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying
 
     **-- Program entry:
     D CBX982          Pr
     D  PxUsrPrf                     10a
     **
     D CBX982          Pi
     D  PxUsrPrf                     10a
 
      /Free
 
        OpnDspApp( UIM.AppHdl
                 : PNLGRP_Q
                 : SCP_AUT_RCL
                 : PRM_IFC_0
                 : HLP_WDW
                 : ERRC0100
                 );
 
        If  ERRC0100.BytAvl > *Zero;
          ExSr  EscApiErr;
        EndIf;
 
        PutDlgVar( UIM.AppHdl: ExpBuf: %Size( ExpBuf ): 'UIMEXP': ERRC0100 );
 
        ExSr  SetHdrTim;
        ExSr  BldUsrLst;
 
        DoU  UIM.FncRqs = FNC_EXIT  Or  UIM.FncRqs = FNC_CNL;
 
          DspPnl( UIM.AppHdl: UIM.FncRqs: PNLGRP: RDS_OPT_INZ: ERRC0100 );
 
          If  ERRC0100.BytAvl > *Zero;
            ExSr  EscApiErr;
          EndIf;
 
          GetDlgVar( UIM.AppHdl: HdrRcd: %Size( HdrRcd ): 'HDRRCD': ERRC0100 );
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
            ExSr  BldUsrLst;
            ExSr  SetLstPos;
 
          When  WrkUsr <> HdrRcd.WrkUsr;
            WrkUsr = HdrRcd.WrkUsr;
 
            ExSr  BldUsrLst;
          EndSl;
 
          If  UIM.FncRqs = RTN_ENTER  And
            UIM.EntLocOpt = 'NEXT'  And
            HdrRcd.PosUsr > *Blanks;
 
            ExSr  FndLstPos;
          EndIf;
 
 
          ExSr  SetHdrTim;
        EndDo;
 
        CloApp( UIM.AppHdl: CLO_NORM: ERRC0100 );
 
        *InLr = *On;
        Return;
 
 
        BegSr  BldUsrLst;
 
          UIM.EntLocOpt = 'FRST';
          LstApi.RtnRcdNbr = 1;
          LstApi.UsrPrf = HdrRcd.WrkUsr;
 
          LstAutUsr( AUTU0100
                   : %Size( AUTU0100 )
                   : LstInf
                   : LST_ALL
                   : 'AUTU0100'
                   : LstApi.SltCri
                   : LstApi.GrpPrf
                   : ERRC0100
                   : LstApi.UsrPrf
                   );
 
          If  ERRC0100.BytAvl = *Zero  And  LstInf.LstSts = '2';
 
            For  Idx = 1  To  LstInf.RcdNbrTot;
 
              ExSr  PrcLstEnt;
 
              LstApi.RtnRcdNbr += 1;
 
              GetOplEnt( AUTU0100
                       : %Size( AUTU0100 )
                       : LstInf.Handle
                       : LstInf
                       : 1
                       : LstApi.RtnRcdNbr
                       : ERRC0100
                       );
 
              If  ERRC0100.BytAvl > *Zero;
                Leave;
              EndIf;
 
            EndFor;
          EndIf;
 
          CloseLst( LstInf.Handle: ERRC0100 );
 
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
 
          If  VfyUsrQryA( AUTU0100.UsrPrf ) = *On;
            ExSr  PutLstEnt;
          EndIf;
 
        EndSr;
 
        BegSr  PutLstEnt;
 
          UsrQryAtr = GetUsrQryA( AUTU0100.UsrPrf );
 
          LstEnt.Option = *Zero;
          LstEnt.QryUsr = AUTU0100.UsrPrf;
          LstEnt.IntLmt = UsrQryAtr.QryIntLmt;
          LstEnt.IntAlw = UsrQryAtr.QryIntAlw;
          LstEnt.OptlIb = UsrQryAtr.QryOptLib;
 
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
 
        EndSr;
 
        BegSr  DltUsrLst;
 
          DltLst( UIM.AppHdl: 'DTLLST': ERRC0100 );
 
        EndSr;
 
        BegSr  SetHdrTim;
 
          HdrRcd.SysDat = %Char( %Date(): *CYMD0 );
          HdrRcd.SysTim = %Char( %Time(): *HMS0 );
          HdrRcd.TimZon = '*SYS';
 
          PutDlgVar( UIM.AppHdl: HdrRcd: %Size( HdrRcd ): 'HDRRCD': ERRC0100 );
 
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
                     : 'EQ        TMZUSR'
                     : LstAtr.DspPos
                     : 'N'
                     : UIM.EntHdl
                     : ERRC0100
                     );
 
            SetLstAtr( UIM.AppHdl
                     : 'DTLLST'
                     : LIST_SAME
                     : EXIT_SAME
                     : UIM.EntHdl
                     : TRIM_SAME
                     : ERRC0100
                     );
 
          EndIf;
 
        EndSr;
 
        BegSr  FndLstPos;
 
          LstEnt.QryUsr = HdrRcd.PosUsr;
 
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
                   : 'GE        QRYUSR'
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
 
          When  %Scan( %Trim( HdrRcd.PosUsr ): LstEnt.QryUsr ) <> 1;
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
 
        BegSr  RstHdrRcd;
 
          HdrRcd.WrkUsr = WrkUsr;
          HdrRcd.PosUsr = *Blanks;
 
        EndSr;
 
        BegSr  *InzSr;
 
          LstApi.SltCri = '*ALL';
          LstApi.GrpPrf = '*NONE';
 
          HdrRcd.WrkUsr = PxUsrPrf;
          HdrRcd.PosUsr = *Blanks;
 
          WrkUsr = HdrRcd.WrkUsr;
 
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
