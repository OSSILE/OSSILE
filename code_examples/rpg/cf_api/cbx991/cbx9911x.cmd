/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd   Cmd( ADDUSRAUD )                                      */
/*             Pgm( CBX9911 )                                        */
/*             SrcMbr( CBX9911X )                                    */
/*             VldCkr( CBX9911V )                                    */
/*             AlwLmtUsr( *NO )                                      */
/*             MsgF( CBX991M )                                       */
/*             HlpPnlGrp( CBX9911H )                                 */
/*             HlpId( *CMD )                                         */
/*             Aut( *EXCLUDE )                                       */
/*                                                                   */
/*                                                                   */
/*-------------------------------------------------------------------*/
          Cmd      Prompt( 'Add User Auditing' )
 
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
 
          Parm     REPLACE     *Char       10                   +
                   Rstd( *YES )                                 +
                   Dft( *NO )                                   +
                   SpcVal(( *YES ) ( *NO ))                     +
                   Prompt( 'Replace user action auditing' )
 
 
          Dep      Ctl( &AUDLVL *EQ '*NONE' )                   +
                   Parm(( &REPLACE *EQ '*NO' ))                 +
                   NbrTrue( *EQ 0 )                             +
                   MsgId( CBX0101 )
 
