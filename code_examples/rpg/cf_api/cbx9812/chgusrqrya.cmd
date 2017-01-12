/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( CHGUSRQRYA )                                       */
/*           Pgm( CBX9812 )                                          */
/*           SrcMbr( CBX9812X )                                      */
/*           VldCkr( CBX9812V )                                      */
/*           HlpPnlGrp( CBX9812H )                                   */
/*           HlpId( *CMD )                                           */
/*           PmtOvrPgm( CBX9812O )                                   */
/*           PrdLib( <utility library> )                             */
/*                                                                   */
/*-------------------------------------------------------------------*/
             Cmd        Prompt( 'Change User Query Attributes' )
 
             Parm       USRPRF           *Sname      10         +
                        Min( 1 )                                +
                        Expr( *YES )                            +
                        Keyparm( *YES )                         +
                        Prompt( 'User profile' )
 
             Parm       QRYINTTIML       *Int4                  +
                        Dft( *QRYTIMLMT )                       +
                        Range( 0  2147352578 )                  +
                        SpcVal(( *NOMAX     -1 )                +
                               ( *SAME      -2 )                +
                               ( *QRYTIMLMT -3 ))               +
                        Expr( *YES )                            +
                        Choice( '0-2147352578 secs, *NOMAX...' ) +
                        Prompt( 'Query interactive time limit' )
 
             Parm       QRYINTALW        *Char                  +
                        Rstd( *YES )                            +
                        Dft( *NO )                              +
                        SpcVal(( *NO   ) ( *YES ))              +
                        Expr( *YES )                            +
                        Prompt( 'Force interactive query' )
 
             Parm       QRYOPTLIB        *Name       10         +
                        Dft( *SAME )                            +
                        SpcVal( *SAME )                         +
                        Prompt( 'Query options file library' )
 
