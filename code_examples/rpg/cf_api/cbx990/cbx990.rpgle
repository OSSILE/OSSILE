     **
     **  Program . . :  CBX990
     **  Description :  Update User Auditing - CPP
     **  Author  . . :  Carsten Flensburg
     **  Published . :  System iNetwork Systems Management Tips Newsletter
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod Module( CBX990 )
     **              DbgView( *LIST )
     **
     **    CrtPgm    Pgm( CBX990 )
     **              Module( CBX990 )
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
     **-- Global variables:
     D Idx             s             10i 0
     D CmdStr          s          32674a   Varying
     **-- Global constants:
     D NULL            c                   ''
     D OFS_MSGDTA      c                   16
 
     **-- Process commands:
     D PrcCmds         Pr                  ExtPgm( 'QCAPCMD' )
     D  SrcCmd                    32702a   Const  Options( *VarSize )
     D  SrcCmdLen                    10i 0 Const
     D  OptCtlBlk                    20a   Const
     D  OptCtlBlkLen                 10i 0 Const
     D  OptCtlBlkFmt                  8a   Const
     D  ChgCmd                    32767a          Options( *VarSize )
     D  ChgCmdLen                    10i 0 Const
     D  ChgCmdLenAvl                 10i 0
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
     D  Error                      1024a          Options( *VarSize )
     **-- Move program messages:
     D MovPgmMsg       Pr                  ExtPgm( 'QMHMOVPM' )
     D  MsgKey                        4a   Const
     D  MsgTyps                      10a   Const  Options( *VarSize )  Dim( 4 )
     D  NbrMsgTyps                   10i 0 Const
     D  ToCalStkE                  4102a   Const  Options( *VarSize )
     D  ToCalStkCnt                  10i 0 Const
     D  Error                     32767a          Options( *VarSize )
     D  ToCalStkLen                  10i 0 Const  Options( *NoPass )
     D  ToCalStkEq                   20a   Const  Options( *NoPass )
     D  ToCalStkEdt                  10a   Const  Options( *NoPass )
     D  FrCalStkEad                    *   Const  Options( *NoPass )
     D  FrCalStkCnt                  10i 0 Const  Options( *NoPass )
 
     **-- Process command:
     D PrcCmd          Pr            10i 0
     D  PxCmdStr                   4096a   Const  Varying
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
 
     **-- Entry parameters:
     D AudLvl          Ds                  Qualified
     D  NbrVal                        5i 0
     D  AudVal                       10a   Varying  Dim( 13 )
     **
     D CBX990          Pr
     D  PxUsrPrf                     10a   Varying
     D  PxObjAud                     10a   Varying
     D  PxAudLvl                           LikeDs( AudLvl )
     **
     D CBX990          Pi
     D  PxUsrPrf                     10a   Varying
     D  PxObjAud                     10a   Varying
     D  PxAudLvl                           LikeDs( AudLvl )
 
      /Free
 
        If  PxObjAud <> '*SAME'  Or  PxAudLvl.AudVal(1) <> '*SAME';
 
          CmdStr  = 'CHGUSRAUD USRPRF(' + PxUsrPrf + ') '    +
                              'OBJAUD(' + PxObjAud + ') ';
 
          CmdStr += 'AUDLVL(';
 
          For  Idx = 1  To  PxAudLvl.NbrVal;
            CmdStr += PxAudLvl.AudVal(Idx) + ' ';
          EndFor;
 
          CmdStr = %TrimR( CmdStr) + ')';
 
          PrcCmd( CmdStr );
        EndIf;
 
        *InLr = *On;
        Return;
 
      /End-Free
 
     **-- Process command:
     P PrcCmd          B                   Export
     D                 Pi            10i 0
     D  PxCmdStr                   4096a   Const  Varying
 
     **-- Option control block:
     D CPOP0100        Ds                  Qualified
     D  TypPrc                       10i 0 Inz( 2 )
     D  DBCS                          1a   Inz( '0' )
     D  PmtAct                        1a   Inz( '2' )
     D  CmdStx                        1a   Inz( '0' )
     D  MsgRtvKey                     4a   Inz( *Allx'00' )
     D  Rsv                           9a   Inz( *Allx'00' )
     **
     D ChgCmd          s          32767a
     D ChgCmdAvl       s             10i 0
     **-- API error data structure:
     D ERRC0100_I      Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
 
      /Free
 
        PrcCmds( PxCmdStr
               : %Len( PxCmdStr )
               : CPOP0100
               : %Size( CPOP0100 )
               : 'CPOP0100'
               : ChgCmd
               : %Size( ChgCmd )
               : ChgCmdAvl
               : ERRC0100
               );
 
        If  ERRC0100.BytAvl > *Zero;
          MovPgmMsg( *Blanks
                   : '*DIAG'
                   : 1
                   : '*PGMBDY'
                   : 1
                   : ERRC0100_I
                   );
 
          If  ERRC0100.BytAvl < OFS_MSGDTA;
            ERRC0100.BytAvl = OFS_MSGDTA;
          EndIf;
 
          SndEscMsg( ERRC0100.MsgId
                   : %Subst( ERRC0100.MsgDta: 1: ERRC0100.BytAvl - OFS_MSGDTA )
                   );
 
          Return  -1;
 
        Else;
          MovPgmMsg( *Blanks
                   : '*COMP'
                   : 1
                   : '*PGMBDY'
                   : 1
                   : ERRC0100
                   );
 
          Return  *Zero;
        EndIf;
 
      /End-Free
 
     P PrcCmd          E
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
