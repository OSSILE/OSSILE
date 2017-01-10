/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( WRKRMTOUTQ )                                       */
/*           Pgm( CBX999 )                                           */
/*           VldCkr( CBX999V )                                       */
/*           SrcMbr( CBX999X )                                       */
/*           HlpPnlGrp( CBX999H )                                    */
/*           HlpId( *CMD )                                           */
/*                                                                   */
/*-------------------------------------------------------------------*/
          Cmd      Prompt( 'Work with Remote Output Queues' )
 
          Parm     RMTOUTQ     Q0001                            +
                   Prompt( 'Remote output queue' )
 
          Parm     OUTPUT      *Char       3                    +
                   Rstd( *YES )                                 +
                   Dft( * )                                     +
                   SpcVal(( * 'DSP' ) ( *PRINT 'PRT' ))         +
                   Prompt( 'Output' )
 
Q0001:    Qual                 *Generic   10                    +
                   Dft( *ALL )                                  +
                   SpcVal(( *ALL ))                             +
                   Expr( *YES )
 
          Qual                 *Name      10                    +
                   Dft( *ALL )                                  +
                   SpcVal(( *ALL     )                          +
                          ( *ALLUSR  )                          +
                          ( *USRLIBL )                          +
                          ( *CURLIB  )                          +
                          ( *LIBL    ))                         +
                   Expr( *YES )                                 +
                   Prompt( 'Library' )
 
