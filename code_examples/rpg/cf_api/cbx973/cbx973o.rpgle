     **
     **  Program . . : CBX973O
     **  Description : Set Default Journal - POP
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **  Parameters:
     **    PxCmdNam_q  INPUT      Qualified command name
     **
     **    PxKeyPrm1   INPUT      Key parameter identifying the
     **                           library where the default journal
     **                           data area is located.
     **
     **    PxCmdStr    OUTPUT     The formatted command prompt
     **                           string returning the current
     **                           default journal setting.
     **
     **
     **  Compile options:
     **    CrtRpgMod Module( CBX973O )
     **              DbgView( *LIST )
     **
     **    CrtPgm    Pgm( CBX973O )
     **              Module( CBX973O )
     **              ActGrp( *CALLER )
     **
     **
     **-- Header specifications:  --------------------------------------------**
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
     D ALL_DTA         c                   -1
     **-- Global variables:
     D Idx             s             10i 0
     D DftJrn          s             10a   Inz( 'QDFTJRN' )
 
     **-- Data area data:
     D DTAA0100        Ds                  Qualified
     D  BytAvl                       10i 0
     D  BytRtn                       10i 0
     D  ValTyp                       10a
     D  LibNam                       10a
     D  ValLen                       10i 0
     D  NbrDec                       10i 0
     D  DtaVal                     2000a
     **
     D QDFTJRN         Ds                  Qualified
     D  JrnLib                       10a
     D  JrnNam                       10a
     D  JrnOpt                       20a   Dim( 5 )
     D   ObjTyp                      10a   Overlay( JrnOpt:  1 )
     D   Option                      10a   Overlay( JrnOpt: 11 )
 
     **-- Retrieve data area:
     D RtvDtaAra       Pr                  ExtPgm( 'QWCRDTAA' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  DtaAra_q                     20a   Const
     D  StrPos                       10i 0 Const
     D  DtaLen                       10i 0 Const
     D  Error                     32767a          Options( *VarSize )
     **-- Send program message:
     D SndPgmMsg       Pr                  ExtPgm( 'QMHSNDPM' )
     D  MsgId                         7a   Const
     D  MsgFil_q                     20a   Const
     D  MsgDta                      512a   Const  Options( *VarSize )
     D  MsgDtaLen                    10i 0 Const
     D  MsgTyp                       10a   Const
     D  CalStkEnt                    10a   Const  Options( *VarSize )
     D  CalStkCtr                    10i 0 Const
     D  MsgKey                        4a
     D  Error                       512a          Options( *VarSize )
     **
     D  CalStkEntLen                 10i 0 Const  Options( *NoPass )
     D  CalStkEntQlf                 20a   Const  Options( *NoPass )
     D  DspWait                      10i 0 Const  Options( *NoPass )
     **
     D  CalStkEntTyp                 20a   Const  Options( *NoPass )
     D  CcsId                        10i 0 Const  Options( *NoPass )
 
     **-- Send diagnostic message:
     D SndDiagMsg      Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
 
     **-- Entry parameters:
     D CBX973O         Pr
     D  PxCmdNam_q                   20a
     D  PxKeyPrm1                    10a
     D  PxCmdStr                  32674a   Varying
     **
     D CBX973O         Pi
     D  PxCmdNam_q                   20a
     D  PxKeyPrm1                    10a
     D  PxCmdStr                  32674a   Varying
 
      /Free
 
        RtvDtaAra( DTAA0100
                 : %Len( DTAA0100 )
                 : DftJrn + PxKeyPrm1
                 : ALL_DTA
                 : %Size( DTAA0100.DtaVal )
                 : ERRC0100
                 );
 
        Select;
        When  ERRC0100.BytAvl > *Zero  And ERRC0100.MsgId = 'CPF1015';
 
        When  ERRC0100.BytAvl > *Zero;
 
          If  ERRC0100.BytAvl < OFS_MSGDTA;
            ERRC0100.BytAvl = OFS_MSGDTA;
          EndIf;
 
          SndDiagMsg( ERRC0100.MsgId
                    : %Subst( ERRC0100.MsgDta: 1: ERRC0100.BytAvl - OFS_MSGDTA )
                    );
 
          SndEscMsg( 'CPF0011': '' );
 
        Other;
          If  DTAA0100.ValTyp = '*CHAR';
            ExSr  GetDta;
          EndIf;
        EndSl;
 
        *InLr = *On;
        Return;
 
 
        BegSr  GetDta;
 
          QDFTJRN = %Subst( DTAA0100.DtaVal: 1: DTAA0100.ValLen );
 
          If  QDFTJRN.JrnNam > *Blanks;
 
            PxCmdStr += '??JRN(' + %Trim( QDFTJRN.JrnLib ) +
                             '/' + %Trim( QDFTJRN.JrnNam ) + ') ';
 
            If  QDFTJRN.JrnOpt(1) > *Blanks;
              PxCmdStr += '??OPTION(';
 
              For  Idx = 1  to  %Elem( QDFTJRN.JrnOpt );
 
                If  QDFTJRN.JrnOpt(Idx) > *Blanks;
                  PxCmdStr += '(' + %Trim( QDFTJRN.ObjTyp(Idx)) +
                              ' ' + %Trim( QDFTJRN.Option(Idx)) + ') ';
                EndIf;
              EndFor;
 
              PxCmdStr += ') ';
            EndIf;
          EndIf;
 
          PxCmdStr += '?%CREATE(*NO)';
 
        EndSr;
 
      /End-Free
 
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
