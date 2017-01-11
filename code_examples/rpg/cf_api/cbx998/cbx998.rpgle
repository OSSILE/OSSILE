     **
     **  Program . . : CBX998
     **  Description : Work with Subsystem Entries - CPP
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod   Module( CBX998 )
     **                DbgView( *LIST )
     **
     **    CrtPgm      Pgm( CBX998 )
     **                Module( CBX998 )
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
     **
     D BIN_SGN         c                   0
     D NUM_ZON         c                   2
     D CHAR_NLS        c                   4
     D SORT_ASC        c                   '1'
     **-- UIM constants:
     D PNLGRP_Q        c                   'CBX998P   *LIBL     '
     D PNLGRP          c                   'CBX998P   '
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
     D NbrSbs          s             10i 0 Inz
     D SbsLst          s             20a   Dim( 2000 )
     D ExcLib          s             10a   Varying
     D ExcLibLen       s             10i 0
 
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
     D  ExitPg                       20a   Inz( 'CBX998E   *LIBL' )
     **-- UIM Panel header record:
     D HdrRcd          Ds                  Qualified
     D  SysDat                        7a
     D  SysTim                        6a
     D  TimZon                       10a
     D  SbsNam                       10a
     D  SbsLib                       10a
     D  ExcLib                       10a
     **-- UIM List entry:
     D LstEnt          Ds                  Qualified
     D  Option                        5i 0
     D  SbsPos                       20a
     D  SbsNam                       10a
     D  SbsLib                       10a
     D  SbsExtSts                    12a
     D  MaxActJob                     7s 0
     D  CurActJob                     7s 0
     D  JobOnQue                      7s 0
     D  SbsMonJob                    10a
     D  SbsMonUsr                    10a
     D  SbsMonNbr                     6a
     D  SbsDsc                       50a
     **
     D LstEntPos       Ds                  LikeDs( LstEnt )
 
     **-- List API parameters:
     D LstApi          Ds                  Qualified  Inz
     D  RtnRcdNbr                    10i 0 Inz( 1 )
     D  NbrKeyRtn                    10i 0 Inz( *Zero )
     D  KeyFld                       10i 0 Dim( 1 )
 
     **-- Object information:
     D ObjInf          Ds          4096    Qualified
     D  ObjNam_q                     20a
     D   ObjNam                      10a   Overlay( ObjNam_q: 1 )
     D   ObjLib                      10a   Overlay( ObjNam_q: *Next )
     D  ObjTyp                       10a
     D  InfSts                        1a
     D                                1a
     D  FldNbrRtn                    10i 0
     D  Data                               Like( KeyInf )
     **-- Key information:
     D KeyInf          Ds                  Qualified  Based( pKeyInf )
     D  FldInfLen                    10i 0
     D  KeyFld                       10i 0
     D  DtaTyp                        1a
     D                                3a
     D  DtaLen                       10i 0
     D  Data                        256a
     **-- Authority control:
     D AutCtl          Ds                  Qualified
     D  AutFmtLen                    10i 0 Inz( %Size( AutCtl ))
     D  CalLvl                       10i 0 Inz( 0 )
     D  DplObjAut                    10i 0 Inz( 0 )
     D  NbrObjAut                    10i 0 Inz( 0 )
     D  DplLibAut                    10i 0 Inz( 0 )
     D  NbrLibAut                    10i 0 Inz( 0 )
     D                               10i 0 Inz( 0 )
     D  ObjAut                       10a   Dim( 10 )
     D  LibAut                       10a   Dim( 10 )
     **-- Selection control:
     D SltCtl          Ds
     D  SltFmtLen                    10i 0 Inz( %Size( SltCtl ))
     D  SltOmt                       10i 0 Inz( 0 )
     D  DplSts                       10i 0 Inz( 20 )
     D  NbrSts                       10i 0 Inz( 1 )
     D                               10i 0 Inz( 0 )
     D  Status                        1a   Inz( '*' )
     **-- Subsystem information:
     D SBSI0200        Ds         65535    Qualified  Inz
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  OfsSbsEnt                    10i 0
     D  NbrSbsEnt                    10i 0
     D  SizSbsEnt                    10i 0
     **
     D SbsEnt          Ds                  Qualified  Based( pSbsEnt )
     D  SbsNam_q                     20a
     D   SbsNam                      10a   Overlay( SbsNam_q:  1 )
     D   SbsLib                      10a   Overlay( SbsNam_q: 11 )
     D  SbsExtSts                    12a
     D  MaxActJob                    10i 0
     D  CurActJob                    10i 0
     D  SbsMonJob                    10a
     D  SbsMonUsr                    10a
     D  SbsMonNbr                     6a
     D  SbsDsc                       50a
     **-- Sort information:
     D SrtInf          Ds                  Qualified
     D  NbrKeys                      10i 0 Inz( 4 )
     D  SrtStr                       12a   Dim( 4 )
     D   KeyFldOfs                   10i 0 Overlay( SrtStr:  1 )
     D   KeyFldLen                   10i 0 Overlay( SrtStr:  5 )
     D   KeyFldTyp                    5i 0 Overlay( SrtStr:  9 )
     D   SrtOrd                       1a   Overlay( SrtStr: 11 )
     D   Rsv                          1a   Overlay( SrtStr: 12 )
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
 
     **-- Open list of objects:
     D LstObjs         Pr                  ExtPgm( 'QGYOLOBJ' )
     D  RcvVar                    65535a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  LstInf                       80a
     D  NbrRcdRtn                    10i 0 Const
     D  SrtInf                     1024a   Const  Options( *VarSize )
     D  ObjNam_q                     20a   Const
     D  ObjTyp                       10a   Const
     D  AutCtl                     1024a   Const  Options( *VarSize )
     D  SltCtl                     1024a   Const  Options( *VarSize )
     D  NbrKeyRtn                    10i 0 Const
     D  KeyFld                       10i 0 Const  Options( *VarSize )  Dim( 32 )
     D  Error                      1024a          Options( *VarSize )
     **
     D  JobIdInf                    256a          Options( *NoPass: *VarSize )
     D  JobIdFmt                      8a   Const  Options( *NoPass )
     **
     D  AspCtl                      256a          Options( *NoPass: *VarSize )
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
     **-- Retrieve subsystem information:
     D RtvSbsInf       Pr                  ExtPgm( 'QWDRSBSD' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                       10a   Const
     D  SbsNam_q                     20a   Const  Options( *VarSize )
     D                                            Dim( 2000 )
     D  Error                     32767a          Options( *VarSize )
     D  NbrSbs                       10i 0 Const  Options( *NoPass )
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
 
     **-- Get jobs on queue:
     D GetJobOnQue     Pr            10i 0
     D  PxActSbs                     10a   Const
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
     D CBX998          Pr
     D  PxSbsNam_q                         LikeDs( ObjNam_q )
     D  PxExcLib                     10a
     **
     D CBX998          Pi
     D  PxSbsNam_q                         LikeDs( ObjNam_q )
     D  PxExcLib                     10a
 
      /Free
 
        OpnDspApp( UIM.AppHdl
                 : PNLGRP_Q
                 : SCP_AUT_RCL
                 : PRM_IFC_0
                 : HLP_WDW
                 : ERRC0100
                 );
 
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
 
        ExSr  BldHdrRcd;
        ExSr  BldSbsLst;
 
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
            ExSr  DltUsrLst;
          EndIf;
 
          If  UIM.FncRqs = KEY_F05;
            ExSr  BldSbsLst;
            ExSr  SetLstPos;
          EndIf;
 
          ExSr  BldHdrRcd;
        EndDo;
 
        CloApp( UIM.AppHdl: CLO_NORM: ERRC0100 );
 
        *InLr = *On;
        Return;
 
 
        BegSr  BldSbsLst;
 
          If  PxSbsNam_q.ObjNam = '*ALL'  Or
              PxSbsNam_q.ObjLib = '*ALL'  Or
              %Scan( '*': PxSbsNam_q.ObjNam: 2 ) >= 2;
            ExSr  LodSbsLst;
          Else;
            ExSr  LodSbsSng;
          EndIf;
 
          UIM.EntLocOpt = 'FRST';
 
          RtvSbsInf( SBSI0200
                   : %Size( SBSI0200 )
                   : 'SBSI0200'
                   : SbsLst
                   : ERRC0100
                   : NbrSbs
                   );
 
          If  ERRC0100.BytAvl = *Zero;
            pSbsEnt = %Addr( SBSI0200 ) + SBSI0200.OfsSbsEnt;
 
            For  Idx = 1  to  SBSI0200.NbrSbsEnt;
              ExSr  PrcLstEnt;
 
              If  Idx < SBSI0200.NbrSbsEnt;
                pSbsEnt += SBSI0200.SizSbsEnt;
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
 
        BegSr  LodSbsSng;
 
          NbrSbs = 1;
          SbsLst(NbrSbs) = PxSbsNam_q;
 
        EndSr;
 
        BegSr  LodSbsLst;
 
          ExSr  InzApiPrm;
 
          LstApi.RtnRcdNbr = 1;
 
          LstObjs( ObjInf
                 : %Size( ObjInf )
                 : LstInf
                 : -1
                 : SrtInf
                 : PxSbsNam_q
                 : '*SBSD'
                 : AutCtl
                 : SltCtl
                 : LstApi.NbrKeyRtn
                 : LstApi.KeyFld
                 : ERRC0100
                 );
 
          If  ERRC0100.BytAvl = *Zero  And  LstInf.RcdNbrRtn > *Zero;
            ExSr  AddSbsEnt;
 
            DoW  LstInf.RcdNbrTot > LstApi.RtnRcdNbr;
              LstApi.RtnRcdNbr += 1;
 
              GetOplEnt( ObjInf
                       : %Size( ObjInf )
                       : LstInf.Handle
                       : LstInf
                       : 1
                       : LstApi.RtnRcdNbr
                       : ERRC0100
                       );
 
              If  ERRC0100.BytAvl > *Zero;
                Leave;
              EndIf;
 
              ExSr  AddSbsEnt;
            EndDo;
          EndIf;
 
          CloseLst( LstInf.Handle: ERRC0100 );
        EndSr;
 
        BegSr  AddSbsEnt;
 
          If  ExcLib = *Blanks  Or  %Scan( ExcLib: ObjInf.ObjLib ) <> 1;
 
            If  NbrSbs < %Elem( SbsLst );
              NbrSbs += 1;
 
              SbsLst(NbrSbs) = ObjInf.ObjNam_q;
            EndIf;
          EndIf;
 
        EndSr;
 
        BegSr  PrcLstEnt;
 
          LstEnt.Option = *Zero;
 
          LstEnt.SbsPos    = SbsEnt.SbsNam_q;
          LstEnt.SbsNam    = SbsEnt.SbsNam;
          LstEnt.SbsLib    = SbsEnt.SbsLib;
          LstEnt.SbsExtSts = SbsEnt.SbsExtSts;
          LstEnt.MaxActJob = SbsEnt.MaxActJob;
          LstEnt.CurActJob = SbsEnt.CurActJob;
          LstEnt.SbsMonJob = SbsEnt.SbsMonJob;
          LstEnt.SbsMonUsr = SbsEnt.SbsMonUsr;
          LstEnt.SbsMonNbr = SbsEnt.SbsMonNbr;
          LstEnt.SbsDsc    = SbsEnt.SbsDsc;
 
          If  SbsEnt.SbsExtSts = '*ACTIVE';
            LstEnt.JobOnQue = GetJobOnQue( SbsEnt.SbsNam );
          Else;
            LstEnt.JobOnQue = -1;
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
                     : 'EQ        SBSPOS'
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
          HdrRcd.SbsNam = PxSbsNam_q.ObjNam;
          HdrRcd.SbsLib = PxSbsNam_q.ObjLib;
          HdrRcd.ExcLib = PxExcLib;
 
          PutDlgVar( UIM.AppHdl: HdrRcd: %Size( HdrRcd ): 'HDRRCD': ERRC0100 );
 
        EndSr;
 
        BegSr  DltUsrLst;
 
          DltLst( UIM.AppHdl: 'DTLLST': ERRC0100 );
 
        EndSr;
 
        BegSr  InzApiPrm;
 
          SrtInf.NbrKeys   = 2;
 
          SrtInf.KeyFldOfs(1) = 1;
          SrtInf.KeyFldLen(1) = %Size( SbsEnt.SbsNam );
          SrtInf.KeyFldTyp(1) = CHAR_NLS;
          SrtInf.SrtOrd(1)    = SORT_ASC;
          SrtInf.Rsv(1)       = x'00';
 
          SrtInf.KeyFldOfs(2) = 11;
          SrtInf.KeyFldLen(2) = %Size( SbsEnt.SbsLib );
          SrtInf.KeyFldTyp(2) = CHAR_NLS;
          SrtInf.SrtOrd(2)    = SORT_ASC;
          SrtInf.Rsv(2)       = x'00';
 
          If  PxExcLib <> '*NONE';
            ExcLibLen = %Scan( '*': PxExcLib );
 
            If  ExcLibLen > 1;
              ExcLib = %Subst( PxExcLib: 1: ExcLibLen - 1 );
            Else;
              ExcLib = PxExcLib;
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
 
     **-- Get jobs on queue:
     P GetJobOnQue     B
     D                 Pi            10i 0
     D  PxActSbs                     10a   Const
     **
     **-- Job queue information:
     D OJBQ0100        Ds                  Qualified
     D  JobQue_q                     20a
     D   JobQueNam                   10a   Overlay( JobQue_q:  1 )
     D   JobQueLib                   10a   Overlay( JobQue_q: 11 )
     D  JobQueSts                     1a
     D  SbsNam_Q                     20a
     D   SbsNam                      10a   Overlay( SbsNam_q:  1 )
     D   SbsLib                      10a   Overlay( SbsNam_q: 11 )
     D                                3a
     D  NbrJobOnQue                  10i 0
     D  SeqNbr                       10i 0
     D  MaxAct                       10i 0
     D  CurAct                       10i 0
     D  QueDsc                       50a
     **-- Filter information:
     D FltInf          Ds                  Qualified
     D  FltInfLen                    10i 0 Inz( %Size( FltInf ))
     D  JobQue                       20a
     D   JobQueNam                   10a   Overlay( JobQue:  1 )
     D   JobQueLib                   10a   Overlay( JobQue: 11 )
     D  ActSbsNam                    10a
     **-- Sort information:
     D SrtInf          Ds                  Qualified
     D  NbrKeys                      10i 0 Inz( 0 )
     D  SrtStr                       12a   Dim( 1 )
     D   KeyFldOfs                   10i 0 Overlay( SrtStr:  1 )
     D   KeyFldLen                   10i 0 Overlay( SrtStr:  5 )
     D   KeyFldTyp                    5i 0 Overlay( SrtStr:  9 )
     D   SrtOrd                       1a   Overlay( SrtStr: 11 )
     D   Rsv                          1a   Overlay( SrtStr: 12 )
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
     **-- Open list of job queues:
     D LstJobQues      Pr                  ExtPgm( 'QSPOLJBQ' )
     D  RcvVar                    65535a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  LstInf                       80a
     D  FltInf                       32a   Const  Options( *VarSize )
     D  SrtInf                     1024a   Const  Options( *VarSize )
     D  NbrRcdRtn                    10i 0 Const
     D  Error                      1024a          Options( *VarSize )
     **
     D RtnRcdNbr       s             10i 0 Inz( 1 )
     D NbrJobOnQue     s             10i 0
 
      /Free
 
        FltInf.JobQue = '*ALLOCATED';
        FltInf.ActSbsNam = PxActSbs;
 
        LstJobQues( OJBQ0100
                  : %Size( OJBQ0100 )
                  : 'OJBQ0100'
                  : LstInf
                  : FltInf
                  : SrtInf
                  : -1
                  : ERRC0100
                  );
 
        Select;
        When  ERRC0100.BytAvl > *Zero;
          NbrJobOnQue = -1;
 
        When  LstInf.RcdNbrRtn > *Zero;
          NbrJobOnQue += OJBQ0100.NbrJobOnQue;
 
          DoW  LstInf.RcdNbrTot > LstApi.RtnRcdNbr;
            RtnRcdNbr += 1;
 
             GetOplEnt( OJBQ0100
                      : %Size( OJBQ0100 )
                      : LstInf.Handle
                      : LstInf
                      : 1
                      : RtnRcdNbr
                      : ERRC0100
                      );
 
            If  ERRC0100.BytAvl > *Zero;
              Leave;
            EndIf;
 
            NbrJobOnQue += OJBQ0100.NbrJobOnQue;
          EndDo;
        EndSl;
 
        CloseLst( LstInf.Handle: ERRC0100 );
 
        Return  NbrJobOnQue;
 
      /End-Free
 
     P GetJobOnQue     E
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
