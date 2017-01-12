/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . : CBX974M                                            */
/*  Description : Work with Default Journal - Create command         */
/*  Author  . . : Carsten Flensburg                                  */
/*  Published . : System iNetwork Systems Management Tips Newsletter */
/*                                                                   */
/*                                                                   */
/*  Program function:  Compiles, creates and configures all the      */
/*                     Work with Default Journal command objects.    */
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
/*    CrtClPgm    Pgm( CBX974M )                                     */
/*                SrcFile( QCLSRC )                                  */
/*                SrcMbr( *PGM )                                     */
/*                                                                   */
/*-------------------------------------------------------------------*/
     Pgm    &UtlLib

     Dcl    &UtlLib         *Char     10

     MonMsg      CPF0000    *N        GoTo Error


     CrtMsgF     MsgF( &UtlLib/CBX974M )  Aut( *USE )

     AddMsgD    CBX0001 MsgF( &UtlLib/CBX974M ) Msg( 'No data areas match specified criteria') +
                  SecLvl( *NONE )


     AddMsgD    CBX0101 MsgF( &UtlLib/CBX974M ) Msg( 'Journal options' ) SecLvl( *NONE )


     CrtRpgMod  &UtlLib/CBX974 SrcFile( OSSILESRC/CBX974 ) SrcMbr( *Module ) DbgView( *LIST )

     CrtPgm     &UtlLib/CBX974 Module( &UtlLib/CBX974 ) ActGrp( *NEW )


     CrtRpgMod  &UtlLib/CBX974E SrcFile( OSSILESRC/CBX974 ) SrcMbr( *Module ) DbgView( *LIST )

     CrtPgm     &UtlLib/CBX974E Module( &UtlLib/CBX974E &UtlLib/CBX974  ) ActGrp( *CALLER )


     CrtRpgMod  &UtlLib/CBX974V SrcFile( OSSILESRC/CBX974 ) SrcMbr( *Module ) DbgView( *LIST )

     CrtPgm     &UtlLib/CBX974V Module( &UtlLib/CBX974V ) ActGrp( *CALLER )


     CrtPnlGrp  &UtlLib/CBX974H SrcFile( OSSILESRC/CBX974 ) SrcMbr( *PNLGRP )

     CrtPnlGrp  &UtlLib/CBX974P SrcFile( OSSILESRC/CBX974 ) SrcMbr( *PNLGRP )


     CrtCmd     Cmd( &UtlLib/WRKDFTJRN ) Pgm( CBX974 ) SrcFile( OSSILESRC/CBX974 ) SrcMbr( +
                  CBX974X ) VldCkr( CBX974V ) HlpPnlGrp( CBX974H ) HlpId( *CMD ) PrdLib( +
                  &UtlLib )


     SndPgmMsg  Msg( 'Work with Default Journal command' *Bcat 'successfully created in +
                  library' *Bcat &UtlLib *Tcat '.' ) MsgType( *COMP )


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
