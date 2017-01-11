/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( WRKCMNE )                                          */
/*           Pgm( CBX9971 )                                          */
/*           SrcMbr( CBX9971X )                                      */
/*           VldCkr( CBX9971V )                                      */
/*           Allow( *INTERACT *IPGM *IREXX *IMOD )                   */
/*           AlwLmtUsr( *NO )                                        */
/*           HlpPnlGrp( CBX9971H )                                   */
/*           HlpId( *CMD )                                           */
/*                                                                   */
/*-------------------------------------------------------------------*/
         Cmd       Prompt( 'Work with Communication Entrs' )
 
         Parm      SBS         Q0001                            +
                   Min( 1 )                                     +
                   Prompt( 'Subsystem' )
 
Q0001:   Qual                  *Name                            +
                   Expr( *YES )
 
         Qual                  *Name                            +
                   Dft( *LIBL )                                 +
                   SpcVal(( *LIBL ) ( *CURLIB ))                +
                   Expr( *YES )                                 +
                   Prompt( 'Library' )
 
