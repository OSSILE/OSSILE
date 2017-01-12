     **
     **  Program . . : CBX985
     **  Description : Remove Pending Job Log - CPP
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **
     **  Programmer's notes:
     **
     **
     **  Compilation instructions:
     **    CrtRpgMod   Module( CBX985 )
     **                DbgView( *NONE )
     **
     **    CrtPgm      Pgm( CBX985 )
     **                Module( CBX985 )
     **                ActGrp( *NEW )
     **
     **
     **-- Header specifications:  --------------------------------------------**
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
     D  MsgDta                      128a
 
     **-- Global constants:
     D OFS_MSGDTA      c                   16
 
     **-- Job selection information:
     D RJLS0100        Ds                  Qualified
     D  InfLen                       10i 0 Inz( %Size( RJLS0100 ))
     D  RtnDays                      10i 0
     D  JobNam_q                     26a
     D   JobNam                      10a   Overlay( JobNam_q:  1 )
     D   UsrPrf                      10a   Overlay( JobNam_q: 11 )
     D   JobNbr                       6a   Overlay( JobNam_q: 21 )
     D  LogOutPut                    10a
 
     **-- Remove pending job log:
     D RmvPndLog       Pr                  ExtPgm( 'QWTRMVJL' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  FmtNam                        8a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Send program message:
     D SndPgmMsg       Pr                  ExtPgm( 'QMHSNDPM' )
     D  MsgId                         7a   Const
     D  MsgF_q                       20a   Const
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
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgFil                     10a   Const
     D  PxMsgDta                    512a   Const  Varying
 
     **-- Entry parameters:
     D JobNam_q        Ds                  Qualified
     D  JobNam                       10a
     D  UsrPrf                       10a
     D  JobNbr                        6a
     **
     D CBX985          Pr
     D  PxJobNam_q                         LikeDs( JobNam_q )
     D  PxLogOutPut                  10a
     D  PxRtnDays                     5i 0
     **
     D CBX985          Pi
     D  PxJobNam_q                         LikeDs( JobNam_q )
     D  PxLogOutPut                  10a
     D  PxRtnDays                     5i 0
 
      /Free
 
        RJLS0100.RtnDays   = PxRtnDays;
        RJLS0100.LogOutPut = PxLogOutPut;
        RJLS0100.JobNam_q  = PxJobNam_q;
 
        If  RJLS0100.UsrPrf = '*CURRENT';
          RJLS0100.UsrPrf = PgmSts.CurUsr;
        EndIf;
 
        RmvPndLog( RJLS0100
                 : 'RJLS0100'
                 : ERRC0100
                 );
 
        If  ERRC0100.BytAvl > *Zero;
          ExSr  EscApiMsg;
 
        Else;
          SndCmpMsg ( 'Remove pending job log command completed normally.' );
        EndIf;
 
        *InLr = *On;
        Return;
 
 
        BegSr  EscApiMsg;
 
          If  ERRC0100.BytAvl < OFS_MSGDTA;
            ERRC0100.BytAvl = OFS_MSGDTA;
          EndIf;
 
          SndEscMsg( ERRC0100.MsgId
                   : 'QCPFMSG'
                   : %Subst( ERRC0100.MsgDta: 1: ERRC0100.BytAvl - OFS_MSGDTA )
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
     **-- Send escape message:
     P SndEscMsg       B
     D                 Pi            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgFil                     10a   Const
     D  PxMsgDta                    512a   Const  Varying
     **
     D MsgKey          s              4a
 
      /Free
 
        SndPgmMsg( PxMsgId
                 : PxMsgFil + '*LIBL'
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
