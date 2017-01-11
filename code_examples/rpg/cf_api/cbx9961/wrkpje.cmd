/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( WRKPJE )                                           */
/*           Pgm( CBX9961 )                                          */
/*           SrcMbr( CBX9961X )                                      */
/*           VldCkr( CBX9961V )                                      */
/*           Allow( *INTERACT *IPGM *IREXX *IMOD )                   */
/*           AlwLmtUsr( *NO )                                        */
/*           HlpPnlGrp( CBX9961H )                                   */
/*           HlpId( *CMD )                                           */
/*                                                                   */
/*-------------------------------------------------------------------*/
         Cmd       Prompt( 'Work with Prestart Job Entries' )
 
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
 
