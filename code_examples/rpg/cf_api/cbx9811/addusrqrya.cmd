/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( ADDUSRQRYA )                                       */
/*           Pgm( CBX9811 )                                          */
/*           SrcMbr( CBX9811X )                                      */
/*           VldCkr( CBX9811V )                                      */
/*           HlpPnlGrp( CBX9811H )                                   */
/*           HlpId( *CMD )                                           */
/*           PrdLib( <utility library> )                             */
/*                                                                   */
/*-------------------------------------------------------------------*/
             Cmd        Prompt( 'Add User Query Attributes' )
 
             Parm       USRPRF           *Sname      10         +
                        Min( 1 )                                +
                        Expr( *YES )                            +
                        Prompt( 'User profile' )
 
             Parm       QRYINTTIML       *Int4                  +
                        Dft( *QRYTIMLMT )                       +
                        Range( 0  2147352578 )                  +
                        SpcVal(( *NOMAX     -1 )                +
                               ( *QRYTIMLMT -3 ))               +
                        Expr( *YES )                            +
                        Choice( '0-2147352578 secs, *NOMAX...' ) +
                        Prompt( 'Query interactive time limit' )
 
             Parm       QRYOPTLIB        *Name       10         +
                        Dft( *SAME )                            +
                        SpcVal( *SAME )                         +
                        Prompt( 'Query options file library' )
 
