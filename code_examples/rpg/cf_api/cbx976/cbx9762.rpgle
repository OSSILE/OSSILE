     **
     **  Program . . : CBX9762
     **  Description : Retrieve Job Interrupt Status - CPP
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod  Module( CBX9762 )
     **               DbgView( *LIST )
     **
     **    CrtPgm     Pgm( CBX9762 )
     **               Module( CBX9762 )
     **               ActGrp( *NEW )
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
     D  MsgDta                      256a
 
     **-- Global constants:
     D OFS_MSGDTA      c                   16
     D NO_CHG          c                   '*'
     D ERR_RTNSTS      c                   '*'
     **-- Global variables:
     D CurItpSts       s              1a
 
     **-- Change job interrupt status:
     D ChgJobItpSts    Pr                  ExtPgm( 'QWCCJITP' )
     D  CurItpSts                     1a
     D  NewItpSts                     1a   Const
     D  Error                     32767a          Options( *NoPass: *VarSize )
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
 
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying
 
     **-- Entry parameters:
     D CBX9762         Pr
     D  PxItpSts                      1a
     **
     D CBX9762         Pi
     D  PxItpSts                      1a
 
      /Free
 
        ChgJobItpSts( CurItpSts: NO_CHG: ERRC0100 );
 
        If  ERRC0100.BytAvl > *Zero;
          ExSr  EscApiErr;
        EndIf;
 
        PxItpSts = CurItpSts;
 
        *InLr = *On;
        Return;
 
 
        BegSr  EscApiErr;
 
          If  ERRC0100.BytAvl < OFS_MSGDTA;
            ERRC0100.BytAvl = OFS_MSGDTA;
          EndIf;
 
          SndEscMsg( ERRC0100.MsgId
                   : 'QCPFMSG'
                   : %Subst( ERRC0100.MsgDta: 1: ERRC0100.BytAvl - OFS_MSGDTA )
                   );
 
        EndSr;
 
        BegSr  *PsSr;
 
          If  *InLr = *On;
            Return;
 
          Else;
            *InLr = *On;
          EndIf;
 
          PxItpSts = ERR_RTNSTS;
 
          Return;
 
        EndSr  '*CANCL';
 
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
