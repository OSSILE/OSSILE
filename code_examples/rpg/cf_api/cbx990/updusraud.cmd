/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( UPDUSRAUD )                                        */
/*           Pgm( CBX990 )                                           */
/*           SrcMbr( CBX990X )                                       */
/*           HlpPnlGrp( CBX990H )                                    */
/*           HlpId( *CMD )                                           */
/*           PmtOvrPgm( CBX990O )                                    */
/*                                                                   */
/*-------------------------------------------------------------------*/
          Cmd      Prompt( 'Update User Auditing' )
 
          Parm     USRPRF         *Sname       10          +
                   Min( 1 )                                +
                   Expr( *YES )                            +
                   Keyparm( *YES )                         +
                   Vary( *YES *INT2 )                      +
                   Prompt( 'User profile' )
 
          Parm     OBJAUD         *Char        10          +
                   Rstd( *YES )                            +
                   Dft( *SAME )                            +
                   SpcVal(( *SAME   )                      +
                          ( *NONE   )                      +
                          ( *CHANGE )                      +
                          ( *ALL    ))                     +
                   Expr( *YES )                            +
                   Vary( *YES *INT2 )                      +
                   Prompt( 'Object auditing value' )
 
          Parm     AUDLVL         *Char        10          +
                   Rstd( *YES )                            +
                   Dft( *SAME )                            +
                   SpcVal(( *CMD      )                    +
                          ( *CREATE   )                    +
                          ( *DELETE   )                    +
                          ( *JOBDTA   )                    +
                          ( *OBJMGT   )                    +
                          ( *OFCSRV   )                    +
                          ( *OPTICAL  )                    +
                          ( *PGMADP   )                    +
                          ( *PGMFAIL  )                    +
                          ( *SAVRST   )                    +
                          ( *SECURITY )                    +
                          ( *SERVICE  )                    +
                          ( *SPLFDTA  )                    +
                          ( *SYSMGT   ))                   +
                   SngVal(( *SAME ) ( *NONE ))             +
                   Max( 13 )                               +
                   Expr( *YES )                            +
                   Vary( *YES *INT2 )                      +
                   Prompt( 'User action auditing' )
 
