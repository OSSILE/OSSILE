/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( CHGJOBITPS )                                       */
/*           Pgm( CBX9761 )                                          */
/*           SrcMbr( CBX9761X )                                      */
/*           HlpPnlGrp( CBX9761H )                                   */
/*           HlpId( *CMD )                                           */
/*                                                                   */
/*-------------------------------------------------------------------*/
          Cmd      Prompt( 'Change Job Interrupt Status' )
 
 
          Parm     ITPSTS      *Char       1                    +
                   Dft( *CHECK )                                +
                   Rstd( *YES )                                 +
                   Expr( *YES )                                 +
                   SpcVal(( *CHECK  '*' )                       +
                          ( *DLWITP '0' )                        +
                          ( *ALWITP '1' ))                      +
                   Prompt( 'Interrupt status' )
 
