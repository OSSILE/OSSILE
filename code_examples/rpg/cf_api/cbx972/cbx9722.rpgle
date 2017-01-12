     **
     **  Program . . : CBX9722
     **  Description : Work with Profile Security Attributes - CPP 2
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **  Program summary
     **  ---------------
     **
     **
     **  Compilation specification:
     **    CrtRpgMod  Module( CBX9722 )
     **               DbgView( *LIST )
     **
     **    CrtPgm     Pgm( CBX9722 )
     **               Module( CBX9722 )
     **               ActGrp( *CALLER )
     **
     **
     **-- Header specifications:  --------------------------------------------**
     H Option( *SrcStmt )  BndDir( 'QC2LE' )
 
     **-- Api error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                     1024a
 
     **-- Global constants:
     D OFS_MSGDTA      c                   16
     D NO_LOCK         c                   x'00000001'
     D RPL_NO          c                   '0'
     D RPL_YES         c                   '1'
     **
     D PWD_FIL         c                   'QASECPWD'
     D PWD_LIB         c                   'QUSRSYS'
     **-- Global variables:
     D IdxNam_q        s             20a
     D RcdCnt          s             10u 0
     **
     D pRFILE          s               *
     D rc              s             10i 0
     **-- File record buffer:
     D QASECPWD      E Ds                  ExtName( QASECPWD )  Qualified
 
     **-- I/O feedback structure:
     D RIOFB_T         Ds                  Based( pRIOFB_T )  Qualified
     D  pKey                           *
     D  pSysParm                       *
     D  RcdRrn                       10u 0
     D  NbrBytRw                     10i 0
     D  BlkCnt                        5i 0
     D  BlkFllBy                      1a
     D  BitFld                        1a
     D  Rsv                          20a
 
     **-- Retrieve object description:
     D RtvObjD         Pr                  ExtPgm( 'QUSROBJD' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  ObjNamQ                      20a   Const
     D  ObjTyp                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Retrieve member description:
     D RtvMbrD         Pr                  ExtPgm( 'QUSRMBRD' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  DbfNam_q                     20a   Const
     D  DbfMbr                       10a   Const
     D  OvrPrc                        1a   Const
     D  Error                     32767a          Options( *NoPass: *VarSize )
     D  FndMbrPrc                     1a   Const  Options( *NoPass )
     **-- Remove program message:
     D RmvPgmMsg       Pr                  ExtPgm( 'QMHRMVPM' )
     D  CalStkE                      10a   Const
     D  CalStkCtr                    10i 0 Const
     D  MsgKey                        4a   Const
     D  RmvOpt                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Execute command:
     D ExcCmd          Pr                  ExtPgm( 'QCMDEXC' )
     D  CmdStr                     4096a   Const  Options( *VarSize )
     D  CmdLen                       15p 5 Const
     D  CmdIGC                        3a   Const  Options( *NoPass )
 
     **-- Create user index:
     D CrtUsrIdx       Pr                  ExtPgm( 'QUSCRTUI' )
     D  IdxNam_q                     20a   Const
     D  ExtAtr                       10a   Const
     D  EntAtr                        1a   Const
     D  EntLen                       10i 0 Const
     D  KeyIns                        1a   Const
     D  KeyLen                       10i 0 Const
     D  IdxUpd                        1a   Const
     D  IdxOpz                        1a   Const
     D  PubAut                       10a   Const
     D  TxtDsc                       50a   Const
     D  Replace                      10a   Const  Options( *NoPass )
     D  Error                     32767a          Options( *NoPass: *VarSize )
     D  Domain                       10a   Const  Options( *NoPass )
     **-- Delete user index:
     D DltUsrIdx       Pr                  ExtPgm( 'QUSDLTUI' )
     D  IdxNam_q                     20a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Retrieve user index attributes:
     D RtvUsrIdxA      Pr                  ExtPgm( 'QUSRUIAT' )
     D  RcvVar                       60a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                       10a   Const
     D  IdxNam_q                     20a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Add user index entries:
     D AddIdxEnt       Pr                  ExtPgm( 'QUSADDUI' )
     D  RtnLib                       10a
     D  EntAdd                       10i 0
     D  IdxNam_q                     20a   Const
     D  InsTyp                       10i 0 Const
     D  Entry                      2000a   Const  Options( *VarSize )
     D  EntLen                       10i 0 Const
     D  EntLoc                        8a   Const
     D  EntNbr                       10i 0 Const
     D  Error                     32767a          Options( *VarSize )
     **-- Remove user index entries:
     D RmvUsrIdxE      Pr                  ExtPgm( 'QUSRMVUI' )
     D  EntNbrRmv                    10i 0
     D  RcvVar                     2008a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  EntLoc                     2000a          Options( *VarSize )
     D  EntLocLen                    10i 0 Const
     D  RtnLib                       10a   Const
     D  IdxNam_q                     20a   Const
     D  FmtNam                       10a   Const
     D  MaxEnt                       10i 0 Const
     D  RmvTyp                       10i 0 Const
     D  RmvCri                     2000a   Const  Options( *Varsize )
     D  RmvCriLen                    10i 0 Const
     D  RmvCriOfs                    10i 0 Const
     D  Error                     32767a          Options( *VarSize )
 
     **-- Open file:
     D Ropen           Pr              *   ExtProc( '_Ropen' )
     D  pRFile                         *   Value  Options( *String: *Trim )
     D  pMode                          *   Value  Options( *String )
     D  pOptParm                       *   Value  Options( *String: *NoPass )
     **-- Close file:
     D Rclose          Pr            10i 0 ExtProc( '_Rclose' )
     D  pRFile                         *   Value
     **-- Read first record:
     D Rreadf          Pr              *   ExtProc( '_Rreadf' )
     D  pRFile                         *   Value
     D  pBuffer                        *   Value
     D  BufLen                       10u 0 Value
     D  Options                      10i 0 Value
     **-- Read next record:
     D Rreadn          Pr              *   ExtProc( '_Rreadn' )
     D  pRFile                         *   Value
     D  pBuffer                        *   Value
     D  BufLen                       10u 0 Value
     D  Options                      10i 0 Value
     **-- Temporary file name:
     D tmpnam          Pr              *   ExtProc( 'tmpnam' )
     D   string                      39a   Options( *Omit )
 
     **-- Create user index:
     D CrtIdx          Pr            10i 0
     D  PxIdxNam_q                   20a   Const
     D  PxObjAtr                     10a   Const
     D  PxEntSiz                     10i 0 Const
     D  PxKeySiz                     10i 0 Const
     **-- Get current number of entries:
     D GetCurNbrE      Pr            10i 0
     D  PxIdxNam_q                   20a   Const
     **-- Clear user index:
     D ClrIdx          Pr            10i 0
     D  PxIdxNam_q                   20a   Const
     D  PxKeySiz                     10i 0 Const
     **-- Delete user index:
     D DltIdx          Pr            10i 0
     D  PxIdxNam_q                   20a   Const
     **-- Add index entry (replace):
     D AddIdxEnt_r     Pr            10i 0
     D  PxIdxNam_q                   20a   Const
     D  PxIdxEnt                   1024a   Const  Varying
     **-- Check object existence:
     D ChkObj          Pr              n
     D  PxObjNam                     10a   Const
     D  PxObjLib                     10a   Const
     D  PxObjTyp                     10a   Const
     **-- Retrieve number of records:
     D RtvNbrRcd       Pr            10u 0
     D  PxSrcFil                     10a   Const
     D  PxSrcLib                     10a   Const
     D  PxMbrNam                     10a   Const
     **-- Convert name to API qualified:
     D CvtNamApi_q     Pr            20a
     D  PxLibObj_q                   21a   Const
     **-- Run command:
     D RunCmd          Pr            10i 0
     D  PxCmdStr                   4096a   Const  Varying
 
     **-- Entry parameters:
     D CBX9722         Pr
     D  PxIdxNam_q                   20a
     **
     D CBX9722         Pi
     D  PxIdxNam_q                   20a
 
      /Free
 
        If  %Parms = *Zero;
 
          If  IdxNam_q > *Blanks;
            DltIdx( IdxNam_q );
          EndIf;
 
          *InLr = *On;
 
        Else;
          If  IdxNam_q = *Blanks;
            IdxNam_q = CvtNamApi_q( %Str( tmpnam( *Omit )));
 
            CrtIdx( IdxNam_q
                  : PWD_FIL
                  : %Size( QASECPWD )
                  : %Size( QASECPWD.DFUSRP )
                  );
          Else;
 
            ClrIdx( IdxNam_q: %Size( QASECPWD.DFUSRP ));
          EndIf;
 
          RunCmd( 'OVRPRTF FILE(QSYSPRT) HOLD(*YES) SECURE(*YES) ' +
                  'OVRSCOPE(*JOB)'
                );
 
          If  ChkObj( PWD_FIL: PWD_LIB: '*FILE' ) = *Off;
            ExSr  LodPwdTemp;
          Else;
            ExSr  LodPwdPerm;
          EndIf;
 
          RunCmd( 'DLTSPLF FILE(QPSECPWD) JOB(*) SPLNBR(*LAST)' );
 
          RunCmd( 'DLTOVR FILE(QSYSPRT) LVL(*JOB)' );
 
          PxIdxNam_q = IdxNam_q;
        EndIf;
 
        Return;
 
 
        BegSr  LodPwdPerm;
 
          RcdCnt = RtvNbrRcd( PWD_FIL: PWD_LIB: '*FIRST' );
 
          RunCmd( 'ANZDFTPWD ACTION(*NONE)' );
 
          ExSr  LodPwdIdx;
 
          If  RcdCnt = *Zero;
            RunCmd( 'CLRPFM FILE(' + PWD_LIB + '/' + PWD_FIL + ') MBR(*ALL) ');
          EndIf;
 
        EndSr;
 
        BegSr  LodPwdTemp;
 
          RunCmd( 'CRTDUPOBJ OBJ(' + PWD_FIL   + ')' +
                           ' FROMLIB(QSYS)'    +
                           ' OBJTYPE(*FILE)'   +
                           ' TOLIB(' + PWD_LIB + ')' +
                           ' NEWOBJ(*OBJ)'     +
                           ' DATA(*NO)'
                );
 
          RunCmd( 'ANZDFTPWD ACTION(*NONE)' );
 
          ExSr  LodPwdIdx;
 
          RunCmd( 'DLTF FILE(' + PWD_LIB + '/' + PWD_FIL + ')' );
 
        EndSr;
 
        BegSr  LodPwdIdx;
 
          pRFILE = Ropen( PWD_LIB + '/' + PWD_FIL: 'rr' );
 
          If  pRFILE <> *Null;
 
            pRIOFB_T = Rreadf( pRFILE
                             : %Addr( QASECPWD )
                             : %Size( QASECPWD )
                             : NO_LOCK
                             );
 
            DoW  RIOFB_T.NbrBytRw > *Zero;
 
              AddIdxEnt_r( IdxNam_q: %Subst( QASECPWD: 1: RIOFB_T.NbrBytRw ));
 
              pRIOFB_T = Rreadn( pRFILE
                               : %Addr( QASECPWD )
                               : %Size( QASECPWD )
                               : NO_LOCK
                               );
 
            EndDo;
 
            rc = Rclose( pRFILE );
          EndIf;
 
        EndSr;
 
      /End-Free
 
     **-- Create user index:
     P CrtIdx          B
     D                 Pi            10i 0
     D  PxIdxNam_q                   20a   Const
     D  PxObjAtr                     10a   Const
     D  PxEntSiz                     10i 0 Const
     D  PxKeySiz                     10i 0 Const
 
     **-- Local constants:
     D ENT_FIX         c                   'F'
     D UPD_IMD         c                   '1'
     D AUT_CHG         c                   '*CHANGE'
     D RPL_YES         c                   '*YES'
     D IDX_OPZ_SEQ     c                   '0'
     D KEY_INS_BYKEY   c                   '1'
     D DOM_DFT         c                   '*DEFAULT'
 
      /Free
 
        CrtUsrIdx( PxIdxNam_q
                 : PxObjAtr
                 : ENT_FIX
                 : PxEntSiz
                 : KEY_INS_BYKEY
                 : PxKeySiz
                 : UPD_IMD
                 : IDX_OPZ_SEQ
                 : AUT_CHG
                 : *Blanks
                 : RPL_YES
                 : ERRC0100
                 : DOM_DFT
                 );
 
        If  ERRC0100.BytAvl > *Zero;
          Return -1;
 
        Else;
          RmvPgmMsg( '*': *Zero: *Blanks: '*NEW': ERRC0100 );
 
          Return  *Zero;
        EndIf;
 
      /End-Free
 
     P CrtIdx          E
     **-- Delete user index:
     P DltIdx          B
     D                 Pi            10i 0
     D  PxIdxNam_q                   20a   Const
 
      /Free
 
        DltUsrIdx( PxIdxNam_q: ERRC0100 );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  -1;
 
        Else;
          RmvPgmMsg( '*': *Zero: *Blanks: '*NEW': ERRC0100 );
 
          Return  *Zero;
        EndIf;
 
      /End-Free
 
     P DltIdx          E
     **-- Add index entry (replace):
     P AddIdxEnt_r     B
     D                 Pi            10i 0
     D  PxIdxNam_q                   20a   Const
     D  PxIdxEnt                   1024a   Const  Varying
     **
     D NbrEntAdd       s             10i 0
     D IdxRtnLib       s             10a
     **
     D ADD_SNG_ENT     c                   1
     D IDX_INS_RPL     c                   2
     D ENT_LOC_IGN     c                   x'0000000000000000'
 
      /Free
 
        AddIdxEnt( IdxRtnLib
                 : NbrEntAdd
                 : PxIdxNam_q
                 : IDX_INS_RPL
                 : PxIdxEnt
                 : %Len( PxIdxEnt )
                 : ENT_LOC_IGN
                 : ADD_SNG_ENT
                 : ERRC0100
                 );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  -1;
 
        Else;
          Return  *Zero;
        EndIf;
 
      /End-Free
 
     P AddIdxEnt_r     E
     **-- Clear user index:
     P ClrIdx          B
     D                 Pi            10i 0
     D  PxIdxNam_q                   20a   Const
     D  PxKeySiz                     10i 0 Const
 
     **-- Local variables:
     D IDXE0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     **
     D EntLoc          Ds                  Qualified
     D  EntOfs                       10i 0
     D  EntLen                       10i 0
     **
     D EntNbrRmv       s             10i 0
     D RtnLib          s             10a
     **-- Local constants:
     D RTN_ENT_NONE    c                   0
     D RMV_ENT_MAX     c                   4095
     D ENT_RMV_GE      c                   4
     D CRI_OFS_FIRST   c                   0
 
      /Free
 
        DoW  GetCurNbrE( PxIdxNam_q ) > *Zero;
 
          RmvUsrIdxE( EntNbrRmv
                    : IDXE0100
                    : RTN_ENT_NONE
                    : EntLoc
                    : RTN_ENT_NONE
                    : RtnLib
                    : PxIdxNam_q
                    : 'IDXE0100'
                    : RMV_ENT_MAX
                    : ENT_RMV_GE
                    : *LoVal
                    : PxKeySiz
                    : CRI_OFS_FIRST
                    : ERRC0100
                    );
 
          If  ERRC0100.BytAvl > *Zero;
            Return  -1;
          EndIf;
        EndDo;
 
        Return  *Zero;
 
      /End-Free
 
     P ClrIdx          E
     **-- Get current number of entries:
     P GetCurNbrE      B
     D                 Pi            10i 0
     D  PxIdxNam_q                   20a   Const
 
     **-- Retrieve user index attributes parameters:
     D IDXA0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  IdxNam                       10a
     D  LibNam                       10a
     D  EntAtr                        1a
     D  IdxUpd                        1a
     D  KeyIns                        1a
     D  IdxOpz                        1a
     D                                4a
     D  EntLen                       10i 0
     D  EntLenMax                    10i 0
     D  KeyLen                       10i 0
     D  NbrEntAdd                    10i 0
     D  NbrEntRmv                    10i 0
     D  NbrRtvOpr                    10i 0
 
      /Free
 
        RtvUsrIdxA( IDXA0100
                  : %Size( IDXA0100 )
                  : 'IDXA0100'
                  : PxIdxNam_q
                  : ERRC0100
                  );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  -1;
 
        Else;
          Return  IDXA0100.NbrEntAdd - IDXA0100.NbrEntRmv;
        EndIf;
 
      /End-Free
 
     P GetCurNbrE      E
     **-- Check object existence:
     P ChkObj          B
     D                 Pi              n
     D  PxObjNam                     10a   Const
     D  PxObjLib                     10a   Const
     D  PxObjTyp                     10a   Const
     **
     D OBJD0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  ObjNam                       10a
     D  ObjLib                       10a
     D  ObjTyp                       10a
 
      /Free
 
        RtvObjD( OBJD0100
               : %Size( OBJD0100 )
               : 'OBJD0100'
               : PxObjNam + PxObjLib
               : PxObjTyp
               : ERRC0100
               );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  *Off;
 
        Else;
          Return  *On;
        EndIf;
 
      /End-Free
 
     P ChkObj          E
     **-- Retrieve number of records:
     P RtvNbrRcd       B
     D                 Pi            10u 0
     D  PxSrcFil                     10a   Const
     D  PxSrcLib                     10a   Const
     D  PxMbrNam                     10a   Const
 
     **-- Member description:
     D MBRD0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  DbfNam                       10a
     D  DbfLib                       10a
     D  MbrNam                       10a
     D  FilAtr                       10a
     D  SrcTyp                       10a
     D  CrtDts                       13a
     D  SrcChgDts                    13a
     D  MbrTxt                       50a
     D  SrcF                          1a
     **-- Member description 0200:
     D MBRD0200        Ds                  Qualified
     D  MBRD0100                           LikeDs( MBRD0100 )
     D  RmtFil                        1a
     D  FilTyp                        1a
     D  OdpShr                        1a
     D                                2a
     D  CurTotRcd                    10i 0
     D  CurDltRcd                    10i 0
     D  DtaSpcSiz                    10i 0
     D  AccPthSiz                    10i 0
     D  NbrBsoPfm                    10i 0
     D  ChgDts                       13a
     D  SavDts                       13a
     D  RstDts                       13a
     D  ExpDat                        7a
     D                                6a
     D  NbrDayUsd                    10i 0
     D  DatLstUsd                     7a
     D  DatRstUsd                     7a
     D                                2a
     D  DtaSpcMtp                    10i 0
     D  AccPthMtp                    10i 0
     D  MbrTxtCcsId                  10i 0
     D  AddInfOfs                    10i 0
     D  AddInfLen                    10i 0
     D  CurTotRcdT                   10u 0
     D  CurDltRcdT                   10u 0
     D                                6a
     **-- Local constants:
     D MBD_NOTOVRPRC   c                   '0'
 
      /Free
 
        RtvMbrD( MBRD0200
               : %Size( MBRD0200 )
               : 'MBRD0200'
               : PxSrcFil + PxSrcLib
               : PxMbrNam
               : MBD_NOTOVRPRC
               : ERRC0100
               );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  -1;
        Else;
          Return  MBRD0200.CurTotRcdT;
        EndIf;
 
      /End-Free
 
     P RtvNbrRcd       E
     **-- Convert name to API qualified:
     P CvtNamApi_q     B
     D                 Pi            20a
     D  PxLibObj_q                   21a   Const
 
     **-- Local variables:
     D ScnPos          s             10i 0
     **
     D ObjNam_q        Ds                  Qualified
     D  ObjNam                       10a
     D  ObjLib                       10a
 
      /Free
 
        ScnPos = %Scan( '/': PxLibObj_q );
 
        If  ScnPos = *Zero;
          Return  PxLibObj_q;
 
        Else;
          ObjNam_q.ObjNam = %Subst( PxLibObj_q: ScnPos + 1 );
          ObjNam_q.ObjLib = %Subst( PxLibObj_q: 1: ScnPos - 1 );
 
          Return  ObjNam_q;
        EndIf;
 
      /End-Free
 
     P CvtNamApi_q     E
     **-- Run command:
     P RunCmd          B
     D                 Pi            10i 0
     D  PxCmdStr                   4096a   Const  Varying
 
      /Free
 
        Monitor;
          ExcCmd( PxCmdStr: %Len( PxCmdStr ));
 
        On-Error;
          Return  -1;
        EndMon;
 
        RmvPgmMsg( '*': *Zero: *Blanks: '*NEW': ERRC0100 );
 
        Return  *Zero;
 
      /End-Free
 
     P RunCmd          E
