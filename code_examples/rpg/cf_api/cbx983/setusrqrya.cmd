/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( SETUSRQRYA )                                       */
/*           Pgm( CBX983 )                                           */
/*           SrcMbr( CBX983X )                                       */
/*           HlpPnlGrp( CBX983H )                                    */
/*           HlpId( *CMD )                                           */
/*           AlwLmtUsr( *YES )                                       */
/*           PrdLib( <utility library> )                             */
/*           Aut( *USE )                                             */
/*                                                                   */
/*                                                                   */
/*-------------------------------------------------------------------*/
     Cmd        Prompt( 'Set User Query Attributes' )
 
     Parm       GRPPRFOPT       *Char       10          +
                Dft( *NONE )                            +
                Rstd( *YES )                            +
                SpcVal(( *NONE )                        +
                       ( *GRPDFT )                      +
                       ( *GRPONLY ))                    +
                Expr( *YES )                            +
                Prompt( 'Group profile option' )
 
