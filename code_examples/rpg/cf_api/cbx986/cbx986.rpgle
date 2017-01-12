     **
     **  Program . . : CBX986
     **  Description : Work with Server Sessions - CCP
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod   Module( CBX986 )
     **                DbgView( *LIST )
     **
     **    CrtPgm      Pgm( CBX986 )
     **                Module( CBX986 )
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
     D OFS_MSGDTA      c                   16
     D MAX_ALLOC       c                   16776704
     D INZ_ALLOC       c                   65535
     D INC_ALLOC       c                   32767
     D DEV_ALL         c                   -1
     D DEV_FILE        c                   0
     D DEV_PRINT       c                   1
     D TYP_INTER       c                   'I'
     **
     D NBR_KEY         c                   1
     D KEY_OFS         c                   80
     D SIZ_NLS_INF     c                   290
     D JOB_RUN         c                   0
     D CHAR_NON_NLS    c                   6
     D ASCEND          c                   1
     D DESCEND         c                   2
     **
     D SRT_PUT         c                   1
     D SRT_END         c                   2
     D SRT_GET         c                   3
     D SRT_CNL         c                   4
     **-- UIM constants:
     D PNLGRP_Q        c                   'CBX986P   *LIBL     '
     D PNLGRP          c                   'CBX986P   '
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
     D SPLF_NAM        c                   'PSVRSSN'
     D SPLF_USRDTA     c                   'DWRKVRSSN'
     D EJECT_NO        c                   'N'
 
     **-- Global variables:
     D Idx             s             10i 0
     D ApiRcvSiz       s             10u 0
     D Path            s           1024a   Varying
     D SysDts          s               z
     D WrkStn          s             15a
     D WrkUsr          s             10a
     D SrtAct          s               n
 
     **-- Sort API parameters:
     D SrtApi          Ds                  Qualified  Inz
     D  DtaBufLen                    10i 0
     D  DtaRtnLen                    10i 0
     D  Omit                         16a
     **
     D RqsCtlBlk       Ds                  Qualified  Inz
     D  BlkLen                       10i 0
     D  RqsTyp                       10i 0 Inz( 8 )
     D                               10i 0
     D  Options                      10i 0
     D  RcdLen                       10i 0 Inz( %Size( LstEnt ))
     D  RcdCnt                       10i 0
     D  KeyOfs                       10i 0 Inz( KEY_OFS )
     D  KeyNbr                       10i 0
     D  NlsOfs                       10i 0
     D  InpFlsOfs                    10i 0
     D  InpFlsNbr                    10i 0
     D  OutFlsOfs                    10i 0
     D  OutFlsNbr                    10i 0
     D  KeyEntLen                    10i 0 Inz( %Size( SrtKeyInfDs ))
     D  NlsSsqLen                    10i 0 Inz( SIZ_NLS_INF )
     D  InpFenLen                    10i 0
     D  OutFenLen                    10i 0
     D  NlbMapOfs                    10i 0
     D  VlrAciOfs                    10i 0
     D                               10i 0
     **
     D SrtKeyInf                     20a   Dim( NBR_KEY )
     **
     D SrtTblQ                       20a   Inz( '*LANGIDSHR' )
     D SrtSeqCcsId                   10i 0 Inz( JOB_RUN )
     D SrtSeqLngId                   10a   Inz( '*JOBRUN' )
     D SrtSeqTbl                    256a
     **
     D SrtKeyInfDs     Ds                  Qualified  Inz
     D  KeyStrPos                    10i 0
     D  KeySize                      10i 0
     D  KeyDtaTyp                    10i 0
     D  KeyOrder                     10i 0
     D  KeyOrdPos                    10i 0
     **
     D RqsCtlBlkIo     Ds                  Qualified
     D  RqsTyp                       10i 0 Inz
     D                               10i 0 Inz
     D  RcdLen                       10i 0 Inz
     D  RcdCnt                       10i 0 Inz
     **
     D DtaBufInf       Ds                  Qualified
     D  RcdPrc                       10i 0
     D  RcdAvl                       10i 0 Inz( *Zero )
     D                                8a
 
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
 
     **-- Initialize sort:
     D InzSort         Pr                  ExtPgm( 'QLGSORT' )
     D  RqsCtlBlk                    80a   Const  Options( *VarSize )
     D  InpDtaBuf                 65535a   Const  Options( *VarSize )
     D  OutDtaBuf                 65535a          Options( *VarSize )
     D  OutDtaLen                    10i 0 Const
     D  RtnDtaLen                    10i 0
     D  Error                     32767a          Options( *VarSize )
     D  RtnRcdFb                    144a          Options( *VarSize: *NoPass )
     D  RtnRcdFbLen                  10i 0 Const  Options( *NoPass )
     **-- Sort input/output:
     D SortIo          Pr                  ExtPgm( 'QLGSRTIO' )
     D  RqsCtlBlk                    16a   Const
     D  InpDtaBuf                 65535a   Const  Options( *VarSize )
     D  OutDtaBuf                 65535a          Options( *VarSize )
     D  OutDtaLen                    10i 0 Const
     D  OutDtaInf                    16a
     D  Error                     32767a          Options( *VarSize )
     D  RtnRcdFb                    144a          Options( *VarSize: *NoPass )
     D  RtnRcdFbLen                  10i 0 Const  Options( *NoPass )
     **-- UIM Panel exit prgram record:
     D ExpRcd          Ds                  Qualified
     D  ExitPg                       20a   Inz( 'CBX986E   *LIBL' )
     **-- UIM Panel header record:
     D HdrRcd          Ds                  Qualified
     D  SysDat                        7a
     D  SysTim                        6a
     D  TimZon                       10a
     D  WrkStn                       15a
     D  WrkUsr                       10a
     D  PosStn                       15a
     **-- UIM List entry:
     D LstEnt          Ds                  Qualified
     D  Option                        5i 0
     D  WrkStn                       15a
     D  UsrPrf                       10a
     D  NbrCon                       10i 0
     D  FilOpn                       10i 0
     D  NbrSsn                       10i 0
     D  SsnTim                       10a
     D  SsnIdl                       10a
     D  LgoTyp                        1a
     D  EncPwd                        1a
     D  SsnId                        19p 0
     **
     D LstEntPos       Ds                  LikeDs( LstEnt )
 
     **-- List information:
     D LstInf          Ds                  Qualified
     D  RcdNbrTot                    10i 0
     D  RcdNbrRtn                    10i 0
     D  RcdLen                       10i 0
     D  InfLenRtn                    10i 0
     D  InfCmp                        1a
     D  Dts                          13a
     D                               34a   Inz( *Allx'00' )
     **-- List information:
     D ZLSL0300        Ds                  Qualified  Based( pZLSL0300 )
     D  WrkStn                       15a
     D  UsrPrf                       10a
     D                                3a
     D  NbrCon                       10i 0
     D  NbrFilOpn                    10i 0
     D  NbrSsn                       10i 0
     D  SsnTim                       10i 0
     D  SsnIdlTim                    10i 0
     D  LgoTyp                        1a
     D  EncPwd                        1a
     D                                6a
     D  SsnId                        20i 0
 
     **-- Open list of server information:
     D LstSvrInf       Pr                  ExtPgm( 'QZLSOLST' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  LstInf                       64a
     D  FmtNam                       10a   Const
     D  InfQual                      15a   Const
     D  Error                     32767a          Options( *VarSize )
     D  SsnUsr                       10a   Const  Options( *NoPass )
     D  SsnId                        20i 0 Const  Options( *NoPass )
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
 
     **-- Get job type:
     D GetJobTyp       Pr             1a
     **-- Format time string:
     D FmtTimStr       Pr            16a   Varying
     D  PxMicSec                     10i 0 Value
     **-- Send completion message:
     D SndCmpMsg       Pr            10i 0
     D  PxMsgDta                    512a   Const  Varying
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying
 
     D CBX986          Pr
     D  PxWrkStn                     15a
     D  PxUsrPrf                     10a
     D  PxOutOpt                      3a
     **
     D CBX986          Pi
     D  PxWrkStn                     15a
     D  PxUsrPrf                     10a
     D  PxOutOpt                      3a
 
      /Free
 
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
        ExSr  BldSsnLst;
 
        If  PxOutOpt = 'DSP'  And  GetJobTyp() = TYP_INTER;
          ExSr  DspLst;
        Else;
          ExSr  WrtLst;
        EndIf;
 
        CloApp( UIM.AppHdl: CLO_NORM: ERRC0100 );
 
        *InLr = *On;
        Return;
 
 
        BegSr  DspLst;
 
          DoU  UIM.FncRqs = FNC_EXIT  Or  UIM.FncRqs = FNC_CNL;
 
            DspPnl( UIM.AppHdl: UIM.FncRqs: PNLGRP: RDS_OPT_INZ: ERRC0100 );
 
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
              ExSr  DltSsnLst;
 
            When  WrkStn <> HdrRcd.WrkStn  Or  WrkUsr <> HdrRcd.WrkUsr;
              ExSr  DltSsnLst;
            EndSl;
 
            Select;
            When  UIM.FncRqs = KEY_F05;
              ExSr  RstHdrRcd;
              ExSr  BldSsnLst;
              ExSr  SetLstPos;
 
            When  WrkStn <> HdrRcd.WrkStn  Or  WrkUsr <> HdrRcd.WrkUsr;
              WrkStn = HdrRcd.WrkStn;
              WrkUsr = HdrRcd.WrkUsr;
 
              ExSr  BldSsnLst;
            EndSl;
 
            Select;
            When  UIM.FncRqs = RTN_ENTER  And
                  UIM.EntLocOpt = 'NEXT'  And
                  HdrRcd.PosStn > *Blanks;
 
              ExSr  FndLstPos;
 
            When  UIM.FncRqs = KEY_F17;
              ExSr  PosLstTop;
 
            When  UIM.FncRqs = KEY_F18;
              ExSr  PosLstBot;
            EndSl;
 
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
 
        BegSr  BldSsnLst;
 
          UIM.EntLocOpt = 'FRST';
 
          ApiRcvSiz = INZ_ALLOC;
          pZLSL0300 = %Alloc( ApiRcvSiz );
 
          DoU  LstInf.RcdNbrTot = LstInf.RcdNbrRtn  Or
               ERRC0100.BytAvl > *Zero;
 
            LstSvrInf( ZLSL0300
                     : ApiRcvSiz
                     : LstInf
                     : 'ZLSL0300'
                     : HdrRcd.WrkStn
                     : ERRC0100
                     : HdrRcd.WrkUsr
                     );
 
            If  LstInf.RcdNbrTot > LstInf.RcdNbrRtn;
 
              If  ApiRcvSiz + INC_ALLOC > MAX_ALLOC;
                Leave;
              Else;
                ApiRcvSiz += INC_ALLOC;
              EndIf;
 
              pZLSL0300  = %ReAlloc( pZLSL0300: ApiRcvSiz );
            EndIf;
          EndDo;
 
          If  ERRC0100.BytAvl = *Zero;
 
            For  Idx = 1  to LstInf.RcdNbrTot;
              ExSr  PrcLstEnt;
 
              If  Idx < LstInf.RcdNbrTot;
                pZLSL0300 += LstInf.RcdLen;
              EndIf;
            EndFor;
 
            ExSr  PutSrtLst;
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
 
          If  HdrRcd.WrkUsr = '*ALL'  Or  HdrRcd.WrkUsr = ZLSL0300.UsrPrf;
 
            LstEnt.Option = *Zero;
            LstEnt.WrkStn = ZLSL0300.WrkStn;
            LstEnt.UsrPrf = ZLSL0300.UsrPrf;
            LstEnt.NbrCon = ZLSL0300.NbrCon;
            LstEnt.FilOpn = ZLSL0300.NbrFilOpn;
            LstEnt.NbrSsn = ZLSL0300.NbrSsn;
            LstEnt.SsnTim = FmtTimStr( ZLSL0300.SsnTim );
            LstEnt.SsnIdl = FmtTimStr( ZLSL0300.SsnIdlTim );
            LstEnt.LgoTyp = ZLSL0300.LgoTyp;
            LstEnt.EncPwd = ZLSL0300.EncPwd;
            LstEnt.SsnId  = ZLSL0300.SsnId;
 
            ExSr  AddSrtLst;
          EndIf;
 
        EndSr;
 
        BegSr  AddSrtLst;
 
          If  SrtAct = *Off;
            ExSr  InzSrtLst;
          EndIf;
 
          RqsCtlBlkIo.RcdLen = RqsCtlBlk.RcdLen;
          RqsCtlBlkIo.RcdCnt = 1;
          RqsCtlBlkIo.RqsTyp = SRT_PUT;
 
          SortIo( RqsCtlBlkIo
                : LstEnt
                : SrtApi.Omit
                : SrtApi.DtaBufLen
                : DtaBufInf
                : ERRC0100
                );
 
        EndSr;
 
        BegSr  PutSrtLst;
 
          ExSr  EndSrtLst;
 
          If  DtaBufInf.RcdAvl > *Zero;
 
            RqsCtlBlkIo.RqsTyp = SRT_GET;
 
            SrtApi.DtaBufLen = RqsCtlBlkIo.RcdLen;
 
            SortIo( RqsCtlBlkIo
                  : SrtApi.Omit
                  : LstEnt
                  : SrtApi.DtaBufLen
                  : DtaBufInf
                  : ERRC0100
                  );
 
            DoW  DtaBufInf.RcdPrc > *Zero  And  ERRC0100.BytAvl = *Zero;
 
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
 
              If  DtaBufInf.RcdAvl <= *Zero;
                Leave;
              Else;
 
                SortIo( RqsCtlBlkIo
                      : SrtApi.Omit
                      : LstEnt
                      : SrtApi.DtaBufLen
                      : DtaBufInf
                      : ERRC0100
                      );
              EndIf;
            EndDo;
          EndIf;
 
        EndSr;
 
        BegSr  InzSrtLst;
 
          SrtKeyInfDs.KeySize   = %Size( LstEnt.WrkStn );
          SrtKeyInfDs.KeyDtaTyp = CHAR_NON_NLS;
          SrtKeyInfDs.KeyOrder  = ASCEND;
          SrtKeyInfDs.KeyStrPos = 3;
 
          RqsCtlBlk.SrtKeyInf(1) = SrtKeyInfDs;
 
          RqsCtlBlk.NlsOfs = KEY_OFS +
                             ( %Size( RqsCtlBlk.SrtKeyInf ) * NBR_KEY );
 
          RqsCtlBlk.BlkLen = KEY_OFS +
                             ( %Size( RqsCtlBlk.SrtKeyInf ) * NBR_KEY ) +
                             SIZ_NLS_INF;
 
          RqsCtlBlk.KeyNbr = NBR_KEY;
 
          InzSort( RqsCtlBlk
                 : SrtApi.Omit
                 : SrtApi.Omit
                 : SrtApi.DtaBufLen
                 : SrtApi.DtaRtnLen
                 : ERRC0100
                 );
 
          If  ERRC0100.BytAvl = *Zero;
            SrtAct = *On;
          EndIf;
 
        EndSr;
 
        BegSr  EndSrtLst;
 
          RqsCtlBlkIo.RqsTyp = SRT_END;
 
          SortIo( RqsCtlBlkIo
                : SrtApi.Omit
                : SrtApi.Omit
                : SrtApi.DtaBufLen
                : DtaBufInf
                : ERRC0100
                );
 
          If  ERRC0100.BytAvl = *Zero;
            SrtAct = *Off;
          EndIf;
 
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
                     : 'EQ        STNNAM'
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
 
          LstEnt.WrkStn = HdrRcd.PosStn;
 
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
                   : 'GE        STNNAM'
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
 
          When  %Scan( %Trim( HdrRcd.PosStn ): LstEnt.WrkStn ) <> 1;
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
 
          HdrRcd.PosStn = *Blanks;
 
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
 
          HdrRcd.WrkStn = WrkStn;
          HdrRcd.WrkUsr = WrkUsr;
          HdrRcd.PosStn = *Blanks;
 
        EndSr;
 
        BegSr  *InzSr;
 
          HdrRcd.WrkStn = PxWrkStn;
          HdrRcd.WrkUsr = PxUsrPrf;
          HdrRcd.PosStn = *Blanks;
 
          WrkStn = HdrRcd.WrkStn;
          WrkUsr = HdrRcd.WrkUsr;
 
        EndSr;
 
        BegSr  DltSsnLst;
 
          DltLst( UIM.AppHdl: 'DTLLST': ERRC0100 );
 
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
     **-- Format time string:
     P FmtTimStr       B
     D                 Pi            16a   Varying
     D  PxTimSec                     10i 0 Value
 
     **-- Local variables:
     D ClcHrs          s              4p 0
     D ClcMin          s              2p 0
     D ClcSec          s              2p 0
 
      /Free
 
        ClcHrs = %Div( PxTimSec: 3600 );
 
        If  ClcHrs > 0;
          PxTimSec = %Rem( PxTimSec: 3600 );
        EndIf;
 
        ClcMin = %Div( PxTimSec: 60 );
 
        If  ClcMin > 0;
          PxTimSec = %Rem( PxTimSec: 60 );
        EndIf;
 
        ClcSec = PxTimSec;
 
        Return  %EditC( ClcHrs: 'X' ) + ':' +
                %EditC( ClcMin: 'X' ) + ':' +
                %EditC( ClcSec: 'X' );
 
      /End-Free
 
     P FmtTimStr       E
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
