/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( ENDSVRSSN )                                        */
/*           Pgm( CBX987 )                                           */
/*           VldCkr( CBX987V )                                       */
/*           SrcMbr( CBX987X )                                       */
/*           HlpPnlGrp( CBX987H )                                    */
/*           HlpId( *CMD )                                           */
/*                                                                   */
/*-------------------------------------------------------------------*/
          Cmd      Prompt( 'End Server Session' )
 
          Parm     WRKSTN      *Char      15                    +
                   Min( 1 )                                     +
                   SpcVal(( *SESSID ))                          +
                   Expr( *YES )                                 +
                   Prompt( 'Workstation' )
 
          Parm     SSNID       *Char      20                    +
                   Dft( *ALL )                                  +
                   Range( '1' '9223372036854775807' )           +
                   SpcVal(( *ALL '0' ))                         +
                   Expr( *YES )                                 +
                   PmtCtl( P0001 )                              +
                   Prompt( 'Session identifier' )
 
 P0001:   PmtCtl   Ctl( WRKSTN )                                +
                   Cond(( *EQ '*SESSID' ))
 
          Dep      Ctl( &WRKSTN *NE '*SESSID' )                 +
                   Parm(( SSNID ))                              +
                   NbrTrue( *EQ  0 )
 
          Dep      Ctl( &WRKSTN *EQ '*SESSID' )                 +
                   Parm(( SSNID ))
 
