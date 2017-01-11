/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( WRKAJE )                                           */
/*           Pgm( CBX9962 )                                          */
/*           SrcMbr( CBX9962X )                                      */
/*           VldCkr( CBX9962V )                                      */
/*           Allow( *INTERACT *IPGM *IREXX *IMOD )                   */
/*           AlwLmtUsr( *NO )                                        */
/*           HlpPnlGrp( CBX9962H )                                   */
/*           HlpId( *CMD )                                           */
/*                                                                   */
/*-------------------------------------------------------------------*/
             Cmd        Prompt( 'Work with Autostart Job Entrs' )
 
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
 
