     **
     **  Program . . : CBX9812O
     **  Description : Change User Query Attributes - POP
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **  Program description:
     **    Prompt override program for the Change User Query Attributes
     **    (CHGUSRQRYA) command.
     **
     **
     **  Program summary
     **  ---------------
     **
     **  Parameters:
     **    PxCmdNam_q  INPUT      Qualified command name
     **
     **    PxKeyPrm1   INPUT      Key parameter indentifying the user profile
     **                           to retrieve time zone information about.
     **
     **    PxCmdStr    OUTPUT     The formatted command prompt string
     **                           returning the current attribute setting
     **                           of the registered function.
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod Module( CBX9812O )
     **              DbgView( *LIST )
     **
     **    CrtPgm    Pgm( CBX9812O )
     **              Module( CBX9812O )
     **              BndSrvPgm( CBX980 )
     **              ActGrp( *CALLER )
     **
     **
     **-- Control specification:  --------------------------------------------**
     H Option( *SrcStmt )
 
     **-- System information:
     D PgmSts         SDs                  Qualified
     D  PgmNam           *Proc
     **-- API error information:
     D ERRC0100        Ds                  Qualified
     D  BytPro                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      512a
 
     **-- User query attributes application information:
     D UsrQryAtr       Ds                  Qualified
     D  FmtLen                       10i 0
     D  FmtNam                        8a
     D  Resv1                         4a
     D  QryIntLmt                    10i 0
     D  QryIntAlw                    10a
     D  QryOptLib                    10a
     D  Resv2                       216a   Inz
 
     **-- Global constants:
     D NULL            c                   ''
 
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
 
     **-- Get user query attributes:
     D GetUsrQryA      Pr           256a
     D  PxUsrPrf                     10a   Const
 
     **-- Get query interactive time limit:
     D GetQryIntLmt    Pr            10a   Varying
     D  PxParmVal                    10i 0 Const
     **-- Send diagnostic message:
     D SndDiagMsg      Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
 
     D CBX9812O        Pr
     D  PxCmdNam_q                   20a
     D  PxKeyPrm1                    10a
     D  PxCmdStr                  32674a   Varying
     **
     D CBX9812O        Pi
     D  PxCmdNam_q                   20a
     D  PxKeyPrm1                    10a
     D  PxCmdStr                  32674a   Varying
 
      /Free
 
        UsrQryAtr = GetUsrQryA( PxKeyPrm1 );
 
        ExSr  BldPmtStr;
 
        *InLr = *On;
        Return;
 
 
        BegSr  BldPmtStr;
 
          Select;
          When  UsrQryAtr = *Blanks;
            PxCmdStr = NULL;
 
          When  UsrQryAtr.FmtLen < %Size( UsrQryAtr );
            PxCmdStr = NULL;
 
          When  UsrQryAtr.FmtNam <> 'QRYA0100';
            PxCmdStr = NULL;
 
          Other;
            PxCmdStr = '??QRYINTTIML(' + GetQryIntLmt( UsrQryAtr.QryIntLmt ) +
                                 ') '  +
                       '??QRYINTALW('  + %Trim( UsrQryAtr.QryIntAlw )        +
                                 ') '  +
                       '??QRYOPTLIB('  + %Trim( UsrQryAtr.QryOptLib )        +
                                 ') ';
          EndSl;
 
        EndSr;
 
      /End-Free
 
     **-- Get query interactive time limit:
     P GetQryIntLmt    B
     D                 Pi            10a   Varying
     D  PxParmVal                    10i 0 Const
 
      /Free
 
        Select;
        When  PxParmVal = -1;
          Return  '*NOMAX';
 
        When  PxParmVal = -2;
          Return  '*SAME';
 
        When  PxParmVal = -3;
          Return  '*QRYTIMLMT';
 
        Other;
          Return  %Char( PxParmVal );
        EndSl;
 
      /End-Free
 
     P GetQryIntLmt    E
     **-- Send diagnostic message:
     P SndDiagMsg      B
     D                 Pi            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
     **
     D MsgKey          s              4a
 
      /Free
 
        SndPgmMsg( PxMsgId
                 : 'QCPFMSG   *LIBL'
                 : PxMsgDta
                 : %Len( PxMsgDta )
                 : '*DIAG'
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
 
     P SndDiagMsg      E
     **-- Send escape message:
     P SndEscMsg       B
     D                 Pi            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
     **
     D MsgKey          s              4a
 
      /Free
 
        SndPgmMsg( PxMsgId
                 : 'QCPFMSG   *LIBL'
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
