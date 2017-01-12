     **
     **  Program . . : CBX972E
     **  Description : Work with Profile Security Attributes - UIM Exit Program
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod  Module( CBX972E )
     **               DbgView( *LIST )
     **
     **    CrtPgm     Pgm( CBX972E )
     **               Module( CBX972E )
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
 
     **-- Special authorities:
     D SpcAut          Ds            15    Qualified  Based( p_T )
     D  AllObj                        1a   Overlay( SpcAut: 1 )
     D  SecAdm                        1a   Overlay( SpcAut: *Next )
     D  JobCtl                        1a   Overlay( SpcAut: *Next )
     D  SplCtl                        1a   Overlay( SpcAut: *Next )
     D  SavSys                        1a   Overlay( SpcAut: *Next )
     D  Service                       1a   Overlay( SpcAut: *Next )
     D  Audit                         1a   Overlay( SpcAut: *Next )
     D  IoSysCfg                      1a   Overlay( SpcAut: *Next )
     **-- User audit values:
     D UsrAudVal       Ds            25    Qualified  Based( p_T )
     D  Cmd                           1a   Overlay( UsrAudVal: 1 )
     D  Create                        1a   Overlay( UsrAudVal: *Next )
     D  Delete                        1a   Overlay( UsrAudVal: *Next )
     D  JobDta                        1a   Overlay( UsrAudVal: *Next )
     D  ObjMgt                        1a   Overlay( UsrAudVal: *Next )
     D  OfcSrv                        1a   Overlay( UsrAudVal: *Next )
     D  PgmAdp                        1a   Overlay( UsrAudVal: *Next )
     D  SavRst                        1a   Overlay( UsrAudVal: *Next )
     D  Security                      1a   Overlay( UsrAudVal: *Next )
     D  Service                       1a   Overlay( UsrAudVal: *Next )
     D  SplfDta                       1a   Overlay( UsrAudVal: *Next )
     D  SysMgt                        1a   Overlay( UsrAudVal: *Next )
     D  Optical                       1a   Overlay( UsrAudVal: *Next )
     **-- Supplemental groups:
     D SupGrpPrf       Ds                  Qualified
     D  SupGrpLst                    11a   Dim( 15 )
 
     **-- UIM constants:
     D NULL            c                   ''
     D NO_ENT          c                   x'00000000'
     D RES_OK          c                   0
     D RES_ERR         c                   1
     **-- UIM variables:
     D UIM             Ds                  Qualified
     D  EntHdl                        4a
 
     **-- UIM API return structures:
     **-- Cursor record:
     D CsrRcd          Ds                  Qualified
     D  CsrEid                        4a
     D  CsrVar                       10a
     **-- UIM List entry:
     D LstEnt          Ds                  Qualified
     D  Option                        5i 0
     D  UsrPrf                       10a
     D  PrfSts                       10a
     D  UsrCls                       10a
     D  InvSgo                        7s 0
     D  PrvSgoDat                     7a
     D  PrvSgoTim                     6a
     D  PwdTyp                        1a
     D  PwdExpI                       1a
     D  PwdExpItv                     5i 0
     D  PwdChgDat                     7a
     D  LmtCap                       10a
     D  NbrSpcAut                     5i 0
     D  SpcAut                       15a
     D  GrpPrf                       10a
     D  SupGrp                             LikeDs( SupGrp_t )
     D  ObjAudVal                    10a
     D  NbrUsrAud                     5i 0
     D  UsrAudVal                    25a
     D  DigCerI                       1a
     D  LocPwdMgt                     1a
     D  TxtDsc                       50a
     D  PubAut                       10a
     D  CrtUsr                       10a
     D  ObjOwn                       10a
     D  SignOn                        1a
     D  LstUsdDat                     7a
     D  JrnDat                        8a
     D  JrnTim                        8a
     **
     D SupGrp_t        Ds                  Qualified
     D  NbrVal                        5i 0
     D  SupGrp                       10a   Dim( 15 )
 
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
 
     **-- Format special authority:
     D FmtSpcAut       Pr            80a   Varying
     D  PxSpcAut                           LikeDs( SpcAut )
     **-- Format user audit values:
     D FmtUsrAud       Pr           250a   Varying
     D  PxUsrAud                           LikeDs( UsrAudVal )
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying
 
     **-- Entry parameters:
     D CBX972E         Pr
     D  PxUimExit                          LikeDs( UimExit )
     **
     D CBX972E         Pi
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
 
            If  CsrRcd.CsrEid = NO_ENT  Or
              ( CsrRcd.CsrVar <> 'NBRSUP'  And
                CsrRcd.CsrVar <> 'NBRAUT'  And
                CsrRcd.CsrVar <> 'NBRAUD' );
 
              SndEscMsg( 'CPD9820': 'QCPFMSG': NULL );
 
            Else;
              ExSr  RunCsrAct;
            EndIf;
          EndIf;
 
        When  PxUimExit.TypCall = 5;
          Type5 = PxUimExit;
 
          If  Type5.ActRes = RES_OK;
 
            If  Type5.OptNbr = 2;
              ExSr  ChgLstEnt;
            EndIf;
          EndIf;
        EndSl;
 
        Return;
 
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
 
           Select;
           When  CsrRcd.CsrVar = 'NBRSUP';
 
             SupGrpPrf.SupGrpLst = LstEnt.SupGrp.SupGrp;
 
             DspLngTxt( %TrimR( SupGrpPrf )
                      : %Len( %TrimR( SupGrpPrf ))
                      : 'CBX0001'
                      : 'CBX972M   *LIBL'
                      : ERRC0100
                      );
 
           When  CsrRcd.CsrVar = 'NBRAUT';
 
             DspLngTxt( FmtSpcAut( LstEnt.SpcAut )
                      : %Len( FmtSpcAut( LstEnt.SpcAut ))
                      : 'CBX0002'
                      : 'CBX972M   *LIBL'
                      : ERRC0100
                      );
 
           When  CsrRcd.CsrVar = 'NBRAUD';
 
             DspLngTxt( FmtUsrAud( LstEnt.UsrAudVal )
                      : %Len( FmtUsrAud( LstEnt.UsrAudVal ))
                      : 'CBX0003'
                      : 'CBX972M   *LIBL'
                      : ERRC0100
                      );
         EndSl;
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
 
          LstEnt.PrfSts = '*CHANGED';
 
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
 
      /End-Free
 
     **-- Format special authority:
     P FmtSpcAut       B
     D                 Pi            80a   Varying
     D  PxSpcAut                           LikeDs( SpcAut )
 
     **-- Local variables
     D RtnAut          Ds                  Qualified
     D  AutVal                       10a   Dim( 8 )
     **
     D Idx             s              5i 0 Inz( 0 )
 
      /Free
 
        If  %Scan( 'Y': PxSpcAut ) = *Zero;
          RtnAut.AutVal(1) = '*NONE';
 
        Else;
          If  PxSpcAut.AllObj   = 'Y';
            Idx += 1;
            RtnAut.AutVal(Idx)  = '*ALLOBJ';
          EndIf;
 
          If  PxSpcAut.SecAdm   = 'Y';
            Idx += 1;
            RtnAut.AutVal(Idx)  = '*SECADM';
          EndIf;
 
          If  PxSpcAut.JobCtl   = 'Y';
            Idx += 1;
            RtnAut.AutVal(Idx)  = '*JOBCTL';
          EndIf;
 
          If  PxSpcAut.SplCtl   = 'Y';
            Idx += 1;
            RtnAut.AutVal(Idx)  = '*SPLCTL';
          EndIf;
 
          If  PxSpcAut.SavSys   = 'Y';
            Idx += 1;
            RtnAut.AutVal(Idx)  = '*SAVSYS';
          EndIf;
 
          If  PxSpcAut.Service  = 'Y';
            Idx += 1;
            RtnAut.AutVal(Idx)  = '*SERVICE';
          EndIf;
 
          If  PxSpcAut.Audit    = 'Y';
            Idx += 1;
            RtnAut.AutVal(Idx)  = '*AUDIT';
          EndIf;
 
          If  PxSpcAut.IoSysCfg = 'Y';
            Idx += 1;
            RtnAut.AutVal(Idx)  = '*IOSYSCFG';
          EndIf;
        EndIf;
 
        Return  %TrimR( RtnAut );
 
      /End-Free
 
     P FmtSpcAut       E
     **-- Format user audit values:
     P FmtUsrAud       B
     D                 Pi           250a   Varying
     D  PxUsrAud                           LikeDs( UsrAudVal )
 
     **-- Local variables
     D RtnAud          Ds                  Qualified
     D  AudVal                       10a   Dim( 25 )
     **
     D Idx             s              5i 0 Inz( 0 )
 
      /Free
 
        If  %Scan( 'Y': PxUsrAud ) = *Zero;
          RtnAud.AudVal(1) = '*NONE';
 
        Else;
          If  PxUsrAud.Cmd      = 'Y';
            Idx += 1;
            RtnAud.AudVal(Idx)  = '*CMD';
          EndIf;
 
          If  PxUsrAud.Create   = 'Y';
            Idx += 1;
            RtnAud.AudVal(Idx)  = '*CREATE';
          EndIf;
 
          If  PxUsrAud.Delete   = 'Y';
            Idx += 1;
            RtnAud.AudVal(Idx)  = '*DELETE';
          EndIf;
 
          If  PxUsrAud.JobDta   = 'Y';
            Idx += 1;
            RtnAud.AudVal(Idx)  = '*JOBDTA';
          EndIf;
 
          If  PxUsrAud.ObjMgt   = 'Y';
            Idx += 1;
            RtnAud.AudVal(Idx)  = '*OBJMGT';
          EndIf;
 
          If  PxUsrAud.OfcSrv   = 'Y';
            Idx += 1;
            RtnAud.AudVal(Idx)  = '*OFCSRV';
          EndIf;
 
          If  PxUsrAud.Optical  = 'Y';
            Idx += 1;
            RtnAud.AudVal(Idx)  = '*OPTICAL';
          EndIf;
 
          If  PxUsrAud.PgmAdp   = 'Y';
            Idx += 1;
            RtnAud.AudVal(Idx)  = '*PGMADP';
          EndIf;
 
          If  PxUsrAud.SavRst   = 'Y';
            Idx += 1;
            RtnAud.AudVal(Idx)  = '*SAVRST';
          EndIf;
 
          If  PxUsrAud.Security = 'Y';
            Idx += 1;
            RtnAud.AudVal(Idx)  = '*SECURITY';
          EndIf;
 
          If  PxUsrAud.Service  = 'Y';
            Idx += 1;
            RtnAud.AudVal(Idx)  = '*SERVICE';
          EndIf;
 
          If  PxUsrAud.SplfDta  = 'Y';
            Idx += 1;
            RtnAud.AudVal(Idx)  = '*SPLFDTA';
          EndIf;
 
          If  PxUsrAud.SysMgt   = 'Y';
            Idx += 1;
            RtnAud.AudVal(Idx)  = '*SYSMGT';
          EndIf;
        EndIf;
 
        Return  %TrimR( RtnAud );
 
      /End-Free
 
     P FmtUsrAud       E
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
