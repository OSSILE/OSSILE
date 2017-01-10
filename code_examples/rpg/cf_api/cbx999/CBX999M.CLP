/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . : CBX999M                                            */
/*  Description : Work with Remote Output Queues - Create command    */
/*  Author  . . : Carsten Flensburg                                  */
/*  Published . : System iNetwork Systems Management Tips Newsletter */
/*                                                                   */
/*                                                                   */
/*  Program function:  Compiles, creates and configures all the      */
/*                     Work with Remote Output Queues (WRKRMTOUTQ)   */
/*                     command objects.                              */
/*                                                                   */
/*                     This program expects a single parameter       */
/*                     specifying the library to contain the         */
/*                     command objects.                              */
/*                                                                   */
/*                     Object sources must exist in the respective   */
/*                     source type default source files in the       */
/*                     command object library.                       */
/*                                                                   */
/*                                                                   */
/*  Compile options:                                                 */
/*    CrtClPgm    Pgm( CBX999M )                                     */
/*                SrcFile( QCLSRC )                                  */
/*                SrcMbr( *PGM )                                     */
/*                                                                   */
/*-------------------------------------------------------------------*/
     Pgm    &UtlLib
 
     Dcl    &UtlLib         *Char     10
 
     MonMsg      CPF0000    *N        GoTo Error
 
 
     CrtRpgMod   &UtlLib/CBX999E                 +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )
 
     CrtPgm      &UtlLib/CBX999E                 +
                 Module( &UtlLib/CBX999E )       +
                 ActGrp( *CALLER )
 
 
     CrtRpgMod   &UtlLib/CBX999V                 +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )
 
     CrtPgm      &UtlLib/CBX999V                 +
                 Module( &UtlLib/CBX999V )       +
                 ActGrp( *NEW )
 
 
     CrtRpgMod   &UtlLib/CBX999                  +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *LIST )
 
     CrtPgm      &UtlLib/CBX999                  +
                 Module( &UtlLib/CBX999 )        +
                 ActGrp( *NEW )
 
 
     CrtPnlGrp   &UtlLib/CBX999H                 +
                 SrcFile( &UtlLib/QPNLSRC )      +
                 SrcMbr( *PNLGRP )
 
     CrtPnlGrp   &UtlLib/CBX999P                 +
                 SrcFile( &UtlLib/QPNLSRC )      +
                 SrcMbr( *PNLGRP )
 
 
     CrtCmd      Cmd( &UtlLib/WRKRMTOUTQ )                      +
                 Pgm( CBX999 )                                  +
                 SrcFile( &UtlLib/QCMDSRC )                     +
                 SrcMbr( CBX999X )                              +
                 VldCkr( CBX999V )                              +
                 AlwLmtUsr( *NO )                               +
                 HlpPnlGrp( CBX999H )                           +
                 HlpId( *CMD )                                  +
                 PrdLib( &UtlLib )                              +
                 Aut( *EXCLUDE )
 
 
     SndPgmMsg   Msg( 'Work with Remote Output Queues command' *Bcat +
                      'successfully created in library'        *Bcat +
                      &UtlLib                                  *Tcat +
                      '.' )                                          +
                 MsgType( *COMP )
 
     Call        QMHMOVPM    ( '    '                 +
                               '*COMP'                +
                               x'00000001'            +
                               '*PGMBDY'              +
                               x'00000001'            +
                               x'0000000800000000'    +
                             )
 
     RmvMsg      Clear( *ALL )
 
     Return
 
/*-- Error handling:  -----------------------------------------------*/
 Error:
     Call        QMHMOVPM    ( '    '                 +
                               '*DIAG'                +
                               x'00000001'            +
                               '*PGMBDY'              +
                               x'00000001'            +
                               x'0000000800000000'    +
                             )
 
     Call        QMHRSNEM    ( '    '                 +
                               x'0000000800000000'    +
                             )
 
 EndPgm:
     EndPgm
