     **
     **  Program . . : CBX993V
     **  Description : Set Query Profile Options - VCP
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **  Program description:
     **    This program checks the existence of the specified objects.
     **
     **
     **  Compile options:
     **    CrtRpgMod Module( CBX993V )
     **              DbgView( *LIST )
     **
     **    CrtPgm    Pgm( CBX993V )
     **              Module( CBX993V )
     **              ActGrp( *NEW )
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
     D  MsgId                       512a
     **-- Global constants:
     D NULL            c                   ''
     **-- Global variables:
     D PrfOpts         s             10a   Inz( 'QQUPRFOPTS' )
 
     **-- Retrieve object description:
     D RtvObjD         Pr                  ExtPgm( 'QUSROBJD' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  ObjNamQ                      20a   Const
     D  ObjTyp                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Retrieve message description:
     D RtvMsgD         Pr                  ExtPgm( 'QMHRTVM' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                       10a   Const
     D  MsgId                         7a   Const
     D  MsgFq                        20a   Const
     D  MsgDta                      512a   Const  Options( *VarSize )
     D  MsgDtaLen                    10i 0 Const
     D  RplSubVal                    10a   Const
     D  RtnFmtChr                    10a   Const
     D  Error                     32767a          Options( *VarSize )
     D  RtvOpt                       10a   Const  Options( *NoPass )
     D  CvtCcsId                     10i 0 Const  Options( *NoPass )
     D  DtaCcsId                     10i 0 Const  Options( *NoPass )
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
 
     **-- Check object existence:
     D ChkObj          Pr              n
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const
     **-- Retrieve message:
     D RtvMsg          Pr          4096a   Varying
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
     **-- Send diagnostic message:
     D SndDiagMsg      Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
 
     **-- Entry parameters:
     D ObjNam_q        Ds
     D  ObjNam                       10a
     D  ObjLib                       10a
     **
     D SbmParms        Ds                  Qualified
     D   NbrOpt                       5i 0
     D   RtgDta                       1a
     D   OutQue                       1a
     D   PrtDev                       1a
     D   InqMsgRpy                    1a
     D   JobNam                      10a
     D   JobDsc_q                          LikeDs( ObjNam_q )
     D   JobQue_q                          LikeDs( ObjNam_q )
     D   User                         1a
     **
     D InzSize         Ds                  Qualified
     D   NbrOpt                       5i 0
     D   InzRcd                      10i 0
     D   IncNbr                       5i 0
     D   MaxInc                       5i 0
     **
     D CBX993V         Pr
     D  PxOptLib                     10a
     D  PxDbgCsrPos                   1a
     D  PxSbmParms                         LikeDs( SbmParms )
     D  PxAlwOutFil                   1a
     D  PxInzSize                          LikeDs( InzSize )
     D  PxCrtDtaAra                   4a
     **
     D CBX993V         Pi
     D  PxOptLib                     10a
     D  PxDbgCsrPos                   1a
     D  PxSbmParms                         LikeDs( SbmParms )
     D  PxAlwOutFil                   1a
     D  PxInzSize                          LikeDs( InzSize )
     D  PxCrtDtaAra                   4a
 
      /Free
 
        If  ChkObj( PxOptLib + 'QSYS': '*LIB' ) = *Off;
 
          SndDiagMsg( 'CPD0006': '0000' + RtvMsg( 'CPF9810': PxOptLib ));
 
          SndEscMsg( 'CPF0002': '' );
        EndIf;
 
        If  PxCrtDtaAra = '*NO'  And
            ChkObj( PrfOpts + PxOptLib: '*DTAARA' ) = *Off;
 
          SndDiagMsg( 'CPD0006'
                    : '0000' +
                      RtvMsg( 'CPF2105': PrfOpts + PxOptLib + 'DTAARA' )
                    );
 
          SndEscMsg( 'CPF0002': '' );
        EndIf;
 
        If  PxCrtDtaAra = '*YES'  And
            ChkObj( PrfOpts + PxOptLib: '*DTAARA' ) = *On;
 
          SndDiagMsg( 'CPD0006'
                    : '0000' +
                      RtvMsg( 'CPD2104': PrfOpts + PxOptLIb + 'DTAARA' )
                    );
 
          SndEscMsg( 'CPF0002': '' );
        EndIf;
 
        If  %Scan( '*': PxSbmParms.JobDsc_q ) = *Zero;
 
          If  ChkObj( PxSbmParms.JobDsc_q: '*JOBD' ) = *Off;
 
            SndDiagMsg( 'CPD0006'
                      : '0000' +
                        RtvMsg( 'CPF2105': PxSbmParms.JobDsc_q + 'JOBD' )
                      );
 
            SndEscMsg( 'CPF0002': '' );
          EndIf;
        EndIf;
 
        If  %Scan( '*': PxSbmParms.JobQue_q ) = *Zero;
 
          If  ChkObj( PxSbmParms.JobQue_q: '*JOBQ' ) = *Off;
 
            SndDiagMsg( 'CPD0006'
                      : '0000' +
                        RtvMsg( 'CPF2105': PxSbmParms.JobQue_q + 'JOBQ' )
                      );
 
            SndEscMsg( 'CPF0002': '' );
          EndIf;
        EndIf;
 
        *InLr = *On;
        Return;
 
 
      /End-Free
 
     **-- Check object existence:  -------------------------------------------**
     P ChkObj          B                   Export
     D                 Pi              n
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const
     **
     D OBJD0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  ObjNam                       10a
     D  ObjLib                       10a
     D  ObjTyp                       10a
 
      /Free
 
         RtvObjD( OBJD0100
                : %Size( OBJD0100 )
                : 'OBJD0100'
                : PxObjNam_q
                : PxObjTyp
                : ERRC0100
                );
 
         If  ERRC0100.BytAvl > *Zero;
           Return  *Off;
 
         Else;
           Return  *On;
         EndIf;
 
      /End-Free
 
     P ChkObj          E
     **-- Retrieve message:
     P RtvMsg          B
     D                 Pi          4096a   Varying
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
     **
     D RTVM0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  RtnMsgLen                    10i 0
     D  RtnMsgAvl                    10i 0
     D  RtnHlpLen                    10i 0
     D  RtnHlpAvl                    10i 0
     D  Msg                        4096a
     **
     D RPL_SUB_VAL     c                   '*YES'
     D NOT_FMT_CTL     c                   '*NO'
 
      /Free
 
        RtvMsgD( RTVM0100
               : %Size( RTVM0100 )
               : 'RTVM0100'
               : PxMsgId
               : 'QCPFMSG   *LIBL'
               : PxMsgDta
               : %Len( PxMsgDta )
               : RPL_SUB_VAL
               : NOT_FMT_CTL
               : ERRC0100
               );
 
        Select;
        When  ERRC0100.BytAvl > *Zero;
          Return  NULL;
 
        When  %Subst( RTVM0100.Msg: 1: RTVM0100.RtnMsgLen ) = PxMsgId;
          Return  %Subst( RTVM0100.Msg
                        : RTVM0100.RtnMsgLen + 1
                        : RTVM0100.RtnHlpLen
                        );
 
        Other;
          Return  %Subst( RTVM0100.Msg: 1: RTVM0100.RtnMsgLen );
        EndSl;
 
      /End-Free
 
     P RtvMsg          E
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
