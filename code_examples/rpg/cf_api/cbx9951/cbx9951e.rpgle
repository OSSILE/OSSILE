     **
     **  Program . . : CBX9951E
     **  Description : Work with Routing Entries - UIM Exit Program
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod  Module( CBX9951E )
     **               DbgView( *LIST )
     **
     **    CrtPgm     Pgm( CBX9951E )
     **               Module( CBX9951E )
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
     D SPLF_NAM        c                   'PSBSRTGE'
     D SPLF_USRDTA     c                   'WRKRTGE'
     D EJECT_NO        c                   'N'
     D CLO_NRM         c                   'M'
     D RES_OK          c                   0
     D RES_ERR         c                   1
 
     **-- UIM API return structures:
     **-- UIM List entry:
     D LstEnt          Ds                  Qualified
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
     D  CmpPos                        2s 0
     D  CmpVal                       25a
     D  ThrRscAffGrp                  8a
     D  ThrRscAffLvl                  8a
     D  RscAffGrp                     5a
 
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
 
     **-- Remove list entry:
     D RmvLstEnt       Pr                  ExtPgm( 'QUIRMVLE' )
     D  AppHdl                        8a   Const
     D  LstNam                       10a   Const
     D  ExtOpt                        1a   Const
     D  LstEntHdl                     4a
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
 
     **-- Send completion message:
     D SndCmpMsg       Pr            10i 0
     D  PxMsgDta                    512a   Const  Varying
 
     **-- Entry parameters:
     D CBX9951E        Pr
     D  PxUimExit                          LikeDs( UimExit )
     **
     D CBX9951E        Pi
     D  PxUimExit                          LikeDs( UimExit )
 
      /Free
 
          Select;
          When  PxUimExit.TypCall = 1;
            Type1 = PxUimExit;
 
            If  Type1.FncKey = 21;
              ExSr  PrtJobPnl;
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
 
        BegSr  DltLstEnt;
 
          RmvLstEnt( Type5.AppHdl
                   : 'DTLLST'
                   : 'Y'
                   : Type5.LstEntHdl
                   : ERRC0100
                   );
 
        EndSr;
 
      /End-Free
 
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
