     **
     **  Program . . . : CBX989
     **  Description . : Retrieve Query Attributes - CPP
     **  Technique . . : Elvis Budimlic, Centerfield Technology
     **
     **  Programmer  . : Carsten Flensburg
     **  Published . . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **
     **  Programmer's notes:
     **    Using the Retrieve Prompt Override API to extract current values
     **    for specific system entities not accessible elsewhere, is a
     **    technique conceived and originally implemented by Elvis Budimlic
     **    of www.centerfieldtechnology.com
     **
     **
     **  Compilation instructions:
     **    CrtRpgMod   Module( CBX989 )
     **                DbgView( *NONE )
     **
     **    CrtPgm      Pgm( CBX989 )
     **                Module( CBX989 )
     **                ActGrp( *NEW )
     **
     **
     **-- Header specifications:  --------------------------------------------**
     H Option( *SrcStmt )   BndDir( 'QC2LE' )
 
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
 
     **-- Global variables:
     D CmdStr          s          32702a   Varying
     D OvrStr          s          32702a   Varying
     **-- Global constants:
     D NULL            c                   ''
     D OFS_MSGDTA      c                   16
 
     **-- Prompt command information:
     D RTVP0100        Ds          4096    Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  PopNam                       10a
     D  PopLib                       10a
     D  OfsPocStr                    10i 0
     D  LenPocStr                    10i 0
 
     **-- Retrieve prompt override:
     D RtvPmtOvr       Pr                  ExtPgm( 'QPTRTVPO' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  CmdStr                    32702a   Const  Options( *VarSize )
     D  CmdStrLen                    10i 0 Const
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
     **-- Tokenize string:
     D strtok          Pr              *   ExtProc( 'strtok' )
     D  string                         *   Value  Options( *String )
     D  delimiters                     *   Value  Options( *String )
     **-- Alfa to integer:
     D atoi            Pr            10i 0 ExtProc( 'atoi' )
     D  alfanum                        *   Value  Options( *String )
 
     **-- Retrieve parameter value:
     D RtvParmVal      Pr           256a   Varying
     D  PxParmStr                  4096a   Const  Varying  Options( *Trim )
     D  PxParmKwd                    10a   Const  Varying  Options( *Trim )
     D  PxParmPos                     5i 0 Const           Options( *NoPass )
     **-- Format query limit:
     D FmtQryLmt       Pr            10i 0
     D  PxParmStr                   256a   Const  Varying
     **-- Get string:
     D GetStr          Pr          1024a   Varying
     D  PxStrPtr                       *   Value
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgFil                     10a   Const
     D  PxMsgDta                    512a   Const  Varying
 
     **-- Entry parameters:
     D JobNam_q        Ds
     D  JobNam                       10a
     D  UsrPrf                       10a
     D  JobNbr                        6a
     **
     D CBX989          Pr
     D  PxJobNam_q                         LikeDs( JobNam_q )
     D  PxQryTimLmt                  10p 0
     D  PxDegree                     10a
     D  PxNbrTasks                    5p 0
     D  PxAsyncJob                   10a
     D  PxApyRmt                     10a
     D  PxQryOptLib                  10a
     D  PxQryStgLmt                  10p 0
     **
     D CBX989          Pi
     D  PxJobNam_q                         LikeDs( JobNam_q )
     D  PxQryTimLmt                  10p 0
     D  PxDegree                     10a
     D  PxNbrTasks                    5p 0
     D  PxAsyncJob                   10a
     D  PxApyRmt                     10a
     D  PxQryOptLib                  10a
     D  PxQryStgLmt                  10p 0
 
      /Free
 
        If  PxJobNam_q.JobNam = '*';
          CmdStr = 'CHGQRYA JOB(*)';
        Else;
          CmdStr = 'CHGQRYA JOB(' + %Trim( PxJobNam_q.JobNbr ) + '/' +
                                    %Trim( PxJobNam_q.UsrPrf ) + '/' +
                                    %Trim( PxJobNam_q.JobNam ) + ')';
        EndIf;
 
        RtvPmtOvr( RTVP0100
                 : %Size( RTVP0100 )
                 : 'RTVP0100'
                 : CmdStr
                 : %Len( CmdStr )
                 : ERRC0100
                 );
 
        If  ERRC0100.BytAvl > *Zero;
          ExSr  EscApiMsg;
        Else;
          ExSr  PrcRcvVar;
        EndIf;
 
        *InLr = *On;
        Return;
 
 
        BegSr  PrcRcvVar;
 
          OvrStr = %Subst( RTVP0100
                         : RTVP0100.OfsPocStr + 1
                         : RTVP0100.LenPocStr
                         );
 
          If  %Addr( PxQryTimLmt ) <> *Null;
            PxQryTimLmt = FmtQryLmt( RtvParmVal( OvrStr: 'QRYTIMLMT' ));
          EndIf;
 
          If  %Addr( PxDegree ) <> *Null;
            PxDegree = RtvParmVal( OvrStr: 'DEGREE': 1 );
          EndIf;
 
          If  %Addr( PxNbrTasks ) <> *Null;
            PxNbrTasks = atoi( RtvParmVal( OvrStr: 'DEGREE': 2 ));
          EndIf;
 
          If  %Addr( PxAsyncJob ) <> *Null;
            PxAsyncJob = RtvParmVal( OvrStr: 'ASYNCJ' );
          EndIf;
 
          If  %Addr( PxApyRmt ) <> *Null;
            PxApyRmt = RtvParmVal( OvrStr: 'APYRMT' );
          EndIf;
 
          If  %Addr( PxQryOptLib ) <> *Null;
            PxQryOptLib = RtvParmVal( OvrStr: 'QRYOPTLIB' );
          EndIf;
 
          If  %Addr( PxQryStgLmt ) <> *Null;
            PxQryStgLmt = FmtQryLmt( RtvParmVal( OvrStr: 'QRYSTGLMT' ));
          EndIf;
 
        EndSr;
 
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
 
     **-- Retrieve parameter value:
     P RtvParmVal      B
     D                 Pi           256a   Varying
     D  PxParmStr                  4096a   Const  Varying  Options( *Trim )
     D  PxParmKwd                    10a   Const  Varying  Options( *Trim )
     D  PxParmPos                     5i 0 Const           Options( *NoPass )
 
     **-- Local variables:
     D Idx             s             10i 0
     D KwdPos          s             10i 0
     D ParPos          s             10i 0
     D ValPos          s             10i 0
     D EndPos          s             10i 0
     D ValStr          s            256a   Varying
     D ParmStr         s            256a   Varying
 
      /Free
 
        KwdPos = %Scan( PxParmKwd + '(' : PxParmStr );
 
        If  KwdPos > *Zero;
 
          ParPos = KwdPos + %Len( PxParmKwd );
 
          ValPos = %Check( '( ':  PxParmStr: ParPos );
 
          EndPos = %Scan( ')':  PxParmStr: ValPos );
 
          If  %Parms = 3  And  PxParmPos > *Zero;
 
            ValStr = %Trim( %Subst( PxParmStr: Valpos: EndPos - ValPos ));
            ParmStr = GetStr( strtok( ValStr: ' ' ));
 
            For  Idx = 1  to  PxParmPos - 1;
              ParmStr = GetStr( strtok( *Null: ' ' ));
            EndFor;
 
            Return  ParmStr;
          Else;
 
            Return  %Trim( %Subst( PxParmStr: Valpos: EndPos - ValPos ));
          EndIf;
        EndIf;
 
        Return  NULL;
 
      /End-Free
 
     P RtvParmVal      E
     **-- Format query limit:
     P FmtQryLmt       B
     D                 Pi            10i 0
     D  PxParmStr                   256a   Const  Varying
 
      /Free
 
        Select;
        When  PxParmStr = '*NOMAX';
          Return  -1;
 
        When  PxParmStr = '*SAME';
          Return  -2;
 
        When  PxParmStr = '*SYSVAL';
          Return  -3;
 
        Other;
          Return  atoi( PxParmStr );
        EndSl;
 
      /End-Free
 
     P FmtQryLmt       E
     **-- Get string:
     P GetStr          B
     D                 Pi          1024a   Varying
     D  PxStrPtr                       *   Value
 
      /Free
 
         If  PxStrPtr  = *Null;
           Return  NULL;
         Else;
           Return  %Str( PxStrPtr );
         EndIf;
 
      /End-Free
 
     P GetStr          E
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
