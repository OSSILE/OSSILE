     **
     **  Program . . : CBX986E
     **  Description : Work with Server Sessions - UIM Exit Program
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod  Module( CBX986E )
     **               DbgView( *LIST )
     **
     **    CrtPgm     Pgm( CBX986E )
     **               Module( CBX986E )
     **               ActGrp( *CALLER )
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
     D  MsgDta                      512a
 
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
     **-- UIM Display record:
     D DspRcd          Ds                  Qualified
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
 
     **-- UIM constants:
     D RES_OK          c                   0
     D RES_ERR         c                   1
     D RDS_OPT_INZ     c                   'N'
     D PNLGRP          c                   'CBX986P   '
     D KEY_F05         c                   5
     **-- UIM variables:
     D UIM             Ds                  Qualified
     D  LstHdl                        4a
     D  EntHdl                        4a
     D  EntLocOpt                     4a
     D  FncRqs                       10i 0 Inz
     D  PnlNam                       10a
 
     **-- List information:
     D ZLSL0300        Ds                  Qualified
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
     **-- List information:
     D LstInf          Ds                  Qualified
     D  RcdNbrTot                    10i 0
     D  RcdNbrRtn                    10i 0
     D  RcdLen                       10i 0
     D  InfLenRtn                    10i 0
     D  InfCmp                        1a
     D  Dts                          13a
     D                               34a   Inz( *Allx'00' )
 
     **-- UIM exit program interfaces:
     **-- Parm interface:
     D UimExit         Ds            70    Qualified
     D  StcLvl                       10i 0
     D                                8a
     D  TypCall                      10i 0
     D  AppHdl                        8a
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
     **-- Put dialog variable:
     D PutDlgVar       Pr                  ExtPgm( 'QUIPUTV' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a   Const  Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
     D  Error                     32767a          Options( *VarSize )
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
     **-- Remove list entry:
     D RmvLstEnt       Pr                  ExtPgm( 'QUIRMVLE' )
     D  AppHdl                        8a   Const
     D  LstNam                       10a   Const
     D  ExtOpt                        1a   Const
     D  LstEntHdl                     4a
     D  Error                     32767a          Options( *VarSize )
 
     **-- Format time string:
     D FmtTimStr       Pr            16a   Varying
     D  PxMicSec                     10i 0 Value
 
     **-- Entry parameters:
     D CBX986E         Pr
     D  PxUimExit                          LikeDs( UimExit )
     **
     D CBX986E         Pi
     D  PxUimExit                          LikeDs( UimExit )
 
      /Free
 
        Select;
        When  PxUimExit.TypCall = 3;
          Type3 = PxUimExit;
 
          If  Type3.OptNbr = 5;
            ExSr  DspSsnDta;
          EndIf;
 
 
        When  PxUimExit.TypCall = 5;
          Type5 = PxUimExit;
 
          If  Type5.ActRes = RES_OK;
 
            If  Type5.OptNbr = 4;
              ExSr  DltLstEnt;
            EndIf;
          EndIf;
        EndSl;
 
        Return;
 
 
        BegSr  DspSsnDta;
 
          GetLstEnt( Type3.AppHdl
                   : LstEnt
                   : %Size( LstEnt )
                   : 'DTLRCD'
                   : Type3.LstNam
                   : 'HNDL'
                   : 'Y'
                   : *Blanks
                   : Type3.LstEntHdl
                   : 'N'
                   : UIM.EntHdl
                   : ERRC0100
                   );
 
          UIM.PnlNam = %Trim( Type3.PnlNam ) + '2';
 
          Eval-Corr  DspRcd = LstEnt;
 
          DoU  UIM.FncRqs <> KEY_F05;
 
            ExSr  GetSvrInf;
 
            PutDlgVar( Type3.AppHdl
                     : DspRcd
                     : %Size( DspRcd )
                     : 'DSPRCD'
                     : ERRC0100
                     );
 
            DspPnl( Type3.AppHdl
                  : UIM.FncRqs
                  : UIM.PnlNam
                  : RDS_OPT_INZ
                  : ERRC0100
                  );
          EndDo;
 
        EndSr;
 
        BegSr  GetSvrInf;
 
          LstSvrInf( ZLSL0300
                   : %Size( ZLSL0300 )
                   : LstInf
                   : 'ZLSL0300'
                   : '*SESSID'
                   : ERRC0100
                   : '*SESSID'
                   : LstEnt.SsnId
                   );
 
        If  ERRC0100.BytAvl = *Zero  And  LstInf.RcdNbrRtn > *Zero;
 
          DspRcd.WrkStn = ZLSL0300.WrkStn;
          DspRcd.UsrPrf = ZLSL0300.UsrPrf;
          DspRcd.NbrCon = ZLSL0300.NbrCon;
          DspRcd.FilOpn = ZLSL0300.NbrFilOpn;
          DspRcd.NbrSsn = ZLSL0300.NbrSsn;
          DspRcd.SsnTim = FmtTimStr( ZLSL0300.SsnTim );
          DspRcd.SsnIdl = FmtTimStr( ZLSL0300.SsnIdlTim );
          DspRcd.LgoTyp = ZLSL0300.LgoTyp;
          DspRcd.EncPwd = ZLSL0300.EncPwd;
          DspRcd.SsnId  = ZLSL0300.SsnId;
        EndIf;
 
        EndSr;
 
        BegSr  DltLstEnt;
 
          RmvLstEnt( Type5.AppHdl
                   : 'DTLLST'
                   : 'Y'
                   : Type5.LstEntHdl
                   : ERRC0100
                   );
 
        EndSr;
 
      /End-Free
 
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
