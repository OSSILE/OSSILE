     **
     **  Program . . : CBX978
     **  Description : Retrieve Command Information - CPP
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **
     **  Compile options:
     **
     **    CrtRpgMod  Module( CBX978 )
     **               DbgView( *LIST )
     **
     **    CrtPgm     Pgm( CBX978 )
     **               Module( CBX978 )
     **               ActGrp( *NEW )
     **
     **
     **-- Header Specifications:  --------------------------------------------**
     H Option( *SrcStmt )
     **-- API Error Data Structure:
     D ERRC0100        Ds                  Qualified  Inz
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                     1024a
 
     **-- Global constants:
     D OFS_MSGDTA      c                   16
 
     **-- Command information:
     D CMDI0100        Ds         10240    Qualified  Inz
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  CmdNam_q                     20a
     D   CmdNam                      10a   Overlay( CmdNam_q:  1 )
     D   CmdLib                      10a   Overlay( CmdNam_q: 11 )
     D  CmdPgm_q                     20a
     D   PgmNam                      10a   Overlay( CmdPgm_q:  1 )
     D   PgmLib                      10a   Overlay( CmdPgm_q: 11 )
     D  SrcFil                       10a
     D  SrcLib                       10a
     D  SrcMbr                       10a
     D  VcpNam                       10a
     D  VcpLib                       10a
     D  ModeInf                      10a
     D  AlwInf                       15a
     D  AlwLmtUsr                     1a
     D  MaxPos                       10i 0
     D  PmtMsfNam                    10a
     D  PmtMsfLib                    10a
     D  MsgFilNam                    10a
     D  MsgFilLib                    10a
     D  HlpPngNam                    10a
     D  HlpPngLib                    10a
     D  HlpId                        10a
     D  SchIdxNam                    10a
     D  SchIdxLib                    10a
     D  CurLib                       10a
     D  PrdLib                       10a
     D  PopNam                       10a
     D  PopLib                       10a
     D  RstTgtRls                     6a
     D  TxtDsc                       50a
     D  CppCalStt                     2a
     D  VcpCalStt                     2a
     D  PopCalStt                     2a
     D  OfsHlpBks                    10i 0
     D  LenHlpBks                    10i 0
     D  CcsId                        10i 0
     D  EnbGui                        1a
     D  ThdSafInd                     1a
     D  MltJobAcn                     1a
     D  PxyCmdInd                     1a
     D                               14a
     **
     D HlpBksInf       Ds                  Qualified  Based( pHlpBksInf )
     D                               71a
     D  HlpBks                        8a
 
     **-- Retrieve command information:
     D RtvCmdInf       Pr                  ExtPgm( 'QCDRCMDI' )
     D  RcvVar                    65535a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                       10a   Const
     D  CmdNam_q                     20a   Const
     D  Error                     32767a          Options( *VarSize )
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
 
     **-- Format mode:
     D FmtMode         Pr           100a
     D  PxMode                       10a   Value
     **-- Format where allowed to run:
     D FmtAlwRun       Pr           150a
     D  PxAlwRun                     15a   Value
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgFil                     10a   Const
     D  PxMsgDta                    512a   Const  Varying
 
     **-- Parameter definitions:
     D ObjNam_q        Ds                  Qualified
     D  ObjNam                       10a   Varying
     D  ObjLib                       10a   Varying
     **
     D CBX978          Pr
     D  PxCmdNam_q                         LikeDs( ObjNam_q )
     D  PxRtnCmd                     10a
     D  PxRtnLib                     10a
     D  PxSrcFil                     10a
     D  PxSrcLib                     10a
     D  PxSrcMbr                     10a
     D  PxPgmNam                     10a
     D  PxPgmLib                     10a
     D  PxVcpNam                     10a
     D  PxVcpLib                     10a
     D  PxMode                      100a
     D  PxAllow                     150a
     D  PxAlwLmtUsr                   1a
     D  PxMaxPos                     10p 0
     D  PxPmtFil                     10a
     D  PxPmtLib                     10a
     D  PxMsgFil                     10a
     D  PxMsgFilLib                  10a
     D  PxHlpPnlGrp                  10a
     D  PxHlpPnlGrpL                 10a
     D  PxHlpId                      10a
     D  PxHlpSchIdx                  10a
     D  PxHlpSchIdxL                 10a
     D  PxCurLib                     10a
     D  PxPrdLib                     10a
     D  PxPmtOvrPgm                  10a
     D  PxPmtOvrPgmL                 10a
     D  PxTgtRls                      6a
     D  PxTxtDsc                     50a
     D  PxCppStt                      2a
     D  PxVcpStt                      2a
     D  PxPopStt                      2a
     D  PxCcsId                       5p 0
     D  PxEnbGui                      1a
     D  PxThdSafe                     1a
     D  PxMltThdAcn                   1a
     D  PxPxyInd                      1a
     **
     D CBX978          Pi
     D  PxCmdNam_q                         LikeDs( ObjNam_q )
     D  PxRtnCmd                     10a
     D  PxRtnLib                     10a
     D  PxPgmNam                     10a
     D  PxPgmLib                     10a
     D  PxSrcFil                     10a
     D  PxSrcLib                     10a
     D  PxSrcMbr                     10a
     D  PxVcpNam                     10a
     D  PxVcpLib                     10a
     D  PxMode                      100a
     D  PxAllow                     150a
     D  PxAlwLmtUsr                   1a
     D  PxMaxPos                     10p 0
     D  PxPmtFil                     10a
     D  PxPmtLib                     10a
     D  PxMsgFil                     10a
     D  PxMsgFilLib                  10a
     D  PxHlpPnlGrp                  10a
     D  PxHlpPnlGrpL                 10a
     D  PxHlpId                      10a
     D  PxHlpSchIdx                  10a
     D  PxHlpSchIdxL                 10a
     D  PxCurLib                     10a
     D  PxPrdLib                     10a
     D  PxPmtOvrPgm                  10a
     D  PxPmtOvrPgmL                 10a
     D  PxTgtRls                      6a
     D  PxTxtDsc                     50a
     D  PxCppStt                      2a
     D  PxVcpStt                      2a
     D  PxPopStt                      2a
     D  PxCcsId                       5p 0
     D  PxEnbGui                      1a
     D  PxThdSafe                     1a
     D  PxMltThdAcn                   1a
     D  PxPxyInd                      1a
 
      /Free
 
        RtvCmdInf( CMDI0100
                 : %Size( CMDI0100 )
                 : 'CMDI0100'
                 : PxCmdNam_q
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
 
        If  %Addr( PxRtnLib ) <> *Null;
          PxRtnLib = CMDI0100.CmdLib;
        EndIf;
 
        If  %Addr( PxPgmNam ) <> *Null;
          PxPgmNam = CMDI0100.PgmNam;
        EndIf;
 
        If  %Addr( PxPgmLib ) <> *Null;
          PxPgmLib = CMDI0100.PgmLib;
        EndIf;
 
        If  %Addr( PxSrcFil ) <> *Null;
          PxSrcFil = CMDI0100.SrcFil;
        EndIf;
 
        If  %Addr( PxSrcLib ) <> *Null;
          PxSrcLib = CMDI0100.SrcLib;
        EndIf;
 
        If  %Addr( PxSrcMbr ) <> *Null;
          PxSrcMbr = CMDI0100.SrcMbr;
        EndIf;
 
        If  %Addr( PxVcpNam ) <> *Null;
          PxVcpNam = CMDI0100.VcpNam;
        EndIf;
 
        If  %Addr( PxVcpLib ) <> *Null;
          PxVcpLib = CMDI0100.VcpLib;
        EndIf;
 
        If  %Addr( PxMode ) <> *Null;
          PxMode = FmtMode( CMDI0100.ModeInf );
        EndIf;
 
        If  %Addr( PxMode ) <> *Null;
          PxAllow = FmtAlwRun( CMDI0100.AlwInf );
        EndIf;
 
        If  %Addr( PxAlwLmtUsr ) <> *Null;
          PxAlwLmtUsr = CMDI0100.AlwLmtUsr;
        EndIf;
 
        If  %Addr( PxMaxPos ) <> *Null;
          PxMaxPos = CMDI0100.MaxPos;
        EndIf;
 
        If  %Addr( PxPmtFil ) <> *Null;
          PxPmtFil = CMDI0100.PmtMsfNam;
        EndIf;
 
        If  %Addr( PxPmtLib ) <> *Null;
          PxPmtLib = CMDI0100.PmtMsfLib;
        EndIf;
 
        If  %Addr( PxMsgFil ) <> *Null;
          PxMsgFil = CMDI0100.MsgFilNam;
        EndIf;
 
        If  %Addr( PxMsgFilLib ) <> *Null;
          PxMsgFilLib = CMDI0100.MsgFilLib;
        EndIf;
 
        If  %Addr( PxHlpPnlGrp ) <> *Null;
          PxHlpPnlGrp = CMDI0100.HlpPngNam;
        EndIf;
 
        If  %Addr( PxHlpPnlGrpL ) <> *Null;
          PxHlpPnlGrpL = CMDI0100.HlpPngLib;
        EndIf;
 
        If  %Addr( PxHlpId ) <> *Null;
          PxHlpId = CMDI0100.HlpId;
        EndIf;
 
        If  %Addr( PxHlpSchIdx ) <> *Null;
          PxHlpSchIdx = CMDI0100.SchIdxNam;
        EndIf;
 
        If  %Addr( PxHlpSchIdxL ) <> *Null;
          PxHlpSchIdxL = CMDI0100.SchIdxLib;
        EndIf;
 
        If  %Addr( PxCurLib ) <> *Null;
          PxCurLib = CMDI0100.CurLib;
        EndIf;
 
        If  %Addr( PxPrdLib ) <> *Null;
          PxPrdLib = CMDI0100.PrdLib;
        EndIf;
 
        If  %Addr( PxPmtOvrPgm ) <> *Null;
          PxPmtOvrPgm = CMDI0100.PopNam;
        EndIf;
 
        If  %Addr( PxPmtOvrPgmL ) <> *Null;
          PxPmtOvrPgmL = CMDI0100.PopLib;
        EndIf;
 
        If  %Addr( PxTgtRls ) <> *Null;
          PxTgtRls = CMDI0100.RstTgtRls;
        EndIf;
 
        If  %Addr( PxTxtDsc ) <> *Null;
          PxTxtDsc = CMDI0100.TxtDsc;
        EndIf;
 
        If  %Addr( PxCppStt ) <> *Null;
          PxCppStt = CMDI0100.CppCalStt;
        EndIf;
 
        If  %Addr( PxVcpStt ) <> *Null;
          PxVcpStt = CMDI0100.VcpCalStt;
        EndIf;
 
        If  %Addr( PxPopStt ) <> *Null;
          PxPopStt = CMDI0100.PopCalStt;
        EndIf;
 
        If  %Addr( PxCcsId ) <> *Null;
          PxCcsId = CMDI0100.CcsId;
        EndIf;
 
        If  %Addr( PxEnbGui ) <> *Null;
          PxEnbGui = CMDI0100.EnbGui;
        EndIf;
 
        If  %Addr( PxThdSafe ) <> *Null;
          PxThdSafe = CMDI0100.ThdSafInd;
        EndIf;
 
        If  %Addr( PxMltThdAcn ) <> *Null;
          PxMltThdAcn = CMDI0100.MltJobAcn;
        EndIf;
 
        If  %Addr( PxPxyInd ) <> *Null;
          PxPxyInd = CMDI0100.PxyCmdInd;
        EndIf;
 
 
        *InLr = *On;
        Return;
 
      /End-Free
 
     **-- Format mode:
     P FmtMode         B                   Export
     D                 Pi           100a
     D  PxMode                       10a   Value
     **
     D Idx             s             10i 0
     **
     D Mode            Ds
     D  ModeVal                       1a   Dim( 15 )
     **
     D RtnMode         Ds
     D  RtnModeVal                   10a   Dim( 15 )
 
      /Free
 
        Mode = PxMode;
 
        If  ModeVal(1) = '1';
          Idx += 1;
          RtnModeVal(Idx) = '*PROD';
        EndIf;
 
        If  ModeVal(2) = '1';
          Idx += 1;
          RtnModeVal(Idx) = '*DEBUG';
        EndIf;
 
        If  ModeVal(3) = '1';
          Idx += 1;
          RtnModeVal(Idx) = '*SERVICE';
        EndIf;
 
 
        Return  RtnMode;
 
      /End-Free
 
     P FmtMode         E
     **-- Format where allowed to run:
     P FmtAlwRun       B                   Export
     D                 Pi           150a
     D  PxAlwRun                     15a   Value
     **
     D Idx             s             10i 0
     **
     D AlwRun          Ds
     D  AlwRunVal                     1a   Dim( 15 )
     **
     D RtnAlwRun       Ds
     D  RtnAlwRunVal                 10a   Dim( 15 )
 
      /Free
 
        AlwRun = PxAlwRun;
 
        If  AlwRunVal(1) = '1';
          Idx += 1;
          RtnAlwRunVal(Idx) = '*BPGM';
        EndIf;
 
        If  AlwRunVal(2) = '1';
          Idx += 1;
          RtnAlwRunVal(Idx) = '*IPGM';
        EndIf;
 
        If  AlwRunVal(3) = '1';
          Idx += 1;
          RtnAlwRunVal(Idx) = '*EXEC';
        EndIf;
 
        If  AlwRunVal(4) = '1';
          Idx += 1;
          RtnAlwRunVal(Idx) = '*INTERACT';
        EndIf;
 
        If  AlwRunVal(5) = '1';
          Idx += 1;
          RtnAlwRunVal(Idx) = '*BATCH';
        EndIf;
 
        If  AlwRunVal(6) = '1';
          Idx += 1;
          RtnAlwRunVal(Idx) = '*BREXX';
        EndIf;
 
        If  AlwRunVal(7) = '1';
          Idx += 1;
          RtnAlwRunVal(Idx) = '*IREXX';
        EndIf;
 
 
        Return  RtnAlwRun;
 
      /End-Free
 
     P FmtAlwRun       E
     **-- Send escape message:
     P SndEscMsg       B
     D                 Pi            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgFil                     10a   Const
     D  PxMsgDta                    512a   Const  Varying
     **
     D MsgKey          s              4a
 
      /Free
 
        SndPgmMsg( PxMsgId
                 : PxMsgFil + '*LIBL'
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
