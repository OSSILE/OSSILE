/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( WRKJOBQE )                                         */
/*           Pgm( CBX9952 )                                          */
/*           SrcMbr( CBX9952X )                                      */
/*           VldCkr( CBX9952V )                                      */
/*           Allow( *INTERACT *IPGM *IREXX *IMOD )                   */
/*           AlwLmtUsr( *NO )                                        */
/*           HlpPnlGrp( CBX9952H )                                   */
/*           HlpId( *CMD )                                           */
/*                                                                   */
/*-------------------------------------------------------------------*/
             Cmd        Prompt( 'Work with Job Queue Entries' )
 
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
 
