/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd  Cmd( RMVPNDJOBL )                                      */
/*            Pgm( CBX985 )                                          */
/*            SrcMbr( CBX985X )                                      */
/*            HlpPnlGrp( CBX985H )                                   */
/*            HlpId( *CMD )                                          */
/*            PrdLib( <utility library> )                            */
/*            Aut( *USE )                                            */
/*                                                                   */
/*                                                                   */
/*-------------------------------------------------------------------*/
         Cmd        Prompt( 'Remove Pending Job Log' )
 
         Parm       JOB        Q0001                       +
                    Prompt( 'Job name' 1 )
 
         Parm       LOGOUTPUT     *Char      10            +
                    Rstd( *YES )                           +
                    Dft( *PND )                            +
                    SpcVal(( *ALL ) ( *PND ))              +
                    Expr( *YES )                           +
                    Prompt( 'Job log output' 2 )
 
         Parm       RTNDAYS       *Int2                    +
                    Range( 0 1827 )                        +
                    Dft( *MAX )                            +
                    SpcVal(( *MAX 1827 ))                  +
                    Prompt( 'Pending job log retain days' 3 )
 
 
Q0001:   Qual                     *Generic   10            +
                    Dft( *ALL )                            +
                    SpcVal(( *ALL ))                       +
                    Expr( *YES )
 
         Qual                     *Generic   10            +
                    Dft( *CURRENT )                        +
                    SpcVal(( *CURRENT ) ( *ALL ))          +
                    Expr( *YES )                           +
                    Prompt( 'User' )
 
         Qual                     *Char       6            +
                    Dft( *ALL )                            +
                    Range( '000000' '999999' )             +
                    SpcVal(( *ALL ))                       +
                    Full( *YES )                           +
                    Expr( *YES )                           +
                    Prompt( 'Number' )
 
