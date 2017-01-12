     **
     **  Program . . : CBX99A
     **  Description : Query Governor Exit Program
     **  Author  . . : Carsten Flensburg
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
     **                  Pgm( <library name>/CBX99A )
     **                  Text( 'Query guvernor exit program' )
     **
     **
     **  Compilation instructions:
     **    CrtBndRpg   Pgm( CBX99A )
     **                SrcFile( QRPGLESRC )
     **                SrcMbr( CBX99A )
     **                DbgView( *NONE )
     **                Replace( *NO )
     **                Aut( *USE )
     **
     **
     **-- Header specifications:  --------------------------------------------**
     H Option( *SrcStmt )  DftActGrp( *NO )  ActGrp( *CALLER )

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
     D CHK_QRY_...
     D  ALW_INTER      c                   'CBX_QUERY_400_ALLOW_INTER'
     D USG_DNY         c                   '1'
     D USG_ALW         c                   '2'
     **
     D TYP_INTER       c                   'I'
     **-- Global variables:
     D FcnUsgInd       s              1a

     **-- Query Governor input information:
     D QRYG0100        Ds         65535    Qualified
     D  SizFixHdr                    10i 0
     D  FmtNam                        8a
     D  JobNam                       10a
     D  UsrNam                       10a
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

     **-- Check function usage:
     D ChkFcnUsg       Pr                  ExtProc( 'QsyCheckUserFunctionUsage')
     D  UsgInd                        1a
     D  FcnId                        30a   Const
     D  UsrPrf                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Retrieve job information:
     D RtvJobInf       Pr                  ExtPgm( 'QUSRJOBI' )
     D  RcvVar                    32767a         Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  JobNamQ                      26a   Const
     D  JobIntId                     16a   Const
     D  Error                     32767a         Options( *NoPass: *VarSize )

     **-- Get job type:
     D GetJobTyp       Pr             1a

     **-- Entry parameters:
     D CBX571          Pr
     D  PxInpInf                           LikeDs( QRYG0100 )
     D  PxRtnCod                     10i 0
     **
     D CBX571          Pi
     D  PxInpInf                           LikeDs( QRYG0100 )
     D  PxRtnCod                     10i 0

      /Free

        PxRtnCod = QRY_DFT_ACT;

        If  PxInpInf.TimLmtSpf > *Zero;

          If  GetJobTyp() <> TYP_INTER;
            PxRtnCod = QRY_ALW;

          Else;
            SqlStmTxt = %Subst( PxInpInf
                              : PxInpInf.OfsSqlStm + 1
                              : PxInpInf.LenSqlStm
                              );

            ChkFcnUsg( FcnUsgInd: CHK_QRY_ALW_INTER: '*CURRENT': ERRC0100 );

            Select;
            When  ERRC0100.BytAvl = *Zero  And  FcnUsgInd = USG_ALW;
              PxRtnCod = QRY_ALW;

            When  PxInpInf.RunTimEst > PxInpInf.TimLmtSpf  Or
                  PxInpInf.TmpStgEst > PxInpInf.StgLmtSpf;

              PxRtnCod = QRY_CNL;
            EndSl;
          EndIf;
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
