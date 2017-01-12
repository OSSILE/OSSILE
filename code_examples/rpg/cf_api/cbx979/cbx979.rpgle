     **
     **  Program . . : CBX979
     **  Description : Query Governor Exit Program
     **  Author  . . : Carsten Flensburg
     **
     **
     **  Programmer's notes:
     **    The service program referenced by this exit program is specified
     **    with library qualification to avoid library list dependencies
     **    when the exit program is being called.  If you at a later point
     **    move the service program to another library, you will need to
     **    update this program's service program reference accordingly.
     **
     **
     **  Program information:
     **    The Query Governor exit program is called when a job is running a
     **    query and the estimated runtime or temporary storage usage has
     **    exceeded the user specified limits. This exit is called in the job
     **    that is attempting to run the query.
     **
     **    The exit program is passed a structure that contains the estimated
     **    runtime, the user specified runtime limit, the estimated temporary
     **    storage usage, and the user specified temporary storage limit for the
     **    query. Also included is the Structured Query Language (SQL) statement
     **    text of the query, if applicable.
     **
     **    The exit program may set a return code value that is basically used
     **    to either ignore the exceeded limit and continue running the query or
     **    end the query request. When a query is run, the operating system calls
     **    the user-written exit program through the registration facility.
     **
     **    Exit program(s) registered for this exit point must be thread safe and
     **    compiled with ACTGRP(*CALLER) because the exit program may be called
     **    as the result of a query in an SQL external function. SQL external
     **    functions do not allow ACTGRP(*NEW).
     **
     **    Many applications and tools set the query time limit to 0 for
     **    gathering performance information. It is recommended that exit
     **    program(s) return a 0 for a query time limit of 0.
     **
     **    The exit program can be registered using the registration
     **    facility commands or APIs. Use the CL command Work with
     **    Registration Info (WRKREGINF) to enter the registration
     **    facility.
     **
     **    Exit point name:  QIBM_QQQ_QUERY_GOVR
     **
     **    Exit Point Format Name:  QRYG0100
     **
     **      AddExitPgm  ExitPnt( QIBM_QQQ_QUERY_GOVR )
     **                  Format( QRYG0100 )
     **                  PgmNbr( *LOW )
     **                  Pgm( <library name>/CBX979 )
     **                  Text( 'Query guvernor exit program' )
     **
     **
     **  Compilation instructions:
     **    CrtRpgMod Module( CBX979 )
     **              DbgView( *NONE )
     **
     **    CrtPgm    Pgm( CBX979 )
     **              Module( CBX979 )
     **              BndSrvPgm( <srvpgmlib>/CBX980 )
     **              AlwUpd( *YES )
     **              AlwLibUpd( *YES )
     **              ActGrp( *CALLER )
     **              Aut( *USE )
     **
     **
     **-- Header specifications:  --------------------------------------------**
     H Option( *SrcStmt )
 
     **-- API error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
 
     **-- Global constants:
     D QRY_DFT_ACT     c                   0
     D QRY_ALW         c                   1
     D QRY_ALW_DBM     c                   2
     D QRY_CNL         c                   3
     **
     D NULL            c                   ''
     D TYP_INTER       c                   'I'
     D USR_APP_NAM     c                    'CBX_QQQ_USRQRYA'
     **-- Global variables:
     D QryUsr          s             10a
 
     **-- Query Governor input information:
     D QRYG0100_T      Ds         65535    Qualified
     D  SizFixHdr                    10i 0
     D  FmtNam                        8a
     D  JobNam                       10a
     D  UsrPrf                       10a
     D  JobNbr                        6a
     D  CurUsr                       10a
     D  RunTimEst                    10i 0
     D  TimLmtSpf                    10i 0
     D  TmpStgEst                    10i 0
     D  StgLmtSpf                    10i 0
     D  OfsSqlStm                    10i 0
     D  LenSqlStm                    10i 0
     **
     D SqlStmTxt       s          65535a   Varying
     **-- User query attributes application information:
     D UsrQryAtr       Ds                  Qualified
     D  FmtLen                       10i 0
     D  FmtNam                        8a
     D  Resv1                         4a
     D  QryIntLmt                    10i 0
     D  QryIntAlw                    10a
     D  QryOptLib                    10a
     D  Resv2                       216a   Inz
 
     **-- Retrieve job information:
     D RtvJobInf       Pr                  ExtPgm( 'QUSRJOBI' )
     D  RcvVar                    32767a         Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  JobNamQ                      26a   Const
     D  JobIntId                     16a   Const
     D  Error                     32767a         Options( *NoPass: *VarSize )
     **-- Retrieve user application info:
     D RtvUsrAppInf    Pr                  ExtProc( 'QsyRetrieveUser-
     D                                     ApplicationInfo' )
     D  RcvVar                    32767a   Const  Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  RtnRcdInf                    12a   Const
     D  FmtNam                        8a   Const
     D  UsrPrf                       10a   Const
     D  AppInfId                    200a   Const  Options( *VarSize )
     D  AppInfIdLen                  10i 0 Const
     D  Error                     32767a          Options( *VarSize: *NoPass)
 
     **-- Get job type:
     D GetJobTyp       Pr             1a
     **-- Get group profile:
     D GetGrpPrf       Pr            10a
     D  PxUsrPrf                     10a   Const
     **-- Verify user query attributes:
     D VfyUsrQryA      Pr              n
     D  PxUsrPrf                     10a   Const
     **-- Get user query attributes:
     D GetUsrQryA      Pr           256a
     D  PxUsrPrf                     10a   Const
     **-- Verify user application information:
     D VfyUsrAppInf    Pr              n
     D  PxUsrPrf                     10a   Const
     D  PxAppInfId                  200a   Const  Varying
     **-- Get user application information:
     D GetUsrAppInf    Pr          1700a   Varying
     D  PxUsrPrf                     10a   Const
     D  PxAppInfId                  200a   Const  Varying
 
     **-- Entry parameters:
     D CBX979          Pr
     D  QRYG0100                           LikeDs( QRYG0100_T )
     D  PxRtnCod                     10i 0
     **
     D CBX979          Pi
     D  QRYG0100                           LikeDs( QRYG0100_T )
     D  PxRtnCod                     10i 0
 
      /Free
 
        PxRtnCod = QRY_DFT_ACT;
 
        If  QRYG0100.TimLmtSpf > *Zero;
 
          Select;
          When  VfyUsrQryA( QRYG0100.UsrPrf ) = *On;
            QryUsr = QRYG0100.UsrPrf;
 
          When  VfyUsrQryA( GetGrpPrf( QRYG0100.UsrPrf )) = *On;
            QryUsr = GetGrpPrf( QRYG0100.UsrPrf );
 
          Other;
            QryUsr = '*NONE';
          EndSl;
 
          Select;
          When  QryUsr <> '*NONE';
            UsrQryAtr = GetUsrQryA( QryUsr );
 
            Select;
            When  GetJobTyp() = TYP_INTER  And
                  UsrQryAtr.QryIntAlw = '*YES';
              PxRtnCod = QRY_ALW;
 
            When  QRYG0100.RunTimEst > QRYG0100.TimLmtSpf  Or
                  QRYG0100.TmpStgEst > QRYG0100.StgLmtSpf;
 
              PxRtnCod = QRY_CNL;
            EndSl;
 
          When  QRYG0100.RunTimEst > QRYG0100.TimLmtSpf  Or
                QRYG0100.TmpStgEst > QRYG0100.StgLmtSpf;
 
            PxRtnCod = QRY_CNL;
          EndSl;
        EndIf;
 
        *InLr = *On;
        Return;
 
      /End-Free
 
     **-- Get job type:
     P GetJobTyp       B
     D                 Pi             1a
 
     D JOBI0400        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  JobNam                       10a
     D  UsrNam                       10a
     D  JobNbr                        6a
     D  JobIntId                     16a
     D  JobSts                       10a
     D  JobTyp                        1a
     D  JobSubTyp                     1a
 
      /Free
 
        RtvJobInf( JOBI0400
                 : %Size( JOBI0400 )
                 : 'JOBI0400'
                 : '*'
                 : *Blank
                 : ERRC0100
                 );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  *Blank;
 
        Else;
          Return  JOBI0400.JobTyp;
        EndIf;
 
      /End-Free
 
     P GetJobTyp       E
