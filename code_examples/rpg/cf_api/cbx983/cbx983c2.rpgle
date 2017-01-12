     **
     **  Program . . : CBX983C2
     **  Description : Work with User Query Attributes - UIM Cond Program
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod  Module( CBX983C2 )
     **               DbgView( *LIST )
     **
     **    CrtPgm     Pgm( CBX983C2 )
     **               Module( CBX983C2 )
     **               BndSrvPgm( CBX980 )
     **               ActGrp( *CALLER )
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
 
     **-- Global constants:
     D TYP_COND        c                   12
     **-- UIM variables:
     D UIM             Ds                  Qualified
     D  EntHdl                        4a
 
     **-- Product information input structure:
     D PRDI0100        Ds                  Qualified
     D  PrdId                         7a   Inz( '*OPSYS' )
     D  RlsLvl                        6a   Inz( '*CUR' )
     D  PrdOpt                        4a   Inz( '0000' )
     D  LoadId                       10a   Inz( '*CODE' )
     **-- Product information output structure:
     D PRDR0100        Ds                  Qualified
     D  BytPrv                       10i 0
     D  BytRtn                       10i 0
     D                               10i 0
     D  PrdId                         7a
     D  Release                       6a
     D  PrdOpt                        4a
     D  LodId                         4a
     D  LodTyp                       10a
     D  SymLodStt                    10a
     D  LodErrInd                    10a
     D  LodStt                        2a
     D  SupFlg                        1a
     D  RegTyp                        2a
     D  RegVal                       14a
     D                                2a
     D  OfsAddInf                    10i 0
     D  PriLodId                      4a
     D  MinTrgRel                     6a
     D  MinVrmBas                     6a
     D  RqmBasOpt                     1a
     D  Level                         3a
 
     **-- UIM exit program interfaces:
     **-- Parm interface:
     D  PxTypCall                    10i 0
     D  PxAppHdl                      8a
     D  PxObjNam                     10a
     D  PxLibNam                     10a
     D  PxObjTyp                     10a
     D  PxHlpMod                     32a
     D  PxPnlNam                     10a
     D  PxCndNam                     10a
     D  PxRtnCod                      1a
 
     **-- Retrieve product information:
     D RtvPrdInf       Pr                  ExtPgm( 'QSZRTVPR' )
     D  Dta                                Like( PRDR0100 )
     D  DtaLen                       10i 0 Const
     D  FmtNam                        8a   Const
     D  PrdInf                       27a   Const
     D  Error                      1024a         Options( *VarSize )
 
     **-- Entry parameters:
     D CBX983C2        Pr
     D  PxTypCall                    10i 0
     D  PxAppHdl                      8a
     D  PxObjNam                     10a
     D  PxLibNam                     10a
     D  PxObjTyp                     10a
     D  PxHlpMod                     32a
     D  PxPnlNam                     10a
     D  PxCndNam                     10a
     D  PxRtnCod                      1a
     **
     D CBX983C2        Pi
     D  PxTypCall                    10i 0
     D  PxAppHdl                      8a
     D  PxObjNam                     10a
     D  PxLibNam                     10a
     D  PxObjTyp                     10a
     D  PxHlpMod                     32a
     D  PxPnlNam                     10a
     D  PxCndNam                     10a
     D  PxRtnCod                      1a
 
      /Free
 
        PxRtnCod = '0';
 
        If  PxTypCall = TYP_COND;
 
          RtvPrdInf( PRDR0100
                   : %Size( PRDR0100 )
                   : 'PRDR0100'
                   : PRDI0100
                   : ERRC0100
                   );
 
          If  ERRC0100.BytAvl = *Zero;
 
            Select;
            When  PxCndNam = 'V5R3';
 
              If  PRDR0100.Release <= 'V5R3M0';
                PxRtnCod = '1';
              EndIf;
 
            When  PxCndNam = 'V5R4';
 
              If  PRDR0100.Release >= 'V5R4M0';
                PxRtnCod = '1';
              EndIf;
            EndSl;
 
          EndIf;
        EndIf;
 
 
        Return;
 
      /End-Free
