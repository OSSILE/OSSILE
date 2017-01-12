/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . : CBX978T                                            */
/*  Description : Retrieve command information - Test                */
/*                                                                   */
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtClPgm   Pgm( CBX978T )                                      */
/*               SrcFile( QCLSRC )                                   */
/*               SrcMbr( *PGM )                                      */
/*                                                                   */
/*-------------------------------------------------------------------*/
     Pgm
 
/*-- Program variables & constants:  --------------------------------*/
     Dcl        &RtnLib       *Char    10
     Dcl        &Pgm          *Char    10
     Dcl        &PgmLib       *Char    10
     Dcl        &SrcFil       *Char    10
     Dcl        &SrcLib       *Char    10
     Dcl        &SrcMbr       *Char    10
     Dcl        &VldCkr       *Char    10
     Dcl        &VldCkrLib    *Char    10
     Dcl        &Mode         *Char   100
     Dcl        &Allow        *Char   150
     Dcl        &AlwLmtUsr    *Char     1
     Dcl        &MaxPos       *Dec     10
     Dcl        &PmtFile      *Char    10
     Dcl        &PmtFileLib   *Char    10
     Dcl        &MsgF         *Char    10
     Dcl        &MsgFlib      *Char    10
     Dcl        &HlpPnlGrp    *Char    10
     Dcl        &HlpPnlGrpL   *Char    10
     Dcl        &HlpId        *Char    10
     Dcl        &HlpSchIdx    *Char    10
     Dcl        &HlpSchIdxL   *Char    10
     Dcl        &CurLib       *Char    10
     Dcl        &PrdLib       *Char    10
     Dcl        &PmtOvrPgm    *Char    10
     Dcl        &PmtOvrPgmL   *Char    10
     Dcl        &TgtRls       *Char     6
     Dcl        &Text         *Char    50
     Dcl        &CppState     *Char     2
     Dcl        &VcpState     *Char     2
     Dcl        &PopState     *Char     2
     Dcl        &CcsId        *Dec      5
     Dcl        &EnbGui       *Char     1
     Dcl        &ThdSafe      *Char     1
     Dcl        &MltThdAcn    *Char     1
     Dcl        &PxyInd       *Char     1
 
     Dcl        &EoF          *Int      4
     Dcl        &RtnVal       *Int      4
 
     Dcl        &YES          *Char     1      '1'
     Dcl        &OFF          *Int      4      0
 
 
/*-- File declaration:  ---------------------------------------------*/
     DclF       File( QADSPOBJ )   OpnId( CMDFIL )
 
/*-- Global error monitoring:  --------------------------------------*/
     MonMsg     CPF0000      *N    GoTo Error
 
/*-- Main:  ---------------------------------------------------------*/
 
     DltF       File( QTEMP/QADSPOBJ )
     MonMsg     CPF2105
     RcvMsg     MsgType( *LAST )   Rmv( *YES )
 
     DspObjD    Obj( QSYS/*ALL )            +
                ObjType( *CMD )             +
                OutPut( *OUTFILE )          +
                OutFile( QTEMP/QADSPOBJ )
     RcvMsg     MsgType( *LAST )   Rmv( *YES )
     RcvMsg     MsgType( *LAST )   Rmv( *YES )
 
     OvrDbf     File( QADSPOBJ )   ToFile( QTEMP/QADSPOBJ )
 
     CallSubr   Subr( ReadFile )   RtnVal( &EoF )
     DoWhile  ( &EoF = &OFF )
 
     CallSubr   Subr( GetCmdInf )  Rtnval( &RtnVal )
 
     If       ( &RtnVal = 0 )      Do
     CallSubr   Subr( PrcCmdInf )
     EndDo
 
     CallSubr   Subr( ReadFile )   RtnVal( &EoF )
     EndDo
 
     DltF       File( QTEMP/QADSPOBJ )
     RcvMsg     MsgType( *LAST )   Rmv( *YES )
 
     DltOvr     File( QADSPOBJ )
 
 Return:
     Return
 
/*-- Error handling:  -----------------------------------------------*/
 Error:
     Call      QMHMOVPM    ( '    '                             +
                             '*DIAG'                            +
                             x'00000001'                        +
                             '*PGMBDY   '                       +
                             x'00000001'                        +
                             x'0000000800000000'                +
                           )
 
     Call      QMHRSNEM    ( '    '                             +
                             x'0000000800000000'                +
                           )
 
/*-- Subroutines:  --------------------------------------------------*/
 
     Subr       Subr( PrcCmdInf )
 
     DMPCLPGM
 
     If       ( &AlwLmtUsr = &YES )    Do
 
     SndPgmMsg  Msg('Command'                            *Bcat  +
                     &CMDFIL_ODOBNM                      *Bcat  +
                    'in library'                         *Bcat  +
                     &CMDFIL_ODLBNM                      *Bcat  +
                    'can be run by limited user profiles.')     +
                ToPgmQ( *PRV (*))                               +
                MsgType( *INFO )
     EndDo
 
     EndSubr
 
 
     Subr       Subr( ReadFile )
 
     RcvF       OpnId( CMDFIL )
     MonMsg     CPF0864     *N     Do
     RcvMsg     MsgType( *EXCP )   Rmv( *YES )
 
     RtnSubr    RtnVal( 1 )
     EndDo
 
     EndSubr    RtnVal( 0 )
 
 
     Subr       Subr( GetCmdInf )
 
     RtvCmdInf  Cmd( &CMDFIL_ODLBNM/&CMDFIL_ODOBNM )  +
                RtnLib( &RtnLib )                     +
                Pgm( &Pgm )                           +
                PgmLib( &PgmLib )                     +
                SrcFil( &SrcFil )                     +
                SrcLib( &SrcLib )                     +
                SrcMbr( &SrcMbr )                     +
                VldCkr( &VldCkr )                     +
                VldCkrLib( &VldCkrLib )               +
                Mode( &Mode )                         +
                Allow( &Allow )                       +
                AlwLmtusr( &AlwLmtusr )               +
                MaxPos( &MaxPos )                     +
                PmtFile( &PmtFile )                   +
                PmtFileLib( &PmtFileLib )             +
                MsgF( &MsgF )                         +
                MsgFlib( &MsgFlib )                   +
                HlpPnlGrp( &HlpPnlGrp )               +
                HlpPnlGrpL( &HlpPnlGrpL )             +
                HlpId( &HlpId )                       +
                HlpSchIdx( &HlpSchIdx )               +
                HlpSchIdxL( &HlpSchIdxL )             +
                CurLib( &CurLib )                     +
                PrdLib( &PrdLib )                     +
                PmtOvrPgm( &PmtOvrPgm )               +
                PmtOvrPgmL( &PmtOvrPgmL )             +
                TgtRls( &TgtRls )                     +
                Text( &Text )                         +
                CppState( &CppState )                 +
                VcpState( &VcpState )                 +
                PopState( &PopState )                 +
                CcsId( &CcsId )                       +
                EnbGui( &EnbGui )                     +
                ThdSafe( &ThdSafe )                   +
                MltThdAcn( &MltThdAcn )               +
                PxyInd( &PxyInd )
     MonMsg     CPF6250     *N     Do
     RcvMsg     MsgType( *EXCP )   Rmv( *YES )
 
     RtnSubr    RtnVal( -1 )
     EndDo
 
     DoWhile ( &PxyInd = &YES )
 
     RtvCmdInf  Cmd( &PgmLib/&Pgm )              +
                RtnLib( &RtnLib )                +
                Pgm( &Pgm )                      +
                PgmLib( &PgmLib )                +
                SrcFil( &SrcFil )                +
                SrcLib( &SrcLib )                +
                SrcMbr( &SrcMbr )                +
                VldCkr( &VldCkr )                +
                VldCkrLib( &VldCkrLib )          +
                Mode( &Mode )                    +
                Allow( &Allow )                  +
                AlwLmtusr( &AlwLmtusr )          +
                MaxPos( &MaxPos )                +
                PmtFile( &PmtFile )              +
                PmtFileLib( &PmtFileLib )        +
                MsgF( &MsgF )                    +
                MsgFlib( &MsgFlib )              +
                HlpPnlGrp( &HlpPnlGrp )          +
                HlpPnlGrpL( &HlpPnlGrpL )        +
                HlpId( &HlpId )                  +
                HlpSchIdx( &HlpSchIdx )          +
                HlpSchIdxL( &HlpSchIdxL )        +
                CurLib( &CurLib )                +
                PrdLib( &PrdLib )                +
                PmtOvrPgm( &PmtOvrPgm )          +
                PmtOvrPgmL( &PmtOvrPgmL )        +
                TgtRls( &TgtRls )                +
                Text( &Text )                    +
                CppState( &CppState )            +
                VcpState( &VcpState )            +
                PopState( &PopState )            +
                CcsId( &CcsId )                  +
                EnbGui( &EnbGui )                +
                ThdSafe( &ThdSafe )              +
                MltThdAcn( &MltThdAcn )          +
                PxyInd( &PxyInd )
 
     EndDo
 
     EndSubr    RtnVal( 0 )
 
 EndPgm:
     EndPgm
