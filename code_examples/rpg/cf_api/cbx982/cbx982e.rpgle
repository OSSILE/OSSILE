     **
     **  Program . . : CBX982E
     **  Description : Work with User Query Attributes - UIM Exit Program
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod  Module( CBX982E )
     **               DbgView( *LIST )
     **
     **    CrtPgm     Pgm( CBX982E )
     **               Module( CBX982E )
     **               BndSrvPgm( CBX980 )
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
     D RES_OK          c                   0
     D RES_ERR         c                   1
     **-- UIM variables:
     D UIM             Ds                  Qualified
     D  EntHdl                        4a
 
     **-- User query attributes application information:
     D UsrQryAtr       Ds                  Qualified
     D  FmtLen                       10i 0 Inz( %Size( UsrQryAtr ))
     D  FmtNam                        8a   Inz( 'QRYA0100' )
     D  Resv1                         4a
     D  QryIntLmt                    10i 0
     D  QryIntAlw                    10a
     D  QryOptLib                    10a
     D  Resv2                       216a   Inz
 
     **-- UIM API return structures:
     **-- UIM List entry:
     D LstEnt          Ds                  Qualified
     D  Option                        5i 0
     D  QryUsr                       10a
     D  IntLmt                       10i 0
     D  IntAlw                       10a
     D  OptLib                       10a
 
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
     **-- Display long text:
     D DspLngTxt       Pr                  ExtPgm( 'QUILNGTX' )
     D  LngTxt                    32767a   Const  Options( *VarSize )
     D  LngTxtLen                    10i 0 Const
     D  MsgId                         7a   Const
     D  MsgF                         20a   Const
     D  Error                     32767a   Const  Options( *VarSize )
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
 
     **-- Get user query attributes information:
     D GetUsrQryA      Pr           256a
     D  PxUsrPrf                     10a   Const
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying
 
     **-- Entry parameters:
     D CBX982E         Pr
     D  PxUimExit                          LikeDs( UimExit )
     **
     D CBX982E         Pi
     D  PxUimExit                          LikeDs( UimExit )
 
      /Free
 
          If  PxUimExit.TypCall = 5;
            Type5 = PxUimExit;
 
            If  Type5.ActRes = RES_OK;
 
              Select;
              When  Type5.OptNbr = 2;
                ExSr  ChgLstEnt;
 
              When  Type5.OptNbr = 4;
                ExSr  DltLstEnt;
              EndSl;
            EndIf;
          EndIf;
 
        Return;
 
 
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
 
          UsrQryAtr = GetUsrQryA( LstEnt.QryUsr );
 
          LstEnt.IntLmt = UsrQryAtr.QryIntLmt;
          LstEnt.IntAlw = UsrQryAtr.QryIntAlw;
          LstEnt.OptlIb = UsrQryAtr.QryOptLib;
 
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
