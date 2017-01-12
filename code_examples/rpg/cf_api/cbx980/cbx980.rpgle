     **
     **  Program . . : CBX980
     **  Description : User Query Attributes - services
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **
     **  Programmer's notes:
     **    The User Application Information APIs were introduced with the
     **    release V5R3, so this program cannot be created on earlier releases.
     **
     **    Please note that in order to update or remove user application
     **    information for another user profile you must have *SECADM special
     **    authority and *OBJMGT and *USE authorities to that user profile.
     **    To retrieve the information, *READ authority to the user profile
     **    is required.
     **
     **
     **  Compile options:
     **    CrtRpgMod   Module( CBX980 )
     **                DbgView( *LIST )
     **
     **    CrtSrvPgm   SrvPgm( CBX980 )
     **                Module( CBX980 )
     **                Export( *SRCFILE )
     **                SrcFile( QSRVSRC )
     **                SrcMbr( CBX980B )
     **                ActGrp( *CALLER )
     **
     **
     **-- Control specification:  --------------------------------------------**
     H NoMain  Option( *SrcStmt )
 
     **-- Api error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0 Inz
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      128a
 
     **-- Global constants:
     D NULL            c                    ''
     D HEX_CCSID       c                    65535
     D USR_APP_NAM     c                    'CBX_QQQ_USRQRYA'
     D USR_APP_RLS     c                    'V5R3M0'
 
     **-- Query attributes user application information:
     D QryAtrUai       Ds                  Qualified
     D  FmtLen                       10i 0 Inz( %Size( QryAtrUai ))
     D  FmtNam                        8a   Inz( 'QRYA0100' )
     D  Resv1                         4a
     D  TimZon                       10a
     D  TimZonAbr                    10a
     D  DspAbrTimZon                  4a
     D  Resv2                        88a
 
     **-- Update user application info:
     D UpdUsrAppInf    Pr                  ExtProc( 'QsyUpdateUser-
     D                                     ApplicationInfo' )
     D  UsrPrf                       10a   Const
     D  AppInfId                    200a   Const  Options( *VarSize )
     D  AppInfIdLen                  10i 0 Const
     D  AppInf                     1700a   Const  Options( *VarSize )
     D  AppInfLen                    10i 0 Const
     D  FstVldRel                     6a   Const
     D  Error                     32767a          Options( *VarSize: *NoPass)
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
     **-- Remove user application info:
     D RmvUsrAppInf    Pr                  ExtProc( 'QsyRemoveUser-
     D                                     ApplicationInfo' )
     D  UsrPrf                       10a   Const
     D  AppInfId                    200a   Const  Options( *VarSize )
     D  AppInfIdLen                  10i 0 Const
     D  Error                     32767a          Options( *VarSize: *NoPass)
     **-- Retrieve user information:
     D RtvUsrInf       Pr                  ExtPgm( 'QSYRUSRI' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                       10a   Const
     D  UsrPrf                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Retrieve object description:
     D RtvObjD         Pr                  ExtPgm( 'QUSROBJD' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  ObjNam_q                     20a   Const
     D  ObjTyp                       10a   Const
     D  Error                     32767a          Options( *VarSize )
 
     **-- Set user query attributes information:
     D SetUsrQryA      Pr            10i 0
     D  PxUsrPrf                     10a   Const
     D  PxUsrQryA                   256a   Const
     **-- Get user query attributes information:
     D GetUsrQryA      Pr           256a
     D  PxUsrPrf                     10a   Const
     **-- Verify user query attributes information:
     D VfyUsrQryA      Pr              n
     D  PxUsrPrf                     10a   Const
     **-- Delete user query attributes information:
     D DltUsrQryA      Pr            10i 0
     D  PxUsrPrf                     10a   Const
 
     **-- Set user application information:
     D SetUsrAppInf    Pr            10i 0
     D  PxUsrPrf                     10a   Const
     D  PxAppInfId                  200a   Const  Varying
     D  PxAppInf                   1700a   Const  Varying
     **-- Get user application information:
     D GetUsrAppInf    Pr          1700a   Varying
     D  PxUsrPrf                     10a   Const
     D  PxAppInfId                  200a   Const  Varying
     **-- Verify user application information:
     D VfyUsrAppInf    Pr              n
     D  PxUsrPrf                     10a   Const
     D  PxAppInfId                  200a   Const  Varying
     **-- Delete user application information:
     D DltUsrAppInf    Pr            10i 0
     D  PxUsrPrf                     10a   Const
     D  PxAppInfId                  200a   Const  Varying
     **-- Get group profile:
     D GetGrpPrf       Pr            10a
     D  PxUsrPrf                     10a   Const
     **-- Check object existence:
     D ChkObj          Pr              n
     D  PxObjNam                     10a   Const
     D  PxObjLib                     10a   Const
     D  PxObjTyp                     10a   Const
 
     **-- Set user query attributes information:
     P SetUsrQryA      B                   Export
     D                 Pi            10i 0
     D  PxUsrPrf                     10a   Const
     D  PxAppInf                    256a   Const
 
      /Free
 
        Return  SetUsrAppInf( PxUsrPrf: USR_APP_NAM: PxAppInf );
 
      /End-Free
 
     P SetUsrQryA      E
     **-- Get user query attributes information:
     P GetUsrQryA      B                   Export
     D                 Pi           256a
     D  PxUsrPrf                     10a   Const
 
      /Free
 
        Return  GetUsrAppInf( PxUsrPrf: USR_APP_NAM );
 
      /End-Free
 
     P GetUsrQryA      E
     **-- Verify user query attributes information:
     P VfyUsrQryA      B                   Export
     D                 Pi              n
     D  PxUsrPrf                     10a   Const
 
      /Free
 
        Return  VfyUsrAppInf( PxUsrPrf: USR_APP_NAM );
 
      /End-Free
 
     P VfyUsrQryA      E
     **-- Delete user timezone information:
     P DltUsrQryA      B                   Export
     D                 Pi            10i 0
     D  PxUsrPrf                     10a   Const
 
      /Free
 
        Return  DltUsrAppInf( PxUsrPrf: USR_APP_NAM );
 
      /End-Free
 
     P DltUsrQryA      E
     **-- Set user application information:
     P SetUsrAppInf    B                   Export
     D                 Pi            10i 0
     D  PxUsrPrf                     10a   Const
     D  PxAppInfId                  200a   Const  Varying
     D  PxAppInf                   1700a   Const  Varying
 
      /Free
 
        UpdUsrAppInf( PxUsrPrf
                    : PxAppInfId
                    : %Len( PxAppInfId )
                    : PxAppInf
                    : %Len( PxAppInf )
                    : USR_APP_RLS
                    : ERRC0100
                    );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  -1;
        Else;
          Return  *Zero;
        EndIf;
 
      /End-Free
 
     P SetUsrAppInf    E
     **-- Get user application information:
     P GetUsrAppInf    B                   Export
     D                 Pi          1700a   Varying
     D  PxUsrPrf                     10a   Const
     D  PxAppInfId                  200a   Const  Varying
 
     **-- Returned records feedback information:
     D RtnRcdInf       Ds                  Qualified  Inz
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  NbrInfEnt                    10i 0
     **
     D RUAI0100        Ds          1922    Qualified  Based( pRUAI0100 )
     D  EntLen                       10i 0
     D  AppInfId                    200a
     D  AppInfDpl                    10i 0
     D  AppInfLen                    10i 0
     D  AppInfCcsId                  10i 0
     D  FstVldRel                     6a
     **-- Local variables:
     D BytAlc          s             10i 0
 
      /Free
 
        BytAlc = 4096;
        pRUAI0100 = %Alloc( BytAlc );
 
        DoU  RtnRcdInf.BytAvl <= BytAlc;
 
          If  RtnRcdInf.BytAvl > BytAlc;
            BytAlc = RtnRcdInf.BytAvl;
 
            pRUAI0100 = %ReAlloc( pRUAI0100: BytAlc );
          EndIf;
 
          RtvUsrAppInf( RUAI0100
                      : BytAlc
                      : RtnRcdInf
                      : 'RUAI0100'
                      : PxUsrPrf
                      : PxAppInfId
                      : %Len( PxAppInfId )
                      : ERRC0100
                      );
 
          If  ERRC0100.BytAvl > *Zero;
            Leave;
          EndIf;
        EndDo;
 
        If  ERRC0100.BytAvl = *Zero  And  RtnRcdInf.NbrInfEnt = 1;
          Return  %Subst( RUAI0100
                        : RUAI0100.AppInfDpl + 1
                        : RUAI0100.AppInfLen
                        );
        Else;
          Return  NULL;
        EndIf;
 
      /End-Free
 
     P GetUsrAppInf    E
     **-- Verify user application information:
     P VfyUsrAppInf    B                   Export
     D                 Pi              n
     D  PxUsrPrf                     10a   Const
     D  PxAppInfId                  200a   Const  Varying
 
      /Free
 
        If  GetUsrAppInf( PxUsrPrf: PxAppInfId ) = NULL;
          Return  *Off;
        Else;
          Return  *On;
        EndIf;
 
      /End-Free
 
     P VfyUsrAppInf    E
     **-- Delete user application information:
     P DltUsrAppInf    B                   Export
     D                 Pi            10i 0
     D  PxUsrPrf                     10a   Const
     D  PxAppInfId                  200a   Const  Varying
 
      /Free
 
        RmvUsrAppInf( PxUsrPrf: PxAppInfId: %Len( PxAppInfId ): ERRC0100 );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  -1;
        Else;
          Return  *Zero;
        EndIf;
 
      /End-Free
 
     P DltUsrAppInf    E
     **-- Get group profile:
     P GetGrpPrf       B                   Export
     D                 Pi            10a
     D  PxUsrPrf                     10a   Const
 
     **-- User profile information:
     D USRI0200        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  UsrPrf                       10a
     D  UsrCls                       10a
     D  SpcAut                       15a   Overlay( USRI0200: 29 )
     D   AllObj                       1a   Overlay( SpcAut: 1 )
     D   SecAdm                       1a   Overlay( SpcAut: *Next )
     D   JobCtl                       1a   Overlay( SpcAut: *Next )
     D   SplCtl                       1a   Overlay( SpcAut: *Next )
     D   SavSys                       1a   Overlay( SpcAut: *Next )
     D   Service                      1a   Overlay( SpcAut: *Next )
     D   Audit                        1a   Overlay( SpcAut: *Next )
     D   IoSysCfg                     1a   Overlay( SpcAut: *Next )
     D  GrpPrf                       10a
     D  PrfOwn                       10a
     D  GrpAut                       10a
     D  LmtCap                       10a
     D  GrpAutTyp                    10a
     D                                3a
     D  OfsSupGrp                    10i 0
     D  NbrSupGrp                    10i 0
 
      /Free
 
        RtvUsrInf( USRI0200
                 : %Size( USRI0200 )
                 : 'USRI0200'
                 : PxUsrPrf
                 : ERRC0100
                 );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  *Blanks;
 
        Else;
          Return  USRI0200.GrpPrf;
        EndIf;
 
      /End-Free
 
     P GetGrpPrf       E
     **-- Check object existence:
     P ChkObj          B                   Export
     D                 Pi              n
     D  PxObjNam                     10a   Const
     D  PxObjLib                     10a   Const
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
                : PxObjNam + PxObjLib
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
