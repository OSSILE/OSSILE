     **
     **  Program . . : CBX998E
     **  Description : Work with Subsystem Entries - UIM Exit Program
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod  Module( CBX998E )
     **               DbgView( *LIST )
     **
     **    CrtPgm     Pgm( CBX998E )
     **               Module( CBX998E )
     **               ActGrp( *CALLER )
     **
     **
     **-- Control specification:  --------------------------------------------**
     H Option( *SrcStmt )
 
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
     D  MsgDta                      512a
 
     **-- Global constants:
     D NULL            c                   ''
     D NO_ENT          c                   x'00000000'
     **-- UIM variables:
     D UIM             Ds                  Qualified
     D  EntHdl                        4a
     **-- UIM constants:
     D APP_PRTF        c                   'QPRINT    *LIBL'
     D ODP_SHR         c                   'N'
     D SPLF_NAM        c                   'PSBSE'
     D SPLF_USRDTA     c                   'WRKSBSE'
     D EJECT_NO        c                   'N'
     D CLO_NRM         c                   'M'
     D RES_OK          c                   0
     D RES_ERR         c                   1
 
     **-- UIM API return structures:
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
     D  SbsMonNbr                     6s 0
     D  SbsDsc                       50a
     **-- Control record:
     D CtlRcd          Ds                  Qualified
     D  MorOpt                        5i 0
 
     **-- UIM exit program interfaces:
     **-- Parm interface:
     D UimExit         Ds            70    Qualified
     D  StcLvl                       10i 0
     D                                8a
     D  TypCall                      10i 0
     D  AppHdl                        8a
     **-- Function key - call:
     D Type1           Ds                  Qualified
     D  StcLvl                       10i 0
     D                                8a
     D  TypCall                      10i 0
     D  AppHdl                        8a
     D  PnlNam                       10a
     D  FncKey                       10i 0
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
     **-- Update list entry:
     D UpdLstEnt       Pr                  ExtPgm( 'QUIUPDLE' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a   Const  Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
     D  LstNam                       10a   Const
     D  Option                        4a   Const
     D  LstEntHdl                     4a
     D  Error                     32767a          Options( *VarSize )
     **-- Remove list entry:
     D RmvLstEnt       Pr                  ExtPgm( 'QUIRMVLE' )
     D  AppHdl                        8a   Const
     D  LstNam                       10a   Const
     D  ExtOpt                        1a   Const
     D  LstEntHdl                     4a
     D  Error                     32767a          Options( *VarSize )
 
     **-- Get dialog variable:
     D GetDlgVar       Pr                  ExtPgm( 'QUIGETV' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a          Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Put dialog variable:
     D PutDlgVar       Pr                  ExtPgm( 'QUIPUTV' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a   Const  Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Print panel:
     D PrtPnl          Pr                  ExtPgm( 'QUIPRTP' )
     D  AppHdl                        8a   Const
     D  PrtPnlNam                    10a   Const
     D  EjtOpt                        1a   Const
     D  Error                     32767a          Options( *VarSize )
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
     **-- Remove print application:
     D RmvPrtApp       Pr                  ExtPgm( 'QUIRMVPA' )
     D  AppHdl                        8a   Const
     D  CloOpt                        1a   Const
     D  Error                     32767a          Options( *VarSize )
 
     **-- Process commands:
     D PrcCmds         Pr                  ExtPgm( 'QCAPCMD' )
     D  SrcCmd                    32702a   Const  Options( *VarSize )
     D  SrcCmdLen                    10i 0 Const
     D  OptCtlBlk                    20a   Const
     D  OptCtlBlkLn                  10i 0 Const
     D  OptCtlBlkFm                   8a   Const
     D  ChgCmd                    32767a          Options( *VarSize )
     D  ChgCmdLen                    10i 0 Const
     D  ChgCmdLenAv                  10i 0
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
 
     **-- Process command:
     D PrcCmd          Pr             7a
     D  CmdStr                     1024a   Const  Varying
     **-- Send completion message:
     D SndCmpMsg       Pr            10i 0
     D  PxMsgDta                    512a   Const  Varying
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying
 
     **-- Entry parameters:
     D CBX998E         Pr
     D  PxUimExit                          LikeDs( UimExit )
     **
     D CBX998E         Pi
     D  PxUimExit                          LikeDs( UimExit )
 
      /Free
 
        Select;
        When  PxUimExit.TypCall = 1;
          Type1 = PxUimExit;
 
          Select;
          When  Type1.FncKey = 21;
            ExSr  PrtJobPnl;
 
          When  Type1.FncKey = 23;
            ExSr  UpdMorOpt;
          EndSl;
 
        When  PxUimExit.TypCall = 5;
          Type5 = PxUimExit;
 
          If  Type5.ActRes = RES_OK;
 
            Select;
            When  Type5.OptNbr = 2;
              ExSr  ChgLstEnt;
 
            When  Type5.OptNbr = 9;
              ExSr  StrLstEnt;
 
            When  Type5.OptNbr = 10;
              ExSr  EndLstEnt;
 
            When  Type5.OptNbr = 4;
              ExSr  DltLstEnt;
            EndSl;
          EndIf;
        EndSl;
 
        Return;
 
 
        BegSr  PrtJobPnl;
 
          AddPrtApp( Type1.AppHdl
                   : APP_PRTF
                   : SPLF_NAM
                   : ODP_SHR
                   : SPLF_USRDTA
                   : ERRC0100
                   );
 
          PrtPnl( Type1.AppHdl
                : 'PRTHDR'
                : EJECT_NO
                : ERRC0100
                );
 
          PrtPnl( Type1.AppHdl
                : 'PRTLST'
                : EJECT_NO
                : ERRC0100
                );
 
          RmvPrtApp( Type1.AppHdl
                   : CLO_NRM
                   : ERRC0100
                   );
 
          SndCmpMsg( 'List has been printed.' );
 
        EndSr;
 
        BegSr  UpdMorOpt;
 
          GetDlgVar( Type1.AppHdl
                   : CtlRcd
                   : %Size( CtlRcd )
                   : 'CTLRCD'
                   : ERRC0100
                   );
 
          CtlRcd.MorOpt += 1;
 
          If  CtlRcd.MorOpt > 1;
            CtlRcd.MorOpt = *Zero;
          EndIf;
 
          PutDlgVar( Type1.AppHdl
                   : CtlRcd
                   : %Size( CtlRcd )
                   : 'CTLRCD'
                   : ERRC0100
                   );
 
        EndSr;
 
        BegSr  ChgLstEnt;
 
          GetLstEnt( Type5.AppHdl
                   : LstEnt
                   : %Size( LstEnt )
                   : 'DTLRCD'
                   : 'DTLLST'
                   : 'HNDL'
                   : 'Y'
                   : *Blanks
                   : Type5.LstEntHdl
                   : 'N'
                   : UIM.EntHdl
                   : ERRC0100
                   );
 
          LstEnt.SbsExtSts = '*CHG';
 
          UpdLstEnt( Type5.AppHdl
                   : LstEnt
                   : %Size( LstEnt )
                   : 'DTLRCD'
                   : 'DTLLST'
                   : 'SAME'
                   : UIM.EntHdl
                   : ERRC0100
                   );
 
        EndSr;
 
        BegSr  StrLstEnt;
 
          GetLstEnt( Type5.AppHdl
                   : LstEnt
                   : %Size( LstEnt )
                   : 'DTLRCD'
                   : 'DTLLST'
                   : 'HNDL'
                   : 'Y'
                   : *Blanks
                   : Type5.LstEntHdl
                   : 'N'
                   : UIM.EntHdl
                   : ERRC0100
                   );
 
          LstEnt.SbsExtSts = '*STR';
 
          UpdLstEnt( Type5.AppHdl
                   : LstEnt
                   : %Size( LstEnt )
                   : 'DTLRCD'
                   : 'DTLLST'
                   : 'SAME'
                   : UIM.EntHdl
                   : ERRC0100
                   );
 
        EndSr;
 
        BegSr  EndLstEnt;
 
          GetLstEnt( Type5.AppHdl
                   : LstEnt
                   : %Size( LstEnt )
                   : 'DTLRCD'
                   : 'DTLLST'
                   : 'HNDL'
                   : 'Y'
                   : *Blanks
                   : Type5.LstEntHdl
                   : 'N'
                   : UIM.EntHdl
                   : ERRC0100
                   );
 
          LstEnt.SbsExtSts = '*END';
 
          UpdLstEnt( Type5.AppHdl
                   : LstEnt
                   : %Size( LstEnt )
                   : 'DTLRCD'
                   : 'DTLLST'
                   : 'SAME'
                   : UIM.EntHdl
                   : ERRC0100
                   );
 
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
 
     **-- Process command:  --------------------------------------------------**
     P PrcCmd          B                   Export
     D                 Pi             7a
     D  PxCmdStr                   1024a   Const  Varying
 
     **-- Local variables:
     D CpOptCtlBlk     Ds
     D  CpTypPrc                     10i 0 Inz( 2 )
     D  CpDBCS                        1a   Inz( '0' )
     D  CpPmtAct                      1a   Inz( '2' )
     D  CpCmdStx                      1a   Inz( '0' )
     D  CpMsgRtvKey                   4a   Inz( *Allx'00' )
     D  CpRsv                         9a   Inz( *Allx'00' )
     **
     D CpChgCmd        s          32767a
     D CpChgCmdAvl     s             10i 0
 
      /Free
 
        PrcCmds( PxCmdStr
               : %Len( PxCmdStr )
               : CpOptCtlBlk
               : %Size( CpOptCtlBlk )
               : 'CPOP0100'
               : CpChgCmd
               : %Size( CpChgCmd )
               : CpChgCmdAvl
               : ERRC0100
               );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  ERRC0100.MsgId;
        Else;
          Return  *Blanks;
        EndIf;
 
      /End-Free
 
     P PrcCmd          E
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
 
     **
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
