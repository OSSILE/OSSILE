/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( ALCLICSPC )                                        */
/*           Pgm( CBX9843 )                                          */
/*           SrcMbr( CBX9843X )                                      */
/*           HlpPnlGrp( CBX9843H )                                   */
/*           HlpId( *CMD )                                           */
/*           PrdLib( <utility library> )                             */
/*           Aut( *USE )                                             */
/*                                                                   */
/*                                                                   */
/*-------------------------------------------------------------------*/
        Cmd        Prompt( 'Allocate LIC Space' )
 
        Parm       RLS         *Char     6                 +
                   Min( 1 )                                +
                   SpcVal(( 'VxRxMx' ) ( *NONE ))          +
                   Full( *YES )                            +
                   Expr( *YES )                            +
                   Prompt( 'Allocate space for release' )
 
        Parm       START       *Char     1                 +
                   Min( 1 )                                +
                   Rstd( *YES )                            +
                   SpcVal(( *NEXTIPL '0' ) ( *IMMED '1' )) +
                   Expr( *YES )                            +
                   Prompt( 'Start space allocation' )
 
