/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd   Cmd( SBMJOBDJOB )                                     */
/*             Pgm( CBX9963 )                                        */
/*             SrcMbr( CBX9963X )                                    */
/*             VldCkr( CBX9963V )                                    */
/*             AlwLmtUsr( *NO )                                      */
/*             HlpPnlGrp( CBX9963H )                                 */
/*             HlpId( *CMD )                                         */
/*                                                                   */
/*-------------------------------------------------------------------*/
          Cmd      Prompt( 'Submit Job Description Job' )
 
          Parm     JOB         *Name       10                   +
                   Min( 1 )                                     +
                   Expr( *YES )                                 +
                   Prompt( 'Job name' )
 
          Parm     JOBD        Q0001                            +
                   Choice( *NONE )                              +
                   Prompt( 'Job description' )
 
          Parm     OPTION      *Char       10                   +
                   Rstd( *YES )                                 +
                   Dft( *USRPRF )                               +
                   SpcVal(( *USRPRF ) ( *SYSVAL ))              +
                   Prompt( 'Parameter option' )
 
 
 Q0001:   Qual                 *Name       10                   +
                   Dft( *JOB )                                  +
                   SpcVal(( *JOB ))                             +
                   Expr( *YES )
 
          Qual                 *Name       10                   +
                   Dft( *LIBL )                                 +
                   SpcVal(( *LIBL    )                          +
                          ( *CURLIB  ))                         +
                   Expr( *YES )                                 +
                   Prompt( 'Library' )
 
