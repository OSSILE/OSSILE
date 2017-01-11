     **
     **  Program . . : CBX990O
     **  Description : Update User Auditing - POP
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **  Program description:
     **    Prompt override program for the Update User Auditing (UPDUSRAUD)
     **    command.
     **
     **
     **  Program summary
     **  ---------------
     **
     **  Parameters:
     **    PxCmdNam_q  INPUT      Qualified command name
     **
     **    PxKeyPrm1   INPUT      Key parameter indentifying the user profile
     **                           to retrieve user auditing information about.
     **
     **    PxCmdStr    OUTPUT     The formatted command prompt string
     **                           returning the current auditing values
     **                           for the specified user profile.
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod Module( CBX990O )
     **              DbgView( *LIST )
     **
     **    CrtPgm    Pgm( CBX990O )
     **              Module( CBX990O )
     **              ActGrp( *NEW )
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
     **-- API error information:
     D ERRC0100        Ds                  Qualified
     D  BytPro                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      512a
 
     **-- User information:
     D USRI0300        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  UsrPrf                       10a
     D  ObjAudVal                    10a   Overlay( USRI0300: 501 )
     D  UsrAudVal                          Overlay( USRI0300: 511 )
     D                                     LikeDs( AudLvl )
     **
     D AudLvl          Ds                  Qualified
     D  Cmd                           1a
     D  Create                        1a
     D  Delete                        1a
     D  JobDta                        1a
     D  ObjMgt                        1a
     D  OfcSrv                        1a
     D  PgmAdp                        1a
     D  SavRst                        1a
     D  Security                      1a
     D  Service                       1a
     D  SplfDta                       1a
     D  SysMgt                        1a
     D  Optical                       1a
     D  AutFail                       1a
     D  JobBas                        1a
     D  JobChgUsr                     1a
     D  NetBas                        1a
     D  NetClu                        1a
     D  NetCmn                        1a
     D  NetFail                       1a
     D  NetSck                        1a
     D  PgmFail                       1a
     D  PrtDta                        1a
     D  SecCfg                        1a
     D  SecDirSrv                     1a
     D  SecIpc                        1a
     D  SecNas                        1a
     D  SecRun                        1a
     D  SecSckD                       1a
     D  SecVfy                        1a
     D  SecVldL                       1a
 
     **-- Global constants:
     D ADP_PRV_INVLVL  c                   1
     D NULL            c                   ''
     **-- Global variables:
     D SpcAutLst       s             10a   Dim( 8 )
     D AutFlg          s              1a
 
     **-- Retrieve user information:
     D RtvUsrInf       Pr                  ExtPgm( 'QSYRUSRI' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                       10a   Const
     D  UsrPrf                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Check special authority
     D ChkSpcAut       Pr                  ExtPgm( 'QSYCUSRS' )
     D  AutInf                        1a
     D  UsrPrf                       10a   Const
     D  SpcAut                       10a   Const  Dim( 8 )  Options( *VarSize )
     D  NbrAut                       10i 0 Const
     D  CalLvl                       10i 0 Const
     D  Error                     32767a          Options( *VarSize )
 
     **-- Retrieve user audit:
     D RtvUsrAud       Pr             1a
     D  PxUsrPrf                     10a   Value
     D  PxAudVal                     10a   Value
     **-- Format user audit level values:
     D FmtAudLvl       Pr           300a   Varying
     D  PxAudLvl                           LikeDs( AudLvl )
 
     **-- Entry parameters:
     D CBX990O         Pr
     D  PxCmdNam_q                   20a
     D  PxKeyPrm1                    10a   Varying
     D  PxCmdStr                  32674a   Varying
     **
     D CBX990O         Pi
     D  PxCmdNam_q                   20a
     D  PxKeyPrm1                    10a   Varying
     D  PxCmdStr                  32674a   Varying
 
      /Free
 
        PxCmdStr = NULL;
 
        SpcAutLst( 1 ) = '*AUDIT';
 
        ChkSpcAut( AutFlg
                 : PgmSts.UsrPrf
                 : SpcAutLst
                 : 1
                 : ADP_PRV_INVLVL
                 : ERRC0100
                 );
 
        If  ERRC0100.BytAvl = *Zero  And  AutFlg = 'Y';
 
          RtvUsrInf( USRI0300
                   : %Size( USRI0300 )
                   : 'USRI0300'
                   : PxKeyPrm1
                   : ERRC0100
                   );
 
          ExSr  BldPmtStr;
        EndIf;
 
        *InLr = *On;
        Return;
 
 
        BegSr  BldPmtStr;
 
          PxCmdStr = '?<OBJAUD(' + %TrimR( USRI0300.ObjAudVal ) +
                               ') '  +
                     '?<AUDLVL(' + FmtAudLvl( USRI0300.UsrAudVal ) +
                               ')';
 
        EndSr;
 
      /End-Free
 
     **-- Format user audit level values:
     P FmtAudLvl       B
     D                 Pi           300a   Varying
     D  PxAudLvl                           LikeDs( AudLvl )
 
     **-- Local variables
     D RtnAudVal       s            300a   Varying
 
      /Free
 
        If  %Scan( 'Y': PxAudLvl ) = *Zero;
          RtnAudVal = '*NONE';
 
        Else;
          If  PxAudLvl.Cmd    = 'Y';
            RtnAudVal += '*CMD' + ' ';
          EndIf;
 
          If  PxAudLvl.Create = 'Y';
            RtnAudVal += '*CREATE' + ' ';
          EndIf;
 
          If  PxAudLvl.Delete   = 'Y';
            RtnAudVal += '*DELETE' + ' ';
          EndIf;
 
          If  PxAudLvl.JobDta   = 'Y';
            RtnAudVal += '*JOBDTA' + ' ';
          EndIf;
 
          If  PxAudLvl.ObjMgt   = 'Y';
            RtnAudVal += '*OBJMGT' + ' ';
          EndIf;
 
          If  PxAudLvl.OfcSrv   = 'Y';
            RtnAudVal += '*OFCSRV' + ' ';
          EndIf;
 
          If  PxAudLvl.Optical  = 'Y';
            RtnAudVal += '*OPTICAL' + ' ';
          EndIf;
 
          If  PxAudLvl.PgmAdp   = 'Y';
            RtnAudVal += '*PGMADP' + ' ';
          EndIf;
 
          If  PxAudLvl.SavRst   = 'Y';
            RtnAudVal += '*SAVRST' + ' ';
          EndIf;
 
          If  PxAudLvl.Security = 'Y';
            RtnAudVal += '*SECURITY' + ' ';
          EndIf;
 
          If  PxAudLvl.Service  = 'Y';
            RtnAudVal += '*SERVICE' + ' ';
          EndIf;
 
          If  PxAudLvl.SplfDta  = 'Y';
            RtnAudVal += '*SPLFDTA' + ' ';
          EndIf;
 
          If  PxAudLvl.SysMgt   = 'Y';
            RtnAudVal += '*SYSMGT' + ' ';
          EndIf;
        EndIf;
 
        Return  %TrimR( RtnAudVal );
 
      /End-Free
 
     P FmtAudLvl       E
