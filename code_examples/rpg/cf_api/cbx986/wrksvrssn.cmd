/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( WRKSVRSSN )                                        */
/*           Pgm( CBX986 )                                           */
/*           VldCkr( CBX986V )                                       */
/*           SrcMbr( CBX986X )                                       */
/*           HlpPnlGrp( CBX986H )                                    */
/*           HlpId( *CMD )                                           */
/*                                                                   */
/*-------------------------------------------------------------------*/
          Cmd      Prompt( 'Work with Server Sessions' )
 
          Parm     WRKSTN      *Char      15                    +
                   Dft( *ALL )                                  +
                   Expr( *YES )                                 +
                   SpcVal(( *ALL ))                             +
                   Prompt( 'Workstation' )
 
          Parm     USRPRF      *Sname     10                    +
                   Dft( *ALL )                                  +
                   SpcVal(( *ALL ))                             +
                   Expr( *YES )                                 +
                   Prompt( 'User profile' )
 
          Parm     OUTPUT      *Char       3                    +
                   Rstd( *YES )                                 +
                   Dft( * )                                     +
                   SpcVal(( * 'DSP' ) ( *PRINT 'PRT' ))         +
                   Prompt( 'Output' )
 
