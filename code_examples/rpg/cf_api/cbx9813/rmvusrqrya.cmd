/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( RMVUSRQRYA )                                       */
/*           Pgm( CBX9813 )                                          */
/*           SrcMbr( CBX9813X )                                      */
/*           VldCkr( CBX9813V )                                      */
/*           HlpPnlGrp( CBX9813H )                                   */
/*           HlpId( *CMD )                                           */
/*           PrdLib( <utility library> )                             */
/*                                                                   */
/*-------------------------------------------------------------------*/
     Cmd        Prompt( 'Remove User Query Attributes' )
 
     Parm       USRPRF          *SNAME      10        +
                Min( 1 )                              +
                Expr( *YES )                          +
                Prompt( 'User profile' )
 
