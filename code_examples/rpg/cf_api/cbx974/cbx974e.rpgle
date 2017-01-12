     **
     **  Program . . : CBX974E
     **  Description : Work with Default Journal - UIM Exit Program
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod  Module( CBX974E CBX974 )
     **               DbgView( *LIST )
     **
     **    CrtPgm     Pgm( CBX974E )
     **               Module( CBX974E )
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
 
     **-- UIM constants:
     D NULL            c                   ''
     D NO_ENT          c                   x'00000000'
     D RES_OK          c                   0
     D RES_ERR         c                   1
 
     **-- UIM variables:
     D UIM             Ds                  Qualified
     D  EntHdl                        4a
     **-- Cursor record:
     D CsrRcd          Ds                  Qualified
     D  CsrEid                        4a
     D  CsrVar                       10a
     **-- UIM List entry:
     D LstEnt          Ds                  Qualified
     D  Option                        5i 0
     D  DtaLib                       10a
     D  DtaAra                       10a
     D  JrnInf
     D   JrnLib                      10a   Overlay( JrnInf:  1 )
     D   JrnDta                      10a   Overlay( JrnInf: 11 )
     D   JrnOpt                     200a   Overlay( JrnInf: 21 )
     D  DtaOwn                       10a
     D  TxtDsc                       50a
 
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
 
     **-- Display long text:
     D DspLngTxt       Pr                  ExtPgm( 'QUILNGTX' )
     D  LngTxt                    32767a   Const  Options( *VarSize )
     D  LngTxtLen                    10i 0 Const
     D  MsgId                         7a   Const
     D  MsgF                         20a   Const
     D  Error                     32767a   Const  Options( *VarSize )
     **-- Retrieve object description:
     D RtvObjD         Pr                  ExtPgm( 'QUSROBJD' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  ObjNamQ                      20a   Const
     D  ObjTyp                       10a   Const
     D  Error                     32767a          Options( *VarSize )
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
 
     **-- Get dialog variable:
     D GetDlgVar       Pr                  ExtPgm( 'QUIGETV' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a          Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
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
 
     **-- Get data area value:
     D GetDtaVal       Pr          2000a   Varying
     D  PxDtaAra_q                   20a   Const
     **-- Get object description:
     D GetObjDsc       Pr            50a
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying
 
     **-- Entry parameters:
     D CBX974E         Pr
     D  PxUimExit                          LikeDs( UimExit )
     **
     D CBX974E         Pi
     D  PxUimExit                          LikeDs( UimExit )
 
      /Free
 
        Select;
        When  PxUimExit.TypCall = 1;
          Type1 = PxUimExit;
 
          If  Type1.FncKey = 22;
 
            GetDlgVar( Type1.AppHdl
                     : CsrRcd
                     : %Size( CsrRcd )
                     : 'CSRRCD'
                     : ERRC0100
                     );
 
            If  CsrRcd.CsrEid = NO_ENT  Or  CsrRcd.CsrVar <> 'JRNOPT';
              SndEscMsg( 'CPD9820': 'QCPFMSG': NULL );
 
            Else;
              ExSr  RunCsrAct;
            EndIf;
          EndIf;
 
        When  PxUimExit.TypCall = 5;
          Type5 = PxUimExit;
 
          If  Type5.ActRes = RES_OK;
 
            Select;
            When  Type5.OptNbr = 1;
              ExSr  ChgLstEnt1;
 
            When  Type5.OptNbr = 4;
              ExSr  DltLstEnt;
 
            When  Type5.OptNbr = 13;
              ExSr  ChgLstEnt13;
            EndSl;
          EndIf;
        EndSl;
 
        Return;
 
 
        BegSr  ChgLstEnt1;
 
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
 
          LstEnt.JrnInf = GetDtaVal( LstEnt.DtaAra + LstEnt.DtaLib );
 
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
 
        BegSr  ChgLstEnt13;
 
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
 
          LstEnt.TxtDsc = GetObjDsc( LstEnt.DtaAra + LstEnt.DtaLib: '*DTAARA' );
 
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
 
        BegSr  RunCsrAct;
 
          GetLstEnt( Type1.AppHdl
                   : LstEnt
                   : %Size( LstEnt )
                   : 'DTLRCD'
                   : 'DTLLST'
                   : 'HNDL'
                   : 'Y'
                   : *Blanks
                   : CsrRcd.CsrEid
                   : 'N'
                   : UIM.EntHdl
                   : ERRC0100
                   );
 
          DspLngTxt( %TrimR( LstEnt.JrnOpt )
                   : %Len( %TrimR( LstEnt.JrnOpt ))
                   : 'CBX0101'
                   : 'CBX974M   *LIBL'
                   : ERRC0100
                   );
 
        EndSr;
 
      /End-Free
 
     **-- Get object description:
     P GetObjDsc       B
     D                 Pi            50a
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const
     **
     D OBJD0200        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  ObjNam                       10a
     D  ObjLib                       10a
     D  ObjTyp                       10a
     D  ObjDsc                       50a   Overlay( OBJD0200: 101 )
 
      /Free
 
         RtvObjD( OBJD0200
                : %Size( OBJD0200 )
                : 'OBJD0200'
                : PxObjNam_q
                : PxObjTyp
                : ERRC0100
                );
 
         If  ERRC0100.BytAvl > *Zero;
           Return  *Blanks;
 
         Else;
           Return  OBJD0200.ObjDsc;
         EndIf;
 
      /End-Free
 
     P GetObjDsc       E
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
