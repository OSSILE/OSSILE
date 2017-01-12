     **
     **  Program . . : CBX977L
     **  Description : Work with Jobs - UIM List Exit Program
     **  Author  . . : Carsten Flensburg
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod  Module( CBX977L )
     **               DbgView( *LIST )
     **
     **    CrtPgm     Pgm( CBX977L )
     **               Module( CBX977L )
     **               ActGrp( *CALLER )
     **
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
     D BLD_SYNCH       c                   -1
     D SNG_ENT         c                   1
     D MIN_NBR_ENT     c                   34
     **
     D BIN_SGN         c                   0
     D NUM_ZON         c                   2
     D CHAR_NLS        c                   4
     D SORT_ASC        c                   '1'
     D SORT_DSC        c                   '2'
     **-- Global variables:
     D KeyDtaVal       s             32a
     D Idx             s             10i 0
     D EntNbr          s             10i 0
 
     **-- UIM constants:
     D LIST_TOP        c                   'TOP'
     D LIST_BOT        c                   'BOT'
     D LIST_COMP       c                   'ALL'
     D LIST_SAME       c                   'SAME'
     D EXIT_SAME       c                   '*SAME'
     D TRIM_SAME       c                   'S'
     D POS_TOP         c                   'TOP'
     D POS_BOT         c                   'BOT'
     D POS_SAME        c                   'SAME'
     **-- UIM variables:
     D UIM             Ds                  Qualified
     D  AppHdl                        8a
     D  LstHdl                        4a
     D  EntHdl                        4a
     D  FncRqs                       10i 0
     D  EntLocOpt                     4a
     D  LstPos                        4a
     D  LstCnt                        4a
     **-- UIM exit program interfaces:
     **-- Incomplete list:
     D Type6           Ds                  Qualified
     D  StcLvl                       10i 0
     D                                8a
     D  TypCall                      10i 0
     D  AppHdl                        8a
     D                               10a
     D  LstNam                       10a
     D  IncLstDir                    10i 0
     D  NbrEntRqd                    10i 0
 
     **-- UIM Panel control record:
     D CtlRcd          Ds                  Qualified
     D  Action                        4a
     D  EntLocOpt                     4a
     **-- UIM List parameter record:
     D PrmRcd          Ds                  Qualified
     D  JobNam                       10a
     D  UsrPrf                       10a
     D  JobSts                       10a
     D  JobTyp                        1a
     D  CurUsr                       10a
     D  CmpSts                       10a
     **-- UIM List entry:
     D LstEnt          Ds                  Qualified
     D  Option                        5i 0
     D  EntId                        19a
     D  JobNam                       10a
     D  JobUsr                       10a
     D  JobNbr                        6a
     D  JobTyp                        1a
     D  JobSts1                       7a
     D  JobSts2                       4a
     D  JobDat                        7a
     D  EntDat                        7a
     D  EntTim                        6a
     D  ActDat                        7a
     D  ActTim                        6a
     D  CurUsr                       10a
     D  FncCmp                       14a
     D  MsgRpy                        1a
     D  SbmJob                       10a
     D  SbmUsr                       10a
     D  SbmNbr                        6a
 
     **-- List API parameters:
     D LstApi          Ds                  Qualified  Inz
     D  RtnRcdNbr                    10i 0
     D  CurRcdNbr                    10i 0
     D  NbrFldRtn                    10i 0 Inz( %Elem( LstApi.KeyFld ))
     D  KeyFld                       10i 0 Dim( 11 )
     **-- Job information:
     D OLJB0200        Ds           512    Qualified
     D  JobNam                       10a
     D  UsrPrf                       10a
     D  JobNbr                        6a
     D  JobIdInt                     16a
     D  Status                       10a
     D  JobTyp                        1a
     D  JobSubTyp                     1a
     D                                2a
     D  JobInfSts                     1a
     D                                3a
     **-- Key information:
     D KeyInf          Ds                  Qualified
     D  FldNbrRtn                    10i 0
     D  KeyStr                       20a   Dim( %Elem( LstApi.KeyFld ))
     D   FldInfLen                   10i 0 Overlay( KeyStr:  1 )
     D   KeyFld                      10i 0 Overlay( KeyStr:  5 )
     D   DtaTyp                       1a   Overlay( KeyStr:  9 )
     D                                3a   Overlay( KeyStr: 10 )
     D   DtaLen                      10i 0 Overlay( KeyStr: 13 )
     D   DtaOfs                      10i 0 Overlay( KeyStr: 17 )
     **-- Sort information:
     D SrtInf          Ds                  Qualified
     D  NbrKeys                      10i 0 Inz( 0 )
     D  SrtStr                       12a   Dim( 3 )
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
     **-- Selection information:
     D OLJS0200        Ds                  Qualified
     D  JobNam                       10a
     D  UsrPrf                       10a
     D  JobNbr                        6a   Inz( '*ALL' )
     D  JobTyp                        1a
     D                                1a
     D  OfsPriSts                    10i 0 Inz( 108 )
     D  NbrPriSts                    10i 0 Inz( 0 )
     D  OfsActSts                    10i 0 Inz( 128 )
     D  NbrActSts                    10i 0 Inz( 0 )
     D  OfsJbqSts                    10i 0 Inz( 136 )
     D  NbrJbqSts                    10i 0 Inz( 0 )
     D  OfsJbqNam                    10i 0 Inz( 146 )
     D  NbrJbqNam                    10i 0 Inz( 0 )
     D  OfsCurUsr                    10i 0 Inz( 166 )
     D  NbrCurUsr                    10i 0 Inz( 0 )
     D  OfsSvrTyp                    10i 0 Inz( 176 )
     D  NbrSvrTyp                    10i 0 Inz( 0 )
     D  OfsActSbs                    10i 0 Inz( 206 )
     D  NbrActSbs                    10i 0 Inz( 0 )
     D  OfsMemPool                   10i 0 Inz( 216 )
     D  NbrMemPool                   10i 0 Inz( 0 )
     D  OfsJobTypE                   10i 0 Inz( 220 )
     D  NbrJobTypE                   10i 0 Inz( 0 )
     D  OfsJobNamQ                   10i 0 Inz( 228 )
     D  NbrJobNamQ                   10i 0 Inz( 0 )
     **
     D  PriSts                       10a   Dim( 2 )
     D  ActSts                        4a   Dim( 2 )
     D  JbqSts                       10a   Dim( 1 )
     D  JbqNam                       20a   Dim( 1 )
     D  CurUsr                       10a   Dim( 1 )
     D  SvrTyp                       30a   Dim( 1 )
     D  ActSbs                       10a   Dim( 1 )
     D  MemPool                      10i 0 Dim( 1 )
     D  JobTypE                      10i 0 Dim( 1 )
     D  JobNamQ                      26a   Dim( 1 )
     **-- Job information key fields:
     D KeyDta          Ds                  Qualified
     D  JobEntDts                    13a
     D   JobEntDat                    7a   Overlay( JobEntDts: 1 )
     D   JobEntTim                    6a   Overlay( JobEntDts: *Next )
     D  JobActDts                    13a
     D   JobActDat                    7a   Overlay( JobActDts: 1 )
     D   JobActTim                    6a   Overlay( JobActDts: *Next )
     D  ActJobSts                     4a
     D  JobDat                        7a
     D  CurUsr                       10a
     D  JobCmpSts                     1a
     D  FncNam                       10a
     D  FncTyp                        1a
     D  MsgRpy                        1a
     D  JobQueSts                    10a
     D  SbmJob_q                     26a
     D   SbmJob                      10a   Overlay( SbmJob_q: 1 )
     D   SbmUsr                      10a   Overlay( SbmJob_q: *Next )
     D   SbmNbr                       6a   Overlay( SbmJob_q: *Next )
 
     **-- Open list of jobs:
     D LstJobs         Pr                  ExtPgm( 'QGYOLJOB' )
     D  RcvVar                    65535a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  RcvVarDfn                 65535a          Options( *VarSize )
     D  RcvDfnLen                    10i 0 Const
     D  LstInf                       80a
     D  NbrRcdRtn                    10i 0 Const
     D  SrtInf                     1024a   Const  Options( *VarSize )
     D  JobSltInf                  1024a   Const  Options( *VarSize )
     D  JobSltLen                    10i 0 Const
     D  NbrFldRtn                    10i 0 Const
     D  KeyFldRtn                    10i 0 Const  Options( *VarSize )  Dim( 32 )
     D  Error                      1024a          Options( *VarSize )
     D  JobSltFmt                     8a   Const  Options( *NoPass )
     D  ResStc                        1a   Const  Options( *NoPass )
     D  GenRtnDta                    32a          Options( *NoPass: *VarSize )
     D  GenRtnDtaLn                  10i 0 Const  Options( *NoPass )
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
     **-- Register activation group exit:
     D CEE4RAGE        Pr                    ExtProc( 'CEE4RAGE' )
     D  procedure                      *     ProcPtr  Const
     D  fb                           12a     Options( *Omit )
 
     **-- Terminate activation group exit:
     D TrmActGrp       Pr
     D  ActGrpMrk                    10u 0
     D  Reason                       10u 0
     D  Gen_RC                       10u 0
     D  Usr_RC                       10u 0
 
     D CBX977L         Pr
     D  PxType6                            LikeDs( Type6 )
     **
     D CBX977L         Pi
     D  PxType6                            LikeDs( Type6 )
 
      /Free
 
        GetDlgVar( PxType6.AppHdl
                 : CtlRcd
                 : %Size( CtlRcd )
                 : 'CTLRCD'
                 : ERRC0100
                 );
 
        If  CtlRcd.Action = 'LIST'  Or  CtlRcd.Action = 'F05';
          ExSr  BldJobLst;
        EndIf;
 
        ExSr  PrcJobLst;
 
        CtlRcd.EntLocOpt = UIM.EntLocOpt;
        CtlRcd.Action = *Blanks;
 
        PutDlgVar( PxType6.AppHdl
                 : CtlRcd
                 : %Size( CtlRcd )
                 : 'CTLRCD'
                 : ERRC0100
                 );
 
        Return;
 
 
        BegSr  BldJobLst;
 
          If  LstInf.Handle <> *Blanks;
            CloseLst( LstInf.Handle: ERRC0100 );
          EndIf;
 
          UIM.EntLocOpt = 'FRST';
 
          LstApi.RtnRcdNbr = 1;
 
          LstJobs( OLJB0200
                 : %Size( OLJB0200 )
                 : 'OLJB0200'
                 : KeyInf
                 : %Size( KeyInf )
                 : LstInf
                 : BLD_SYNCH
                 : SrtInf
                 : OLJS0200
                 : %Size( OLJS0200 )
                 : LstApi.NbrFldRtn
                 : LstApi.KeyFld
                 : ERRC0100
                 : 'OLJS0200'
                 );
 
          If  ERRC0100.BytAvl > *Zero  Or  LstInf.RcdNbrRtn = *Zero;
            LstApi.RtnRcdNbr = -1;
 
          Else;
            ExSr  PrcLstEnt;
          EndIf;
 
        EndSr;
 
        BegSr  PrcJobLst;
 
          If  LstApi.RtnRcdNbr > *Zero;
            LstApi.CurRcdNbr = *Zero;
 
            DoW  LstInf.RcdNbrTot > LstApi.RtnRcdNbr;
 
              LstApi.RtnRcdNbr += 1;
 
              GetOplEnt( OLJB0200
                       : %Size( OLJB0200 )
                       : LstInf.Handle
                       : LstInf
                       : SNG_ENT
                       : LstApi.RtnRcdNbr
                       : ERRC0100
                       );
 
              If  ERRC0100.BytAvl > *Zero;
                Leave;
              EndIf;
 
              ExSr  PrcLstEnt;
 
              If  LstApi.CurRcdNbr >= MIN_NBR_ENT  And
                  LstApi.CurRcdNbr >= PxType6.NbrEntRqd;
 
                Leave;
              EndIf;
            EndDo;
          EndIf;
 
          Select;
          When  LstApi.RtnRcdNbr = -1;
            UIM.LstCnt = LIST_COMP;
 
          When  LstInf.RcdNbrTot <= LstApi.RtnRcdNbr;
            UIM.LstCnt = LIST_COMP;
 
          Other;
            UIM.LstCnt = LIST_TOP;
          EndSl;
 
          SetLstAtr( PxType6.AppHdl
                   : 'DTLLST'
                   : UIM.LstCnt
                   : EXIT_SAME
                   : POS_SAME
                   : TRIM_SAME
                   : ERRC0100
                   );
 
        EndSr;
 
        BegSr  PrcLstEnt;
 
          Clear  KeyDta;
 
          For Idx = 1  To KeyInf.FldNbrRtn;
 
            KeyDtaVal = %SubSt( OLJB0200
                              : KeyInf.DtaOfs(Idx) + 1
                              : KeyInf.DtaLen(Idx)
                              );
 
            Select;
            When  KeyInf.KeyFld(Idx) = 101;
              KeyDta.ActJobSts = KeyDtaVal;
 
            When  KeyInf.KeyFld(Idx) = 305;
              KeyDta.CurUsr = KeyDtaVal;
 
            When  KeyInf.KeyFld(Idx) = 306;
              KeyDta.JobCmpSts = KeyDtaVal;
 
            When  KeyInf.KeyFld(Idx) = 401;
              KeyDta.JobActDts = KeyDtaVal;
 
            When  KeyInf.KeyFld(Idx) = 402;
              KeyDta.JobEntDts = KeyDtaVal;
 
            When  KeyInf.KeyFld(Idx) = 601;
              KeyDta.FncNam = KeyDtaVal;
 
            When  KeyInf.KeyFld(Idx) = 602;
              KeyDta.Fnctyp = KeyDtaVal;
 
            When  KeyInf.KeyFld(Idx) = 1002;
              KeyDta.JobDat = KeyDtaVal;
 
            When  KeyInf.KeyFld(Idx) = 1307;
              KeyDta.MsgRpy = KeyDtaVal;
 
            When  KeyInf.KeyFld(Idx) = 1903;
              KeyDta.JobQueSts = KeyDtaVal;
 
            When  KeyInf.KeyFld(Idx) = 1904;
              KeyDta.SbmJob_q = KeyDtaVal;
            EndSl;
          EndFor;
 
          If  PrmRcd.CmpSts = '*ALL'  Or
              PrmRcd.CmpSts = '*NORMAL'  And  KeyDta.JobCmpSts = '0'  Or
              PrmRcd.CmpSts = '*ABNORMAL'  And  KeyDta.JobCmpSts = '1';
 
            ExSr  PutLstEnt;
          EndIf;
 
        EndSr;
 
        BegSr  PutLstEnt;
 
          LstApi.CurRcdNbr += 1;
 
          LstEnt.Option = *Zero;
          LstEnt.EntId  = KeyDta.JobEntDts + OLJB0200.JobNbr;
          LstEnt.JobNam = OLJB0200.JobNam;
          LstEnt.JobUsr = OLJB0200.UsrPrf;
          LstEnt.JobNbr = OLJB0200.JobNbr;
          LstEnt.JobTyp = OLJB0200.JobTyp;
          LstEnt.JobSts1 = OLJB0200.Status;
 
          LstEnt.JobDat = KeyDta.JobDat;
          LstEnt.EntDat = KeyDta.JobEntDat;
          LstEnt.EntTim = KeyDta.JobEntTim;
          LstEnt.ActDat = KeyDta.JobActDat;
          LstEnt.ActTim = KeyDta.JobActTim;
          LstEnt.MsgRpy = KeyDta.MsgRpy;
          LstEnt.SbmJob = KeyDta.SbmJob;
          LstEnt.SbmUsr = KeyDta.SbmUsr;
          LstEnt.SbmNbr = KeyDta.SbmNbr;
 
          Select;
          When  OLJB0200.Status = '*ACTIVE';
            LstEnt.CurUsr = KeyDta.CurUsr;
            LstEnt.JobSts2 = KeyDta.ActJobSts;
 
          When  OLJB0200.Status = '*JOBQ';
            LstEnt.CurUsr = OLJB0200.UsrPrf;
            LstEnt.JobSts2 = KeyDta.JobQueSts;
 
          Other;
            LstEnt.CurUsr = OLJB0200.UsrPrf;
            LstEnt.JobSts2 = *Blanks;
          EndSl;
 
          Select;
          When  OLJB0200.Status = '*ACTIVE';
 
            Select;
            When  KeyDta.FncTyp = 'C';
              LstEnt.FncCmp = 'CMD-' + KeyDta.FncNam;
 
            When  KeyDta.FncTyp = 'D';
              LstEnt.FncCmp = 'DLY-' + KeyDta.FncNam;
 
            When  KeyDta.FncTyp = 'G';
              LstEnt.FncCmp = 'GRP-' + KeyDta.FncNam;
 
            When  KeyDta.FncTyp = 'I';
              LstEnt.FncCmp = 'IDX-' + KeyDta.FncNam;
 
            When  KeyDta.FncTyp = 'J';
              LstEnt.FncCmp = 'JVM-' + KeyDta.FncNam;
 
            When  KeyDta.FncTyp = 'L';
              LstEnt.FncCmp = 'LOG-' + KeyDta.FncNam;
 
            When  KeyDta.FncTyp = 'M';
              LstEnt.FncCmp = 'MRT-' + KeyDta.FncNam;
 
            When  KeyDta.FncTyp = 'N';
              LstEnt.FncCmp = 'MNU-' + KeyDta.FncNam;
 
            When  KeyDta.FncTyp = 'O';
              LstEnt.FncCmp = 'I/O-' + KeyDta.FncNam;
 
            When  KeyDta.FncTyp = 'P';
              LstEnt.FncCmp = 'PGM-' + KeyDta.FncNam;
 
            When  KeyDta.FncTyp = 'R';
              LstEnt.FncCmp = 'PRC-' + KeyDta.FncNam;
 
            When  KeyDta.FncTyp = '*';
              LstEnt.FncCmp = '*  -' + KeyDta.FncNam;
 
            Other;
              LstEnt.FncCmp = *Blanks;
            EndSl;
 
          When  OLJB0200.Status = '*OUTQ';
 
            Select;
            When  KeyDta.JobCmpSts = *Blanks;
              LstEnt.FncCmp = *Blanks;
 
            When  KeyDta.JobCmpSts = '0';
              LstEnt.FncCmp = '*NORMAL';
 
            When  KeyDta.JobCmpSts = '1';
              LstEnt.FncCmp = '*ABNORMAL';
            EndSl;
 
          Other;
            LstEnt.FncCmp = *Blanks;
          EndSl;
 
          AddLstEnt( PxType6.AppHdl
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
 
        BegSr  *InzSr;
 
          CEE4RAGE( %Paddr( TrmActGrp ): *Omit );
 
          GetDlgVar( PxType6.AppHdl
                   : PrmRcd
                   : %Size( PrmRcd )
                   : 'PRMRCD'
                   : ERRC0100
                   );
 
          OLJS0200.JobNam = PrmRcd.JobNam;
          OLJS0200.UsrPrf = PrmRcd.UsrPrf;
          OLJS0200.JobTyp = PrmRcd.JobTyp;
 
          Select;
          When  PrmRcd.JobSts = '*ALL';
            OLJS0200.NbrPriSts = *Zero;
 
          When  PrmRcd.JobSts = '*NONOUTQ';
            OLJS0200.NbrPriSts = 2;
            OLJS0200.PriSts(1) = '*JOBQ';
            OLJS0200.PriSts(2) = '*ACTIVE';
 
          Other;
            OLJS0200.NbrPriSts = 1;
            OLJS0200.PriSts(1) = PrmRcd.JobSts;
          EndSl;
 
          If  PrmRcd.CurUsr > *Blanks;
            OLJS0200.NbrCurUsr = 1;
            OLJS0200.CurUsr(1) = PrmRcd.CurUsr;
            OLJS0200.UsrPrf = '*ALL';
          EndIf;
 
          SrtInf.NbrKeys      = 2;
          SrtInf.KeyFldOfs(1) = 61;
          SrtInf.KeyFldLen(1) = %Size( KeyDta.JobEntDts );
          SrtInf.KeyFldTyp(1) = NUM_ZON;
          SrtInf.SrtOrd(1)    = SORT_DSC;
          SrtInf.Rsv(1)       = x'00';
 
          SrtInf.KeyFldOfs(2) = 21;
          SrtInf.KeyFldLen(2) = %Size( OLJB0200.JobNbr );
          SrtInf.KeyFldTyp(2) = NUM_ZON;
          SrtInf.SrtOrd(2)    = SORT_DSC;
          SrtInf.Rsv(2)       = x'00';
 
          LstApi.KeyFld(1) = 402;
          LstApi.KeyFld(2) = 401;
          LstApi.KeyFld(3) = 101;
          LstApi.KeyFld(4) = 305;
          LstApi.KeyFld(5) = 306;
          LstApi.KeyFld(6) = 601;
          LstApi.KeyFld(7) = 602;
          LstApi.KeyFld(8) = 1002;
          LstApi.KeyFld(9) = 1307;
          LstApi.KeyFld(10) = 1903;
          LstApi.KeyFld(11) = 1904;
 
        EndSr;
 
      /End-Free
 
     **-- Terminate activation group exit:
     P TrmActGrp       B
     D                 Pi
     D  ActGrpMrk                    10u 0
     D  Reason                       10u 0
     D  Gen_RC                       10u 0
     D  Usr_RC                       10u 0
 
      /Free
 
        If  LstInf.Handle <> *Blanks;
          CloseLst( LstInf.Handle: ERRC0100 );
        EndIf;
 
        *InLr = *On;
 
        Return;
 
      /End-Free
 
     P TrmActGrp       E
