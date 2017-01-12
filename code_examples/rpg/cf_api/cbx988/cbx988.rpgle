     **
     **  Program . . : CBX988
     **  Description : Print Password Audit Report - CPP
     **  Author  . . : Carsten Flensburg
     **
     **
     **  Programmer's notes:
     **    Earliest release program will run:  V5R2
     **
     **    This program is depending on being compiled with ACTGRP( *NEW )
     **    in order to properly release allocated storage.
     **
     **
     **  Compile options:
     **
     **    CrtRpgMod  Module( CBX988 )
     **               DbgView( *LIST )
     **
     **    CrtPgm     Pgm( CBX988 )
     **               Module( CBX988 )
     **               ActGrp( *NEW )
     **
     **
     **-- Header specifications:  --------------------------------------------**
     H Option( *SrcStmt: *NoDebugIo )  BndDir( 'QC2LE' )  DatEdit( *DMY/ )
 
     **-- Printer file:
     FQSYSPRT   O    F  132        Printer InfDs( PrtInf )  OflInd( *InOf )
     F                                     UsrOpn
 
     **-- Printer file information:
     D PrtInf          Ds                  Qualified
     D  OvfLin                        5i 0 Overlay( PrtInf: 188 )
     D  CurLin                        5i 0 Overlay( PrtInf: 367 )
     D  CurPag                        5i 0 Overlay( PrtInf: 369 )
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
     D ADP_PRV_INVLVL  c                   1
     D OFS_MSGDTA      c                   16
     D DTA_OFS         c                   610
     D NULL            c                   ''
     **
     D AF_INET         c                   2
     D AF_INET6        c                   24
     **
     D INET_...
     D  ADDRSTRLEN     c                   16
     D INET6_...
     D  ADDRSTRLEN     c                   46
     **-- Global variables:
     D Idx             s             10i 0
     D AutFlg          s              1a
     D SpcAut          s             10a   Dim( 8 )
     D EntDtaStr       s          10240a   Varying
     D RcvVarSiz       s             10u 0
     D pBitFld         s               *
     D pRmtAddr        s               *
     D RmtAddr         s             46a   Varying
     D RmtIpAddr       s             20a
     **
     D Time            s              6s 0
     D NbrRcds         s             10u 0
     D JrnEntDts       s             20a   Inz( *All'0' )
     D JrnDta          s             24a
     D BegDts          s               z
     D EndDts          s               z
 
     **-- Retrieve journal entry data:
     D RJNE0200        Ds                  Qualified  Based( pRJNE0200 )  Align
     D  JrnHdr
     D   BytRtn                      10i 0 Overlay( JrnHdr: 1 )
     D   OfsHdrJrnE                  10i 0 Overlay( JrnHdr: *Next )
     D   NbrEntRtv                   10i 0 Overlay( JrnHdr: *Next )
     D   ConInd                       1a   Overlay( JrnHdr: *Next )
     D   ConRcvStr                   10a   Overlay( JrnHdr: *Next )
     D   ConLibStr                   10a   Overlay( JrnHdr: *Next )
     D   ConSeqNbr                   20s 0 Overlay( JrnHdr: *Next )
     D                               11a   Overlay( JrnHdr: *Next )
     **-- Entry header:
     D EntHdr          Ds                  Qualified  Based( pEntHdr )
     D  OfsHdrJrnE                   10u 0
     D  OfsNulValI                   10u 0
     D  OfsEntDta                    10u 0
     D  OfsTrnId                     10u 0
     D  OfsLglUoW                    10u 0
     D  OfsRcvInf                    10u 0
     D  SeqNbr                       20u 0
     D  TimStp                       20u 0
     D  TimStpC                       8a   Overlay( TimStp )
     D  ThrId                        20u 0
     D  SysSeqNbr                    20u 0
     D  CntRrn                       20u 0
     D  CmtCclId                     20u 0
     D  PtrHdl                       10u 0
     D  RmtPort                       5u 0
     D  ArmNbr                        5u 0
     D  PgmLibAsp                     5u 0
     D  RmtAddr                      16a
     D  RmtAddr_i                    10u 0 Overlay( RmtAddr: 1 )
     D  JrnCde                        1a
     D  EntTyp                        2a
     D  JobNam                       10a
     D  UsrNam                       10a
     D  JobNbr                        6a
     D  PgmNam                       10a
     D  PgmLib                       10a
     D  PgmLibAspDev                 10a
     D  Object                       30a
     D  UsrPrf                       10a
     D  JrnId                        10a
     D  AdrFam                        1a
     D  SysNam                        8a
     D  IndFlg                        1a
     D  ObjNamInd                     1a
     D  BitFld                        1a
     D  Rsv                           9a
     **
     D BitFld          Ds                  Qualified
     D  RefCst                        1s 0
     D  Trg                           1s 0
     D  IncDta                        1s 0
     D  IgnApyRmvJ                    1s 0
     D  MinEntDta                     1s 0
     D  Rsv                           3a
     **-- Null values - *VARLEN:
     D NulValVar       Ds                  Qualified  Based( pNulVal )
     D  NulValLen                    10i 0
     D  NulValIndV                  512a
     **-- Null values - length:
     D NulValLen       Ds                  Qualified  Based( pNulVal )
     D  NulValIndL                  512a
     **-- Entry data:
     D EntDta          Ds                  Qualified  Based( pEntDta )
     D  EntDtaLen                     5s 0
     D                               11a
     D  EntDta                    10240a
     **-- Logical unit of work:
     D LglUoW          Ds                  Qualified  Based( pLglUow )
     D  LglUoW                       39a
     **-- Receiver information:
     D RcvInf          Ds                  Qualified  Based( pRcvInf )
     D  RcvNam_q                     20a
     D   RcvNam                      10a   Overlay( RcvNam_q: 1 )
     D   RcvLib                      10a   Overlay( RcvNam_q: *Next )
     D  RcvLibAspDev                 10a
     D  RcvLibAspNbr                  5i 0
 
     **-- Retrieve journal entry selection records:
     D JrnEntRtv       Ds                  Qualified
     D  NbrVarRcd                    10i 0
 
     **-- RCVRNG - *CURRENT, *CURCHAIN
     D JrnVarR01       Ds                  Qualified
     D  RcdLen                       10i 0 Inz( %Size( JrnVarR01 ))
     D  Key                          10i 0 Inz( 1 )
     D  DtaLen                       10i 0 Inz( %Size( JrnVarR01.Data ))
     D  Data                         40a   Inz( '*CURCHAIN' )
     D   RcvStr_q                    20a   Overlay( Data: 1 )
     D    RcvStr                     10a   Overlay( Data: 1 )
     D    LibStr                     10a   Overlay( Data: 11 )
     D   RcvEnd_q                    20a   Overlay( Data: 21 )
     D    RcvEnd                     10a   Overlay( Data: 21 )
     D    LibEnd                     10a   Overlay( Data: 31 )
     **-- FROMENT - *FIRST
     D JrnVarR02       Ds                  Qualified
     D  RcdLen                       10i 0 Inz( %Size( JrnVarR02 ))
     D  Key                          10i 0 Inz( 2 )
     D  DtaLen                       10i 0 Inz( %Size( JrnVarR02.Data ))
     D  Data                         20a   Inz( '*FIRST' )
     D  SeqNbr                       20s 0 Overlay( Data )
     **-- FROMTIME
     D JrnVarR03       Ds                  Qualified
     D  RcdLen                       10i 0 Inz( %Size( JrnVarR03 ))
     D  Key                          10i 0 Inz( 3 )
     D  DtaLen                       10i 0 Inz( %Size( JrnVarR03.Data ))
     D  Data                         26a
     **-- TOENT - *LAST
     D JrnVarR04       Ds                  Qualified
     D  RcdLen                       10i 0 Inz( %Size( JrnVarR04 ))
     D  Key                          10i 0 Inz( 4 )
     D  DtaLen                       10i 0 Inz( %Size( JrnVarR04.Data ))
     D  Data                         20a   Inz( '*LAST' )
     **-- TOTIME
     D JrnVarR05       Ds                  Qualified
     D  RcdLen                       10i 0 Inz( %Size( JrnVarR05 ))
     D  Key                          10i 0 Inz( 5 )
     D  DtaLen                       10i 0 Inz( %Size( JrnVarR05.Data ))
     D  Data                         26a
     **-- NBRENT
     D JrnVarR06       Ds                  Qualified
     D  RcdLen                       10i 0 Inz( %Size( JrnVarR06 ))
     D  Key                          10i 0 Inz( 6 )
     D  DtaLen                       10i 0 Inz( %Size( JrnVarR06.Data ))
     D  Data                         10i 0 Inz( 65535 )
     **-- JRNCDE - *ALL, *CTL / *ALLSLT, *IGNFILSLT
     D JrnVarR07       Ds                  Qualified
     D  RcdLen                       10i 0 Inz( %Size( JrnVarR07 ))
     D  Key                          10i 0 Inz( 7 )
     D  DtaLen                       10i 0 Inz( %Size( JrnVarR07.Data ))
     D  Data
     D   NbrCod                      10i 0 Overlay( Data: 1 )
     D   JrnCod                      20a   Overlay( Data: *Next )
     D                                     Dim( 16 )
     D    JrnCodVal                  10a   Overlay( JrnCod: 1 )
     D    JrnCodSlt                  10a   Overlay( JrnCod: *Next )
     **-- ENTTYP - *ALL, *RCD
     D JrnVarR08       Ds                  Qualified
     D  RcdLen                       10i 0 Inz( %Size( JrnVarR08 ))
     D  Key                          10i 0 Inz( 8 )
     D  DtaLen                       10i 0 Inz( %Size( JrnVarR08.Data ))
     D  Data
     D   NbrTyp                      10i 0 Overlay( Data: 1 )
     D   EntTyp                      10a   Overlay( Data: *Next )
     D                                     Dim( 16 )
     **-- JOB - *ALL
     D JrnVarR09       Ds                  Qualified
     D  RcdLen                       10i 0 Inz( %Size( JrnVarR09 ))
     D  Key                          10i 0 Inz( 9 )
     D  DtaLen                       10i 0 Inz( %Size( JrnVarR09.Data ))
     D  Data                         26a   Inz( '*ALL' )
     **-- PGM - *ALL
     D JrnVarR10       Ds                  Qualified
     D  RcdLen                       10i 0 Inz( %Size( JrnVarR10 ))
     D  Key                          10i 0 Inz( 10 )
     D  DtaLen                       10i 0 Inz( %Size( JrnVarR10.Data ))
     D  Data                         10a   Inz( '*ALL' )
     **-- USRPRF * *ALL
     D JrnVarR11       Ds                  Qualified
     D  RcdLen                       10i 0 Inz( %Size( JrnVarR11 ))
     D  Key                          10i 0 Inz( 11 )
     D  DtaLen                       10i 0 Inz( %Size( JrnVarR11.Data ))
     D  Data                         10a   Inz( '*ALL' )
     **-- CMTCYCID - *ALL
     D JrnVarR12       Ds                  Qualified
     D  RcdLen                       10i 0 Inz( %Size( JrnVarR12 ))
     D  Key                          10i 0 Inz( 12 )
     D  DtaLen                       10i 0 Inz( %Size( JrnVarR12.Data ))
     D  Data                         20a   Inz( '*ALL' )
     **-- DEPENT - *ALL, *NONE
     D JrnVarR13       Ds                  Qualified
     D  RcdLen                       10i 0 Inz( %Size( JrnVarR13 ))
     D  Key                          10i 0 Inz( 13 )
     D  DtaLen                       10i 0 Inz( %Size( JrnVarR13.Data ))
     D  Data                         10a   Inz( '*ALL' )
     **-- INCENT - *CONFIRMED, *ALL
     D JrnVarR14       Ds                  Qualified
     D  RcdLen                       10i 0 Inz( %Size( JrnVarR14 ))
     D  Key                          10i 0 Inz( 14 )
     D  DtaLen                       10i 0 Inz( %Size( JrnVarR14.Data ))
     D  Data                         10a   Inz( '*CONFIRMED' )
     **-- NULLINDLEN - *VARLEN
     D JrnVarR15       Ds                  Qualified
     D  RcdLen                       10i 0 Inz( %Size( JrnVarR15 ))
     D  Key                          10i 0 Inz( 15 )
     D  DtaLen                       10i 0 Inz( %Size( JrnVarR15.Data ))
     D  Data                         10a   Inz( '*VARLEN' )
     **-- FILE - *ALLFILE, *ALL
     D JrnVarR16       Ds                  Qualified
     D  RcdLen                       10i 0 Inz( %Size( JrnVarR16 ))
     D  Key                          10i 0 Inz( 16 )
     D  DtaLen                       10i 0 Inz( %Size( JrnVarR16.Data ))
     D  Data
     D   NbrFil                      10i 0 Overlay( Data: 1 )
     D   FilNam_q                    30a   Overlay( Data: *Next )
     D                                     Dim( 16 )
     D    FilNam                     10a   Overlay( FilNam_q: 1 )
     D    LibNam                     10a   Overlay( FilNam_q: *Next )
     D    MbrNam                     10a   Overlay( FilNam_q: *Next )
 
     **-- Journal entry map:
     D QASYCPJ       E Ds                  ExtName( QASYCPJ5 )  Qualified  Inz
 
     **-- Retrieve journal entries:
     D RtvJrnE         Pr                  ExtProc( 'QjoRetrieveJournalEntries')
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  JrnNam_q                     20a   Const
     D  RcvInfFmt                     8a   Const
     D  SltInf                    32767a   Const  Options( *Omit: *VarSize )
     D  Error                     32767a          Options( *Omit: *VarSize )
     **-- Delete pointer handle:
     D DltPtrHdl       Pr                  ExtProc( 'QjoDeletePointerHandle' )
     D  PtrHdl                       10u 0 Const
     D  Error                     32767a          Options( *Omit: *VarSize )
     **-- Check special authority
     D ChkSpcAut       Pr                  ExtPgm( 'QSYCUSRS' )
     D  AutInf                        1a
     D  UsrPrf                       10a   Const
     D  SpcAut                       10a   Const  Dim( 8 )  Options( *VarSize )
     D  NbrAut                       10i 0 Const
     D  CalLvl                       10i 0 Const
     D  Error                     32767a          Options( *VarSize )
     **-- Convert date & time:
     D CvtDtf          Pr                  ExtPgm( 'QWCCVTDT' )
     D  InpFmt                       10a   Const
     D  CdInpVar                     17a   Const  Options( *VarSize )
     D  OutFmt                       10a   Const
     D  OutVar                       17a          Options( *VarSize )
     D  Error                        10i 0 Const
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
 
     **-- Convert IPv4 and IPv6 addresses:
     D inet_ntop       Pr              *   ExtProc( 'inet_ntop' )
     D  af                           10u 0 Value
     D  src                            *   Value
     D  dst                            *   Value
     D  size                         10u 0 Value
     **-- Test bit in string:
     D tstbts          Pr            10i 0 ExtProc( 'tstbts' )
     D  String                         *   Value
     D  BitOfs                       10u 0 Value
 
     **-- Send status message:
     D SndStsMsg       Pr            10i 0
     D  PxMsgDta                   1024a   Const  Varying
     **-- Send completion message:
     D SndCmpMsg       Pr            10i 0
     D  PxMsgDta                    512a   Const  Varying
     **-- Send diagnostic message:
     D SndDiagMsg      Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying
 
     **-- Entry parameters:
     D DatTim          Ds                  Based( pNull )  Qualified
     D  NbrElm                        5i 0
     D  Date                          7a
     D  Time                          6a
     **
     D JrnRcv          Ds                  Based( pNull )  Qualified
     D  NbrElm                        5i 0
     D  RcvNamBeg_q                  20a
     D   RcvNamBeg                   10a   Overlay( RcvNamBeg_q: 1 )
     D   RcvLibBeg                   10a   Overlay( RcvNamBeg_q: 11 )
     D  RcvNamEnd_q                  20a
     D   RcvNamEnd                   10a   Overlay( RcvNamEnd_q: 1 )
     D   RcvLibEnd                   10a   Overlay( RcvNamEnd_q: 11 )
     **
     D PwdSts          Ds                  Based( pNull )  Qualified
     D  NbrElm                        5i 0
     D  ChkSts                       10a   Dim( 6 )
     **
     D CBX988          Pr
     D  PxJrnRcv_q                         LikeDs( JrnRcv )
     D  PxStrDtm                           LikeDs( DatTim )
     D  PxEndDtm                           LikeDs( DatTim )
     D  PxUsrPrf                     10a
     D  PxTgtPrf                     10a
     D  PxPwdSts                           LikeDs( PwdSts )
     **
     D CBX988          Pi
     D  PxJrnRcv_q                         LikeDs( JrnRcv )
     D  PxStrDtm                           LikeDs( DatTim )
     D  PxEndDtm                           LikeDs( DatTim )
     D  PxUsrPrf                     10a
     D  PxTgtPrf                     10a
     D  PxPwdSts                           LikeDs( PwdSts )
 
      /Free
 
        SpcAut( 1 ) = '*SECADM';
        SpcAut( 2 ) = '*ALLOBJ';
 
        ChkSpcAut( AutFlg
                 : PgmSts.UsrPrf
                 : SpcAut
                 : 2
                 : ADP_PRV_INVLVL
                 : ERRC0100
                 );
 
        If  ERRC0100.BytAvl > *Zero  Or  AutFlg = 'N';
          SndEscMsg( 'CPFB304': 'QCPFMSG': NULL );
        EndIf;
 
        SndStsMsg( 'Retrieving audit data, please wait...' );
 
        ExSr  InzApiPrm;
 
        DoU  RJNE0200.ConInd = '0'  Or  ERRC0100.BytAvl > *Zero;
 
          RtvJrnE( RJNE0200
                 : RcvVarSiz
                 : 'QAUDJRN   QSYS '
                 : 'RJNE0200'
                 : JrnEntRtv  +
                   JrnVarR01  +
                   JrnVarR03  +
                   JrnVarR05  +
                   JrnVarR06  +
                   JrnVarR07  +
                   JrnVarR08  +
                   JrnVarR11
                 : ERRC0100
                 );
 
          If  ERRC0100.BytAvl > *Zero;
            ExSr  EscApiErr;
 
          Else;
            pEntHdr = pRJNE0200 + RJNE0200.OfsHdrJrnE;
 
            For  Idx = 1  to  RJNE0200.NbrEntRtv;
 
              ExSr  PrcLstEnt;
 
              If  EntHdr.PtrHdl > *Zero;
                CallP(e)  DltPtrHdl( EntHdr.PtrHdl: *Omit );
              EndIf;
 
              If  Idx < RJNE0200.NbrEntRtv;
                pEntHdr += EntHdr.OfsHdrJrnE;
              EndIf;
 
            EndFor;
 
            If  RJNE0200.ConInd = '1';
              JrnVarR01.RcvStr = RJNE0200.ConRcvStr;
              JrnVarR01.LibStr = RJNE0200.ConLibStr;
              JrnVarR01.RcvEnd = '*CURRENT';
              JrnVarR02.SeqNbr = RJNE0200.ConSeqNbr;
            EndIf;
          EndIf;
 
        EndDo;
 
        ExSr  EndPgm;
 
        BegSr  PrcLstEnt;
 
          pEntDta = pEntHdr + EntHdr.OfsEntDta;
 
          EntDtaStr = %SubSt( EntDta.EntDta: 1: EntDta.EntDtaLen );
 
          If  EntHdr.OfsRcvInf > *Zero;
            pRcvInf = pEntHdr + EntHdr.OfsRcvInf;
          EndIf;
 
          If  EntHdr.JrnCde = 'T';
            ExSr  LodVarDta;
            ExSr  LodEntMap;
          EndIf;
 
          If  QASYCPJ.CPPCHG = 'Y';
            ExSr  ChkSltCri;
          EndIf;
 
        EndSr;
 
        BegSr  ChkSltCri;
 
          If  PxTgtPrf = QASYCPJ.CPONAM  Or  PxTgtPrf = '*ALL';
 
            If  PxPwdSts.ChkSts(1) = '*ANY'      Or
 
                PxPwdSts.ChkSts(1) = '*NONPASS'  And
                QASYCPJ.CPPWDF    <> '*PASSED'   Or
 
                %Lookup( QASYCPJ.CPPWDF
                       : PxPwdSts.ChkSts
                       : 1
                       : PxPwdSts.NbrElm
                       ) > *Zero;
 
              ExSr  PrtRptLin;
            EndIf;
          EndIf;
 
        EndSr;
 
        BegSr  LodVarDta;
 
          Select;
          When  EntHdr.AdrFam = '4';
            pRmtAddr = inet_ntop( AF_INET
                                : %Addr( EntHdr.RmtAddr )
                                : pRmtAddr
                                : INET_ADDRSTRLEN
                                );
 
            RmtAddr  = %Str( pRmtAddr );
 
          When  EntHdr.AdrFam = '6';
            pRmtAddr = inet_ntop( AF_INET6
                                : %Addr( EntHdr.RmtAddr )
                                : pRmtAddr
                                : INET6_ADDRSTRLEN
                                );
 
            RmtAddr  = %Str( pRmtAddr );
 
          Other;
            RmtAddr  = NULL;
          EndSl;
 
          RmtIpAddr  = RmtAddr;
 
          pBitFld = %Addr( EntHdr.BitFld );
 
          BitFld.RefCst     = tstbts( pBitFld: 0 );
          BitFld.Trg        = tstbts( pBitFld: 1 );
          BitFld.IncDta     = tstbts( pBitFld: 2 );
          BitFld.IgnApyRmvJ = tstbts( pBitFld: 3 );
          BitFld.MinEntDta  = tstbts( pBitFld: 4 );
 
          If  EntHdr.OfsNulValI > *Zero;
            pNulVal = pEntHdr + EntHdr.OfsNulValI;
          EndIf;
 
          If  EntHdr.OfsLglUoW  > *Zero;
            pLglUow = pEntHdr + EntHdr.OfsLglUoW;
          EndIf;
 
        EndSr;
 
        BegSr  LodEntMap;
 
          Select;
          When  EntHdr.EntTyp = 'CP';
            ExSr  LodEntCP;
          EndSl;
 
        EndSr;
 
        BegSr  LodEntCP;
 
          %SubSt( QASYCPJ: DTA_OFS ) = EntDtaStr;
 
        EndSr;
 
        BegSr  PrtRptLin;
 
          If  Not %Open( QSYSPRT );
            ExSr  OpnPrtHdr;
          EndIf;
 
          If  PrtInf.CurLin > PrtInf.OvfLin - 3;
            Except  Header;
          EndIf;
 
          NbrRcds += 1;
 
          CvtDtf( '*DTS': EntHdr.TimStpC: '*YYMD': JrnEntDts: *Zero );
 
          Except  Detail;
 
        EndSr;
 
        BegSr  OpnPrtHdr;
 
          Open  QSYSPRT;
 
          Time = %Dec( %Time());
 
          Except  Header;
 
        EndSr;
 
        BegSr  InzApiPrm;
 
          pRmtAddr = %Alloc( INET6_ADDRSTRLEN );
 
          If  PxJrnRcv_q.NbrElm = 1;
            JrnVarR01.RcvStr_q = PxJrnRcv_q.RcvNamBeg_q;
            JrnVarR01.RcvEnd_q = *Blanks;
          Else;
            JrnVarR01.RcvStr_q = PxJrnRcv_q.RcvNamBeg_q;
            JrnVarR01.RcvEnd_q = PxJrnRcv_q.RcvNamEnd_q;
          EndIf;
 
          Select;
          When  PxEndDtm.NbrElm = 1  And  PxEndDtm.Date = *Zeros;
            EndDts = %Timestamp() + %Days( 1 );
 
          When  PxEndDtm.NbrElm = 1  And  PxEndDtm.Date = '0010000';
            EndDts = %Date() - %Days( 1 ) + %Time( 235959: *HMS );
 
          When  PxEndDtm.NbrElm = 2  And  PxEndDtm.Time = *Zeros;
            EndDts = %Date( PxEndDtm.Date: *CYMD0 ) + %Time( 235959: *HMS );
 
          Other;
            EndDts = %Date( PxEndDtm.Date: *CYMD0 ) +
                     %Time( PxEndDtm.Time: *HMS0 );
          EndSl;
 
          Select;
          When  PxStrDtm.NbrElm = 1  And  PxStrDtm.Date = *Zeros;
            BegDts = %Timestamp() - %Years( 10 );
 
          When  PxStrDtm.NbrElm = 1  And  PxStrDtm.Date = '0010000';
            BegDts = %Date() - %Days( 1 ) + %Time( 000000: *HMS );
 
          When  PxStrDtm.NbrElm = 1  And  PxStrDtm.Date = '0020000';
            BegDts = %Date( EndDts ) - %Days( 6 ) + %Time( 000000: *HMS );
 
          When  PxStrDtm.NbrElm = 2  And  PxStrDtm.Time = *Zeros;
            BegDts = %Date( PxStrDtm.Date: *CYMD0 ) + %Time( 000000: *HMS );
 
          Other;
            BegDts = %Date( PxStrDtm.Date: *CYMD0 ) +
                     %Time( PxStrDtm.Time: *HMS0 );
          EndSl;
 
          JrnVarR03.Data = %Char( BegDts );
          JrnVarR05.Data = %Char( EndDts );
 
          JrnVarR07.NbrCod = 1;
          JrnVarR07.JrnCodVal(1) = 'T';
          JrnVarR07.JrnCodSlt(1) = '*ALLSLT';
 
          JrnVarR08.NbrTyp = 1;
          JrnVarR08.EntTyp(1) = 'CP';
 
          JrnVarR11.Data = PxUsrPrf;
 
          JrnEntRtv.NbrVarRcd = 7;
 
          RcvVarSiz = 16384000;
          pRJNE0200 = %Alloc( RcvVarSiz );
 
        EndSr;
 
        BegSr  EndPgm;
 
          If  Not  %Open( QSYSPRT );
            ExSr  OpnPrtHdr;
          EndIf;
 
          If  NbrRcds = *Zero;
            Except  NoRcds;
          EndIf;
 
          Close  QSYSPRT;
 
          SndCmpMsg( 'Password audit report has been printed.' );
 
          *InLr = *On;
          Return;
 
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
 
     **-- Print file definition:
     OQSYSPRT   EF           Header         2  3
     O                       UDATE         Y      8
     O                       Time                18 '  :  :  '
     O                                           75 'Print Password Audit -
     O                                              Report'
     O                                          107 'Program:'
     O                       PgmSts.PgmNam      118
     O                                          126 'Page:'
     O                       PAGE             +   1
     OQSYSPRT   EF           Header         1
     O                                            9 'Timestamp'
     O                                           25 'Code'
     O                                           30 'Type'
     O                                           41 'IP address'
     O                                           55 'Job'
     O                                           67 'User'
     O                                           79 'Number'
     O                                           87 'Program'
     O                                           99 'User ID'
     O                                          107 'Cmd'
     O                                          116 'Profile'
     O                                          126 'Check'
     **
     OQSYSPRT   EF           Detail         1
     O                       JrnEntDts           20
     O                       EntHdr.JrnCde       24
     O                       EntHdr.EntTyp       29
     O                       RmtIpAddr           51
     O                       EntHdr.JobNam       62
     O                       EntHdr.UsrNam       73
     O                       EntHdr.JobNbr       79
     O                       EntHdr.PgmNam       90
     O                       EntHdr.UsrPrf      102
     O                       QASYCPJ.CPCMDN     107
     O                       QASYCPJ.CPONAM     119
     O                       QASYCPJ.CPPWDF     131
     **
     OQSYSPRT   EF           NoRcds      1
     O                                           26 '(No entries found)'
 
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
          Return   0;
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
          Return   0;
        EndIf;
 
      /End-Free
 
     P SndEscMsg       E
