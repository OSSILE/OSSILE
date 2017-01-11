/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( WRKWSE )                                           */
/*           Pgm( CBX9972 )                                          */
/*           SrcMbr( CBX9972X )                                      */
/*           VldCkr( CBX9972V )                                      */
/*           Allow( *INTERACT *IPGM *IREXX *IMOD )                   */
/*           AlwLmtUsr( *NO )                                        */
/*           HlpPnlGrp( CBX9972H )                                   */
/*           HlpId( *CMD )                                           */
/*                                                                   */
/*-------------------------------------------------------------------*/
         Cmd       Prompt( 'Work with Work Station Entries' )
 
         Parm      SBS         Q0001                            +
                   Min( 1 )                                     +
                   Prompt( 'Subsystem' )
 
         Parm      ENTTYPE     *Char       5                    +
                   Rstd( *YES )                                 +
                   Dft( *NAME )                                 +
                   SpcVal(( *NAME ) ( *TYPE ))                  +
                   Prompt( 'Work station entry type' )
 
Q0001:   Qual                  *Name                            +
                   Expr( *YES )
 
         Qual                  *Name                            +
                   Dft( *LIBL )                                 +
                   SpcVal(( *LIBL ) ( *CURLIB ))                +
                   Expr( *YES )                                 +
                   Prompt( 'Library' )
 
