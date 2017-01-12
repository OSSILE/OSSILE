/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( CHKSFWAGR )                                        */
/*           Pgm( CBX9841 )                                          */
/*           SrcMbr( CBX9841X )                                      */
/*           HlpPnlGrp( CBX9841H )                                   */
/*           HlpId( *CMD )                                           */
/*           PrdLib( <utility library> )                             */
/*           Aut( *USE )                                             */
/*                                                                   */
/*                                                                   */
/*-------------------------------------------------------------------*/
        Cmd        Prompt( 'Check Software Agreement' )
 
        Parm       PRDID       *Char     7                 +
                   Min( 1 )                                +
                   Full( *YES )                            +
                   Expr( *YES )                            +
                   Prompt( 'Product identifier' )
 
        Parm       RLS         *Char     6                 +
                   Min( 1 )                                +
                   SpcVal(( 'VxRxMx' ))                    +
                   Full( *YES )                            +
                   Expr( *YES )                            +
                   Prompt( 'Release' )
 
        Parm       OPTION      *Int2                       +
                   Min( 1 )                                +
                   SpcVal(( *BASE 0000 ))                  +
                   Range( 0000  0099 )                     +
                   Expr( *YES )                            +
                   Prompt( 'Product option' )
 
