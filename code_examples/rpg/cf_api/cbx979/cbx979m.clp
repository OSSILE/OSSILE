/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . : CBX979M                                            */
/*  Description : Exit Program for Query Govenor creation            */
/*  Author  . . : Carsten Flensburg                                  */
/*  Published . : System iNetwork Systems Management Tips Newsletter */
/*                                                                   */
/*                                                                   */
/*  Program function:  Compiles, creates and configures all the      */
/*                     User Query Attributes command objects.        */
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
/*    CrtClPgm    Pgm( CBX980M )                                     */
/*                SrcFile( QCLSRC )                                  */
/*                SrcMbr( *PGM )                                     */
/*                                                                   */
/*-------------------------------------------------------------------*/
     Pgm    &UtlLib

     Dcl    &UtlLib         *Char     10

     MonMsg      CPF0000    *N        GoTo Error


     CrtRpgMod  &UtlLib/CBX979 SrcFile( &UtlLib/CBX980 SrcMbr( *Module ) DbgView( *None )

     CrtPgm     Pgm( CBX979 ) Module( CBX979 ) BndSrvPgm( &UtlLib/CBX980 ) AlwUpd( *YES ) +
                  AlwLibUpd( *YES ) ActGrp( *CALLER ) Aut( *USE )

     SndPgmMsg  Msg( 'Exit Program ' *Bcat 'successfully created in library'     *Bcat &UtlLib +
                  *Tcat '.' ) MsgType( *COMP )


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
