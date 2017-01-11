/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( WRKQRYPRFO )                                       */
/*           Pgm( CBX994 )                                           */
/*           VldCkr( CBX994V )                                       */
/*           SrcMbr( CBX994X )                                       */
/*           HlpPnlGrp( CBX994H )                                    */
/*           HlpId( *CMD )                                           */
/*                                                                   */
/*-------------------------------------------------------------------*/
          Cmd      Prompt( 'Work with Query Profile Opts' )
 
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
 
