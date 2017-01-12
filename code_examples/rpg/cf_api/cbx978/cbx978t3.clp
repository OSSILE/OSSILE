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
     Dcl        &EoF          *Int      4
     Dcl        &RtnVal       *Int      4
     Dcl        &OFF          *Int      4      0
 
 
/*-- File declaration:  ---------------------------------------------*/
     DclF       File( QADSPOBJ )   OpnId( BNDFIL )
 
/*-- Global error monitoring:  --------------------------------------*/
     MonMsg     CPF0000      *N    GoTo Error
 
/*-- Main:  ---------------------------------------------------------*/
 
     DltF       File( CLIB/ALLBNDDIRE )
     MonMsg     CPF2105
     RcvMsg     MsgType( *LAST )   Rmv( *YES )
 
     DltF       File( QTEMP/QADSPOBJ )
     MonMsg     CPF2105
     RcvMsg     MsgType( *LAST )   Rmv( *YES )
 
     DspObjD    Obj( *ALL/*ALL )            +
                ObjType( *BNDDIR )          +
                OutPut( *OUTFILE )          +
                OutFile( QTEMP/QADSPOBJ )
     RcvMsg     MsgType( *LAST )   Rmv( *YES )
     RcvMsg     MsgType( *LAST )   Rmv( *YES )
 
     OvrDbf     File( QADSPOBJ )   ToFile( QTEMP/QADSPOBJ )
 
     CallSubr   Subr( ReadFile )   RtnVal( &EoF )
     DoWhile  ( &EoF = &OFF )
 
     CallSubr   Subr( LodBndDir )  Rtnval( &RtnVal )
 
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
 
     Subr       Subr( LodBndDir )
 
     DspBndDir  BndDir( &BNDFIL_ODLBNM/&BNDFIL_ODOBNM )         +
                OutPut( *OUTFILE )                              +
                OutFile( CLIB/ALLBNDDIRE )                      +
                OutMbr( *FIRST *ADD )
 
     EndSubr
 
 
     Subr       Subr( ReadFile )
 
     RcvF       OpnId( BNDFIL )
     MonMsg     CPF0864     *N     Do
     RcvMsg     MsgType( *EXCP )   Rmv( *YES )
 
     RtnSubr    RtnVal( 1 )
     EndDo
 
     EndSubr    RtnVal( 0 )
 
 
 EndPgm:
     EndPgm
