/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . : CBX982M                                            */
/*  Description : Work with User Query Attributes - create command   */
/*  Author  . . : Carsten Flensburg                                  */
/*  Published . : System iNetwork Systems Management Tips Newsletter */
/*                                                                   */
/*                                                                   */
/*  Program function:  Compiles, creates and configures all the      */
/*                     Work with User Query Attributes command       */
/*                     objects.                                      */
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
/*                                                                   */
/*  Compile options:                                                 */
/*    CrtClPgm    Pgm( CBX982M )                                     */
/*                SrcFile( QCLSRC )                                  */
/*                SrcMbr( *PGM )                                     */
/*                                                                   */
/*-------------------------------------------------------------------*/
     Pgm    &UtlLib

     Dcl    &UtlLib         *Char     10

     MonMsg      CPF0000    *N        GoTo Error


     CrtRpgMod  &UtlLib/CBX982V SrcFile( &UtlLib/CBX982 ) SrcMbr( *Module ) DbgView( *LIST )

     CrtPgm      &UtlLib/CBX982V                 +
                 Module( &UtlLib/CBX982V )       +
                 BndSrvPgm( CBX980 )             +
                 ActGrp( *NEW )

     CrtRpgMod  &UtlLib/CBX982E SrcFile( &UtlLib/CBX982 ) SrcMbr( *Module ) DbgView( *LIST )

     CrtPgm      &UtlLib/CBX982E                 +
                 Module( &UtlLib/CBX982E )       +
                 BndSrvPgm( CBX980 )             +
                 ActGrp( *CALLER )


     CrtRpgMod  &UtlLib/CBX982 SrcFile( &UtlLib/CBX982 ) SrcMbr( *Module ) DbgView( *LIST )

     CrtPgm      &UtlLib/CBX982                  +
                 Module( &UtlLib/CBX982 )        +
                 BndSrvPgm( CBX980 )             +
                 ActGrp( *NEW )


     CrtPnlGrp  &UtlLib/CBX982P SrcFile( &UtlLib/CBX982 ) SrcMbr( *PNLGRP )

     CrtPnlGrp  &UtlLib/CBX982H SrcFile( &UtlLib/CBX982 ) SrcMbr( *PNLGRP )


     CrtCmd     Cmd( &UtlLib/WRKUSRQRYA ) Pgm( CBX982 ) SrcFile( &UtlLib/CBX982 ) SrcMbr( +
                  CBX982X ) VldCkr( CBX982V ) HlpPnlGrp( CBX982H ) HlpId( *CMD )


     SndPgmMsg   Msg( 'Work with User Query Attributes cmd' *Bcat +
                      'successfully created in library'     *Bcat +
                      &UtlLib                               *Tcat +
                      '.' )                                       +
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
