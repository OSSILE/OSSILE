     **
     **  Program . . : CBX993O
     **  Description : Set Query Profile Options - POP
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **  Parameters:
     **    PxCmdNam_q  INPUT      Qualified command name
     **
     **    PxKeyPrm1   INPUT      Key parameter identifying the library
     **                           where the query profile options data
     **                           area is located.
     **
     **    PxCmdStr    OUTPUT     The formatted command prompt
     **                           string returning the current
     **                           query profile options setting.
     **
     **
     **  Compile options:
     **    CrtRpgMod Module( CBX993O )
     **              DbgView( *LIST )
     **
     **    CrtPgm    Pgm( CBX993O )
     **              Module( CBX993O )
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
     D NULL            c                   ''
     **-- Global variables:
     D Idx             s             10i 0
     D PrfOpts         s             10a   Inz( 'QQUPRFOPTS' )
 
     **-- Data area data:
     D DTAA0100        Ds                  Qualified
     D  BytAvl                       10i 0
     D  BytRtn                       10i 0
     D  ValTyp                       10a
     D  LibNam                       10a
     D  ValLen                       10i 0
     D  NbrDec                       10i 0
     D  DtaVal                     2000a
 
     **-- Data area format:
     D QQUPRFOPTS      Ds                  Qualified
     D  DbgCsrPos                     1a
     D  RtgDta                        1a
     D  OutQue                        1a
     D  PrtDev                        1a
     D  InqMsgRpy                     1a
     D  JobNam                       10a
     D  JobDsc_q                     20a
     D  JobQue_q                     20a
     D  InzRcd                       10a
     D  IncNbr                        5a
     D  MaxInc                        5a
     D  User                          1a
     D  AlwOutFil                     1a
 
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
 
     **-- Get debug cursor position:
     D GetDbgCsp       Pr            10a   Varying
     D  PxDbgCsp                      1a   Const
     **-- Get routing data:
     D GetRtgDta       Pr            10a   Varying
     D  PxRtgDta                      1a   Const
     **-- Get output queue:
     D GetOutQue       Pr            10a   Varying
     D  PxOutQue                      1a   Const
     **-- Get print device:
     D GetPrtDev       Pr            10a   Varying
     D  PxPrtDev                      1a   Const
     **-- Get inquiry message reply:
     D GetInqMrp       Pr            10a   Varying
     D  PxInqMrp                      1a   Const
     **-- Get user:
     D GetUser         Pr            10a   Varying
     D  PxUser                        1a   Const
     **-- Get allow outfile:
     D GetAlwOtf       Pr            10a   Varying
     D  PxAlwOtf                      1a   Const
     **-- Format qualified name:
     D FmtQualNm       Pr            21a   Varying
     D  PxObjNam_q                   20a   Const
     **-- Format initial file size:
     D FmtInzSiz       Pr            30a   Varying
     D  PxInzRcd                     10a   Const
     D  PxIncNbr                      5a   Const
     D  PxMaxInc                      5a   Const
     **-- Send diagnostic message:
     D SndDiagMsg      Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
 
     **-- Entry parameters:
     D CBX993O         Pr
     D  PxCmdNam_q                   20a
     D  PxKeyPrm1                    10a
     D  PxCmdStr                  32674a   Varying
     **
     D CBX993O         Pi
     D  PxCmdNam_q                   20a
     D  PxKeyPrm1                    10a
     D  PxCmdStr                  32674a   Varying
 
      /Free
 
        RtvDtaAra( DTAA0100
                 : %Len( DTAA0100 )
                 : PrfOpts + PxKeyPrm1
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
 
          QQUPRFOPTS = %Subst( DTAA0100.DtaVal: 1: DTAA0100.ValLen );
 
          PxCmdStr  = '??DBGCSRPOS(' + GetDbgCsp( QQUPRFOPTS.DbgCsrPos ) +
                    ') ??SBMPARM('   + GetRtgDta( QQUPRFOPTS.RtgDta )    +
                               ' '   + GetOutQue( QQUPRFOPTS.OutQue )    +
                               ' '   + GetPrtDev( QQUPRFOPTS.PrtDev )    +
                               ' '   + GetInqMrp( QQUPRFOPTS.InqMsgRpy ) +
                               ' '   +    %TrimR( QQUPRFOPTS.JobNam )    +
                               ' '   + FmtQualNm( QQUPRFOPTS.JobDsc_q )  +
                               ' '   + FmtQualNm( QQUPRFOPTS.JobQue_q )  +
                               ' '   +   GetUser( QQUPRFOPTS.User )      +
                 ') ??ALWOUTFILE('   + GetAlwOtf( QQUPRFOPTS.AlwOutFil ) +
                    ') ??INZSIZE('   + FmtInzSiz( QQUPRFOPTS.InzRcd
                                                : QQUPRFOPTS.IncNbr
                                                : QQUPRFOPTS.MaxInc
                                                ) + ')';
 
          PxCmdStr += ' ?%CREATE(*NO)';
 
        EndSr;
 
      /End-Free
 
     **-- Get debug cursor position:
     P GetDbgCsp       B
     D                 Pi            10a   Varying
     D  PxDbgCsp                      1a   Const
 
      /Free
 
        Select;
        When  PxDbgCsp = ' ';
          Return  '*MSGLIN';
 
        When  PxDbgCsp = 'N';
          Return  '*NONDBG';
 
        Other;
          Return  NULL;
        EndSl;
 
      /End-Free
 
     P GetDbgCsp       E
     **-- Get routing data:
     P GetRtgDta       B
     D                 Pi            10a   Varying
     D  PxRtgDta                      1a   Const
 
      /Free
 
        Select;
        When  PxRtgDta = ' ';
          Return  '*JOBD';
 
        When  PxRtgDta = 'B';
          Return  'QCMDB';
 
        Other;
          Return  NULL;
        EndSl;
 
      /End-Free
 
     P GetRtgDta       E
     **-- Get output queue:
     P GetOutQue       B
     D                 Pi            10a   Varying
     D  PxOutQue                      1a   Const
 
      /Free
 
        Select;
        When  PxOutQue = 'J';
          Return  '*JOBD';
 
        When  PxOutQue = 'C';
          Return  '*CURRENT';
 
        When  PxOutQue = 'U';
          Return  '*USRPRF';
 
        When  PxOutQue = 'D';
          Return  '*DEV';
 
        Other;
          Return  NULL;
        EndSl;
 
      /End-Free
 
     P GetOutQue       E
     **-- Get print device:
     P GetPrtDev       B
     D                 Pi            10a   Varying
     D  PxPrtDev                      1a   Const
 
      /Free
 
        Select;
        When  PxPrtDev = 'J';
          Return  '*JOBD';
 
        When  PxPrtDev = 'C';
          Return  '*CURRENT';
 
        When  PxPrtDev = 'U';
          Return  '*USRPRF';
 
        When  PxPrtDev = 'S';
          Return  '*SYSVAL';
 
        Other;
          Return  NULL;
        EndSl;
 
      /End-Free
 
     P GetPrtDev       E
     **-- Get inquiry message reply:
     P GetInqMrp       B
     D                 Pi            10a   Varying
     D  PxInqMrp                      1a   Const
 
      /Free
 
        Select;
        When  PxInqMrp = 'J';
          Return  '*JOBD';
 
        When  PxInqMrp = 'R';
          Return  '*RQD';
 
        When  PxInqMrp = 'D';
          Return  '*DFT';
 
        When  PxInqMrp = 'S';
          Return  '*SYSRPYL';
 
        Other;
          Return  NULL;
        EndSl;
 
      /End-Free
 
     P GetInqMrp       E
     **-- Get user:
     P GetUser         B
     D                 Pi            10a   Varying
     D  PxUser                        1a   Const
 
      /Free
 
        Select;
        When  PxUser = 'J';
          Return  '*JOBD';
 
        When  PxUser = ' ';
          Return  '*CURRENT';
 
        Other;
          Return  NULL;
        EndSl;
 
      /End-Free
 
     P GetUser         E
     **-- Get allow outfile:
     P GetAlwOtf       B
     D                 Pi            10a   Varying
     D  PxAlwOtf                      1a   Const
 
      /Free
 
        Select;
        When  PxAlwOtf = ' ';
          Return  '*YES';
 
        When  PxAlwOtf = 'Y';
          Return  '*NO';
 
        Other;
          Return  NULL;
        EndSl;
 
      /End-Free
 
     P GetAlwOtf       E
     **-- Format qualified name:
     P FmtQualNm       B
     D                 Pi            21a   Varying
     D  PxObjNam_q                   20a   Const
 
      /Free
 
        If  %Scan( '*': PxObjNam_q ) = 1;
          Return  %TrimR( PxObjNam_q );
 
        Else;
          Return  %TrimR( %Subst( PxObjNam_q: 11: 10 )) + '/' +
                  %TrimR( %Subst( PxObjNam_q:  1: 10 ));
        EndIf;
 
      /End-Free
 
     P FmtQualNm       E
     **-- Format initial file size:
     P FmtInzSiz       B
     D                 Pi            30a   Varying
     D  PxInzRcd                     10a   Const
     D  PxIncNbr                      5a   Const
     D  PxMaxInc                      5a   Const
 
      /Free
 
        If  PxInzRcd = *Blanks;
          Return  '*NOMAX';
 
        Else;
          Return  %Trim( PxInzRcd ) + ' ' +
                  %Trim( PxIncNbr ) + ' ' +
                  %Trim( PxMaxInc ) + ' ';
        EndIf;
 
      /End-Free
 
     P FmtInzSiz       E
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
