     **
     **  Program . . : CBX9951
     **  Description : Work with Routing Entries - CPP
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod   Module( CBX9951 )
     **                DbgView( *LIST )
     **
     **    CrtPgm      Pgm( CBX9951 )
     **                Module( CBX9951 )
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
     D USRSPC_Q        c                   'LSTRTGE   QTEMP'
     D EXT_ATR         c                   ' '
     D USP_SIZ         c                   65535
     D INZ_VAL         c                   x'00'
     D PUB_AUT         c                   '*CHANGE'
     D TXT_DSC         c                   ' '
     D USP_RPL         c                   '*YES'
     **
     D OFS_MSGDTA      c                   16
     **-- UIM constants:
     D PNLGRP_Q        c                   'CBX9951P  *LIBL     '
     D PNLGRP          c                   'CBX9951P  '
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
     D SysDts          s               z
 
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
 
     **-- UIM Panel exit program record:
     D ExpRcd          Ds                  Qualified
     D  ExitPg                       20a   Inz( 'CBX9951E  *LIBL' )
     **-- UIM Panel header record:
     D HdrRcd          Ds                  Qualified
     D  SysDat                        7a
     D  SysTim                        6a
     D  TimZon                       10a
     D  SbsNam                       10a
     D  SbsLib                       10a
     D  SbsSts                       10a
     **-- UIM List entry:
     D LstEnt          Ds                  Qualified  Inz
     D  Option                        5i 0
     D  SeqNbr                        4s 0
     D  RtgPgm_q                     20a
     D   RtgPgm                      10a   Overlay( RtgPgm_q: 1 )
     D   RtgPgmLib                   10a   Overlay( RtgPgm_q: *Next )
     D  RtgCls_q                     20a
     D   RtgCls                      10a   Overlay( RtgCls_q: 1 )
     D   RtgClsLib                   10a   Overlay( RtgCls_q: *Next )
     D  MaxActRtgStp                  5s 0
     D  RtgPoolId                     2s 0
     D  CmpPos                        2a
     D  CmpVal                       80a
     D  ThrRscAffGrp                  8a
     D  ThrRscAffLvl                  8a
     D  RscAffGrp                     5a
     **
     D LstEntPos       Ds                  LikeDs( LstEnt )
 
     **-- Subsystem entry information:
     D SBSE0100        Ds                  Qualified  Based( pLstEnt )
     D  SeqNbr                       10i 0
     D  RtgPgm_q                     20a
     D   RtgPgm                      10a   Overlay( RtgPgm_q:  1 )
     D   RtgPgmLib                   10a   Overlay( RtgPgm_q: *Next )
     D  RtgCls_q                     20a
     D   RtgCls                      10a   Overlay( RtgCls_q:  1 )
     D   RtgClsLib                   10a   Overlay( RtgCls_q: *Next )
     D  MaxActRtgStp                 10i 0
     D  RtgPoolId                    10i 0
     D  CmpPos                       10i 0
     D  CmpVal                       80a
     D  ThrRscAffGrp                 10a
     D  ThrRscAffLvl                 10a
     D  RscAffGrp                    10a
     **-- Subsystem information:
     D SBSI0100        Ds                  Qualified  Inz
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  SbsNam_q                     20a
     D   SbsNam                      10a   Overlay( SbsNam_q:  1 )
     D   SbsLib                      10a   Overlay( SbsNam_q: 11 )
     D  SbsSts                       10a
     D  SgnDevName                   10a
     D  SgnDevLib                    10a
     D  SecLngLib                    10a
     D  MaxActJob                    10i 0
     D  CurActJob                    10i 0
     D  NbrPools                     10i 0
     D  PoolInf                            Dim( 10 )
     D   PoolId                      10i 0 Overlay( PoolInf: 1 )
     D   PoolNam                     10a   Overlay( PoolInf: *Next )
     D                                6a   Overlay( PoolInf: *Next )
     D   PoolSiz                     10i 0 Overlay( PoolInf: *Next )
     D   PoolActLvl                  10i 0 Overlay( PoolInf: *Next )
 
     **-- User space generic header:
     D UsrSpcHdr       Ds                  Qualified  Based( pUsrSpc )
     D  OfsInpSec                    10i 0 Overlay( UsrSpcHdr: 109 )
     D  SizInpSec                    10i 0 Overlay( UsrSpcHdr: 113 )
     D  OfsHdrSec                    10i 0 Overlay( UsrSpcHdr: 117 )
     D  SizHdrSec                    10i 0 Overlay( UsrSpcHdr: 121 )
     D  OfsLstEnt                    10i 0 Overlay( UsrSpcHdr: 125 )
     D  NumLstEnt                    10i 0 Overlay( UsrSpcHdr: 133 )
     D  SizLstEnt                    10i 0 Overlay( UsrSpcHdr: 137 )
     **-- User space pointers:
     D pUsrSpc         s               *   Inz( *Null )
     D pHdrInf         s               *   Inz( *Null )
     D pLstEnt         s               *   Inz( *Null )
     **-- API input information:
     D ApiInpInf       Ds                  Qualified  Based( pInpInf )
     D  UsrSpcNamSpf                 10a
     D  UsrSpcLibSpf                 10a
     D  FmtNamSpf                     8a
     D  SbsNamSpf                    10a
     D  SbsLibSpf                    10a
     **-- API header information:
     D ApiHdrInf       Ds                  Qualified  Based( pHdrInf )
     D  SbsNamUsd                    10a
     D  SbsLibUsd                    10a
 
     **-- List subsystem entries:
     D LstSbsEnt       Pr                  ExtPgm( 'QWDLSBSE' )
     D  UsrSpc_Q                     20a   Const
     D  FmtNam                       10a   Const
     D  SbsNam_q                     20a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Retrieve subsystem information:
     D RtvSbsInf       Pr                  ExtPgm( 'QWDRSBSD' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                       10a   Const
     D  SbsNam_q                     20a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Create user space:
     D CrtUsrSpc       Pr                  ExtPgm( 'QUSCRTUS' )
     D  SpcNam_q                     20a   Const
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
     D  SpcNam_q                     20a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Retrieve pointer to user space:
     D RtvPtrSpc       Pr                  ExtPgm( 'QUSPTRUS' )
     D  SpcNam_q                     20a   Const
     D  Pointer                        *
     D  Error                     32767a          Options( *NoPass: *VarSize )
     **-- Send program message:
     D SndPgmMsg       Pr                  ExtPgm( 'QMHSNDPM' )
     D  MsgId                         7a   Const
     D  MsgFil_q                     20a   Const
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
     D CBX9951         Pr
     D  PxSbsNam_q                         LikeDs( ObjNam_q )
     **
     D CBX9951         Pi
     D  PxSbsNam_q                         LikeDs( ObjNam_q )
 
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
 
        CrtUsrSpc( USRSPC_Q
                 : EXT_ATR
                 : USP_SIZ
                 : INZ_VAL
                 : PUB_AUT
                 : TXT_DSC
                 : USP_RPL
                 : ERRC0100
                 );
 
        PutDlgVar( UIM.AppHdl: ExpRcd: %Size( ExpRcd ): 'EXPRCD': ERRC0100 );
 
        ExSr  BldHdrRcd;
        ExSr  BldRtgEntLst;
 
        DoU  UIM.FncRqs = FNC_EXIT  Or  UIM.FncRqs = FNC_CNL;
 
          DspPnl( UIM.AppHdl: UIM.FncRqs: PNLGRP: RDS_OPT_INZ: ERRC0100 );
 
          Select;
          When  ERRC0100.BytAvl > *Zero;
            ExSr  EscApiErr;
 
          When  UIM.FncRqs = RTN_ENTER;
            Leave;
          EndSl;
 
          GetDlgVar( UIM.AppHdl: HdrRcd: %Size( HdrRcd ): 'HDRRCD': ERRC0100 );
 
          If  UIM.FncRqs = KEY_F05  And  UIM.EntLocOpt = 'NEXT';
            ExSr  GetLstPos;
            ExSr  DltRtgEntLst;
          EndIf;
 
          If  UIM.FncRqs = KEY_F05;
            ExSr  BldRtgEntLst;
            ExSr  SetLstPos;
          EndIf;
 
          ExSr  BldHdrRcd;
        EndDo;
 
        CloApp( UIM.AppHdl: CLO_NORM: ERRC0100 );
 
        DltUsrSpc( USRSPC_Q: ERRC0100 );
 
        *InLr = *On;
        Return;
 
 
        BegSr  BldRtgEntLst;
 
          UIM.EntLocOpt = 'FRST';
 
          LstSbsEnt( USRSPC_Q: 'SBSE0100': PxSbsNam_q: ERRC0100 );
 
          If  ERRC0100.BytAvl = *Zero;
            ExSr  PrcUsrSpc;
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
 
        BegSr  PrcUsrSpc;
 
          RtvPtrSpc( USRSPC_Q: pUsrSpc );
 
          pInpInf = pUsrSpc + UsrSpcHdr.OfsInpSec;
          pHdrInf = pUsrSpc + UsrSpcHdr.OfsHdrSec;
          pLstEnt = pUsrSpc + UsrSpcHdr.OfsLstEnt;
 
          For  Idx = 1  to UsrSpcHdr.NumLstEnt;
 
            LstEnt.Option = *Zero;
 
            LstEnt.SeqNbr       = SBSE0100.SeqNbr;
            LstEnt.RtgPgm_q     = SBSE0100.RtgPgm_q;
            LstEnt.RtgCls_q     = SBSE0100.RtgCls_q;
            LstEnt.MaxActRtgStp = SBSE0100.MaxActRtgStp;
            LstEnt.RtgPoolId    = SBSE0100.RtgPoolId;
            LstEnt.CmpPos       = %Trim( %EditC( SBSE0100.CmpPos: 'Z' ));
            LstEnt.CmpVal       = SBSE0100.CmpVal;
 
            If  UsrSpcHdr.SizLstEnt >= %Size( SBSE0100 );
              LstEnt.ThrRscAffGrp = SBSE0100.ThrRscAffGrp;
              LstEnt.ThrRscAffLvl = SBSE0100.ThrRscAffLvl;
              LstEnt.RscAffGrp    = SBSE0100.RscAffGrp;
            EndIf;
 
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
                     : 'EQ        SEQNBR'
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
 
        BegSr  BldHdrRcd;
 
          SysDts = %Timestamp();
 
          HdrRcd.SysDat = %Char( %Date( SysDts ): *CYMD0 );
          HdrRcd.SysTim = %Char( %Time( SysDts ): *HMS0 );
          HdrRcd.TimZon = '*SYS';
 
          ExSr  GetSbsInf;
 
          HdrRcd.SbsNam    = SBSI0100.SbsNam;
          HdrRcd.SbsLib    = SBSI0100.SbsLib;
          HdrRcd.SbsSts    = SBSI0100.SbsSts;
 
          PutDlgVar( UIM.AppHdl: HdrRcd: %Size( HdrRcd ): 'HDRRCD': ERRC0100 );
 
        EndSr;
 
        BegSr  DltRtgEntLst;
 
          DltLst( UIM.AppHdl: 'DTLLST': ERRC0100 );
 
        EndSr;
 
        BegSr  GetSbsInf;
 
          RtvSbsInf( SBSI0100
                   : %Size( SBSI0100 )
                   : 'SBSI0100'
                   : PxSbsNam_q
                   : ERRC0100
                   );
 
          If  ERRC0100.BytAvl > *Zero;
            Reset  SBSI0100;
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
