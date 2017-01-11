/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd   Cmd( RMVUSRAUD )                                      */
/*             Pgm( CBX9912 )                                        */
/*             SrcMbr( CBX9912X )                                    */
/*             VldCkr( CBX9912V )                                    */
/*             AlwLmtUsr( *NO )                                      */
/*             HlpPnlGrp( CBX9912H )                                 */
/*             HlpId( *CMD )                                         */
/*             Aut( *EXCLUDE )                                       */
/*                                                                   */
/*                                                                   */
/*-------------------------------------------------------------------*/
          Cmd      Prompt( 'Remove User Auditing' )
 
          Parm     USRPRF      *Generic    10                   +
                   Dft( *ALL )                                  +
                   Expr( *YES )                                 +
                   SpcVal(( *ALL ))                             +
                   Prompt( 'User profile' )
 
          Parm     USRCLS      *Char       10                   +
                   Rstd( *YES )                                 +
                   Dft( *ANY )                                  +
                   SpcVal(( *ANY    )                           +
                          ( *USER   )                           +
                          ( *SYSOPR )                           +
                          ( *PGMR   )                           +
                          ( *SECADM )                           +
                          ( *SECOFR ))                          +
                   Prompt( 'User class' )
 
          Parm     OBJAUD         *Char        10          +
                   Rstd( *YES )                            +
                   Dft( *SAME )                            +
                   SpcVal(( *SAME   )                      +
                          ( *ANY    )                      +
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
                          ( *SAVRST   )                    +
                          ( *SECURITY )                    +
                          ( *SERVICE  )                    +
                          ( *SPLFDTA  )                    +
                          ( *SYSMGT   ))                   +
                   SngVal(( *SAME ) ( *ALL ))              +
                   Max( 13 )                               +
                   Expr( *YES )                            +
                   Vary( *YES *INT2 )                      +
                   Prompt( 'User action auditing' )
 
