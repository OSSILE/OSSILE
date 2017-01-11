/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( WRKSBSE )                                          */
/*           Pgm( CBX998 )                                           */
/*           SrcMbr( CBX998X )                                       */
/*           VldCkr( CBX998V )                                       */
/*           Allow( *INTERACT *IPGM *IREXX *IMOD )                   */
/*           AlwLmtUsr( *NO )                                        */
/*           HlpPnlGrp( CBX998H )                                    */
/*           HlpId( *CMD )                                           */
/*                                                                   */
/*-------------------------------------------------------------------*/
             Cmd        Prompt( 'Work with Subsystem Entries' )
 
             Parm       SBS         Q0001                            +
                        Dft( *ACTIVE )                               +
                        SngVal(( *ACTIVE ))                          +
                        Prompt( 'Subsystem' )
 
             Parm       EXCLUDE     *Generic    10                   +
                        Dft( *NONE )                                 +
                        SpcVal(( *NONE  ' ' ))                       +
                        Prompt( 'Exclude subsystem library' )
 
 
 Q0001:      Qual                   *Generic    10                   +
                        SpcVal(( *ALL  *ALL ))                       +
                        Expr( *YES )
 
             Qual                   *Name                            +
                        Dft( *LIBL )                                 +
                        SpcVal(( *LIBL    )                          +
                               ( *CURLIB  )                          +
                               ( *USRLIBL )                          +
                               ( *ALLUSR  )                          +
                               ( *ALL     ))                         +
                        Expr( *YES )                                 +
                        Prompt( 'Library' )
 
