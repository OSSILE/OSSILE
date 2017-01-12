/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( ACPSFWAGR )                                        */
/*           Pgm( CBX9842 )                                          */
/*           SrcMbr( CBX9842X )                                      */
/*           HlpPnlGrp( CBX9842H )                                   */
/*           HlpId( *CMD )                                           */
/*           PrdLib( <utility library> )                             */
/*           Aut( *USE )                                             */
/*                                                                   */
/*                                                                   */
/*-------------------------------------------------------------------*/
        Cmd        Prompt( 'Accept Software Agreement' )
 
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
 
