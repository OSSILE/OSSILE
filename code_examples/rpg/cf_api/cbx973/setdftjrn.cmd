/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd     Cmd( SETDFTJRN )                                    */
/*               Pgm( CBX973 )                                       */
/*               SrcMbr( CBX973X )                                   */
/*               VldCkr( CBX973V )                                   */
/*               HlpPnlGrp( CBX973H )                                */
/*               HlpId( *CMD )                                       */
/*               PmtOvrPgm( CBX973O )                                */
/*                                                                   */
/*                                                                   */
/*-------------------------------------------------------------------*/
        Cmd      Prompt( 'Set Default Journal' )
 
        Parm     LIB         *Name       10                +
                 Min( 1 )                                  +
                 Expr( *YES )                              +
                 Keyparm( *YES )                           +
                 Prompt( 'Library' )
 
        Parm     JRN         Q0001                         +
                 Min( 1 )                                  +
                 Choice( *NONE )                           +
                 Prompt( 'Journal' )
 
        Parm     OPTION      E0001                         +
                 Dft( *NONE )                              +
                 SngVal(( *NONE ))                         +
                 Max( 5 )                                  +
                 Prompt( 'Journal option' )
 
        Parm     CREATE      *Char        4                   +
                 Dft( *NO )                                   +
                 Rstd( *YES )                                 +
                 SpcVal(( *NO  )                              +
                        ( *YES ))                             +
                 Expr( *YES )                                 +
                 Prompt( 'Create data area' )
 
 Q0001:   Qual               *Name       10                +
                 Min( 1 )                                  +
                 Expr( *YES )
 
          Qual               *Name       10                +
                 Min( 1 )                                  +
                 Expr( *YES )                              +
                 Prompt( 'Library' )
 
 
E0001:    Elem               *Char       10               +
                 Rstd( *YES )                             +
                 SpcVal(( *ALL    )                       +
                        ( *FILE   )                       +
                        ( *DTAARA )                       +
                        ( *DTAQ   ))                      +
                 Expr( *YES )                             +
                 Prompt( 'Object type' )
 
          Elem               *Char       10               +
                 Rstd( *YES )                             +
                 SpcVal(( *ALLOPR    )                    +
                        ( *CREATE    )                    +
                        ( *MOVE      )                    +
                        ( *RESTORE   )                    +
                        ( *RSTOVRJRN ))                   +
                 Expr( *YES )                             +
                 Prompt( 'Option' )
 
