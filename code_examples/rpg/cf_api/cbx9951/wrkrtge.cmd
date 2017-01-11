/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( WRKRTGE )                                          */
/*           Pgm( CBX9951 )                                           */
/*           SrcMbr( CBX9951X )                                       */
/*           VldCkr( CBX9951V )                                       */
/*           Allow( *INTERACT *IPGM *IREXX *IMOD )                   */
/*           AlwLmtUsr( *NO )                                        */
/*           HlpPnlGrp( CBX9951H )                                    */
/*           HlpId( *CMD )                                           */
/*                                                                   */
/*-------------------------------------------------------------------*/
             Cmd        Prompt( 'Work with Routing Entries' )
 
             Parm       SBS         Q0001                            +
                        Min( 1 )                                     +
                        Prompt( 'Subsystem' )
 
 
 Q0001:      Qual                   *Name                            +
                        Expr( *YES )
 
             Qual                   *Name                            +
                        Dft( *LIBL )                                 +
                        SpcVal(( *LIBL ) ( *CURLIB ))                +
                        Expr( *YES )                                 +
                        Prompt( 'Library' )
 
