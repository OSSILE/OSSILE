/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( WRKDFTJRN )                                        */
/*           Pgm( CBX974 )                                           */
/*           VldCkr( CBX974V )                                       */
/*           SrcMbr( CBX974X )                                       */
/*           HlpPnlGrp( CBX974H )                                    */
/*           HlpId( *CMD )                                           */
/*                                                                   */
/*-------------------------------------------------------------------*/
          Cmd      Prompt( 'Work with Default Journal' )
 
          Parm     LIB         *Generic   10                    +
                   Dft( *ALL )                                  +
                   Expr( *YES )                                 +
                   SpcVal(( *LIBL    )                          +
                          ( *CURLIB  )                          +
                          ( *USRLIBL )                          +
                          ( *ALLUSR  )                          +
                          ( *ALL     ))                         +
                   Prompt( 'Library' )
 
          Parm     OUTPUT      *Char       3                    +
                   Rstd( *YES )                                 +
                   Dft( * )                                     +
                   SpcVal(( * 'DSP' ) ( *PRINT 'PRT' ))         +
                   Prompt( 'Output' )
 
