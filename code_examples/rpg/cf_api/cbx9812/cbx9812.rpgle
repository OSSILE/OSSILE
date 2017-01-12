     **
     **  Program . . : CBX9812
     **  Description : Change User Query Attributes - CPP
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **  Program description:
     **    Command processing program for the Change User Query Attributes
     **    (CHGUSRQRYA) command.
     **
     **
     **  Compile options:
     **    CrtRpgMod Module( CBX9812
     **              DbgView( *LIST )
     **
     **    CrtPgm    Pgm( CBX9812 )
     **              Module( CBX9812 )
     **              BndSrvPgm( CBX980 )
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
     **-- API error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      512a
 
     **-- User query attributes application information:
     D UsrQryAtr       Ds                  Qualified
     D  FmtLen                       10i 0 Inz( %Size( UsrQryAtr ))
     D  FmtNam                        8a   Inz( 'QRYA0100' )
     D  Resv1                         4a
     D  QryIntLmt                    10i 0
     D  QryIntAlw                    10a
     D  QryOptLib                    10a
     D  Resv2                       216a   Inz
 
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
     D  Error                      1024a          Options( *VarSize )
 
     **-- Set user query attributes:
     D SetUsrQryA      Pr            10i 0
     D  PxUsrPrf                     10a   Const
     D  PxUsrQryA                   256a   Const
 
     **-- Send completion message:
     D SndCmpMsg       Pr            10i 0
     D  PxMsgDta                    512a   Const  Varying
 
     **-- Entry parameters:
     D CBX9812         Pr
     D  PxUsrPrf                     10a
     D  PxQryIntLmt                  10i 0
     D  PxQryIntAlw                  10a
     D  PxQryOptLib                  10a
     **
     D CBX9812         Pi
     D  PxUsrPrf                     10a
     D  PxQryIntLmt                  10i 0
     D  PxQryIntAlw                  10a
     D  PxQryOptLib                  10a
 
      /Free
 
        UsrQryAtr.QryIntLmt = PxQryIntLmt;
        UsrQryAtr.QryIntAlw = PxQryIntAlw;
        UsrQryAtr.QryOptLib = PxQryOptLib;
 
        SetUsrQryA( PxUsrPrf: UsrQryAtr );
 
        SndCmpMsg ( 'User query attributes changed for user '  +
                     %Trim( PxUsrPrf )                         +
                    '.'
                  );
 
        *InLr = *On;
        Return;
 
 
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
